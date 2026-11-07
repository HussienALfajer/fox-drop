import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../api.dart';
import '../auth.dart';
import 'alerts.dart';
import 'board.dart';
import 'commands.dart';
import 'prompts.dart';
import 'texts.dart';

/// The server time, once a second, for every countdown on the board.
final tickProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final clock = ref.watch(serverClockProvider);
  return Stream.periodic(const Duration(seconds: 1), (_) => clock.now());
});

/// Keeps the screen on while the board shows, so the ring is heard (owner
/// decision 2026-11-07: the app rings while it is open). Tests replace it.
final keepScreenOnProvider = Provider<void Function(bool on)>(
  (ref) =>
      (on) => unawaited(WakelockPlus.toggle(enable: on)),
);

/// The orders screen (RA §8.2): four columns on a tablet, four tabs on a
/// phone, the stacked prompts of what rings on top, and the offline bar.
/// Unstyled until the design (the design stop).
class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: BoardColumn.values.length,
    vsync: this,
  );
  late final void Function(bool) _keepScreenOn = ref.read(keepScreenOnProvider);
  late final Ringer _ringer = ref.read(ringerProvider);
  // Android may end the Flutter engine while the process lives on; the
  // ring must not outlive it (RA §4.4).
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onDetach: _ringer.stop,
  );

  @override
  void initState() {
    super.initState();
    _keepScreenOn(true);
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _ringer.stop();
    _keepScreenOn(false);
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.watch(boardAlertsProvider);
    ref.listen(boardNoticesProvider, (previous, notices) {
      final messenger = ScaffoldMessenger.of(context);
      for (final notice in notices) {
        messenger.showSnackBar(
          SnackBar(content: Text(noticeText(l10n, notice))),
        );
      }
    });
    final state = ref.watch(boardProvider).value;
    final board = state?.value;
    final now =
        ref.watch(tickProvider).value ?? ref.read(serverClockProvider).now();
    // RA §8.2: a ringing new order switches to «جديدة».
    ref.listen(boardProvider, (previous, next) {
      final before = previous?.value?.value;
      final after = next.value?.value;
      if (after == null) return;
      final had = {
        for (final o in before?.orders ?? const <BoardOrder>[]) o.id,
      };
      final newOrder = after.orders.any(
        (o) => o.status == OrderStatus.placed && !had.contains(o.id),
      );
      if (newOrder) _tabs.animateTo(BoardColumn.incoming.index);
    });

    String header(BoardColumn column) {
      final orders = board == null
          ? const <BoardOrder>[]
          : columnOrders(board, column);
      final late = orders.where((o) => isLate(o, now)).length;
      final title = columnTitle(l10n, column);
      return late == 0
          ? l10n.merchantColumnCount(title, orders.length)
          : l10n.merchantColumnLate(title, orders.length, late);
    }

    Widget column(BoardColumn column) {
      if (board == null) {
        return const Center(child: CircularProgressIndicator());
      }
      final orders = columnOrders(board, column);
      return RefreshIndicator(
        onRefresh: () async => ref.read(boardFeedProvider)?.refresh(),
        child: orders.isEmpty
            ? ListView(
                children: [ListTile(title: Text(l10n.merchantBoardEmpty))],
              )
            : ListView(
                children: [
                  for (final order in orders)
                    OrderCard(order: order, board: board, now: now),
                ],
              ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // RA §4.1: the tablet layout from 840 dp.
        final wide = constraints.maxWidth >= 840;
        final body = wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in BoardColumn.values)
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(title: Text(header(c))),
                          Expanded(child: column(c)),
                        ],
                      ),
                    ),
                ],
              )
            : TabBarView(
                controller: _tabs,
                children: [for (final c in BoardColumn.values) column(c)],
              );
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.merchantAppName),
            actions: [
              TextButton(
                onPressed: () =>
                    ref.read(merchantAuth.session.notifier).signOut(),
                child: Text(l10n.signOut),
              ),
            ],
            bottom: wide
                ? null
                : TabBar(
                    controller: _tabs,
                    isScrollable: true,
                    tabs: [
                      for (final c in BoardColumn.values)
                        Tab(key: Key('tab-${c.name}'), text: header(c)),
                    ],
                  ),
          ),
          body: BoardAlertsLayer(child: body),
        );
      },
    );
  }
}

/// What every board screen shows over its content (RA §4.4, §4.7): the
/// offline bar, and the stacked prompts of what rings, so opening the detail
/// never hides a ringing order. Back does not leave the app while something
/// rings: on Android that would end the screen with the ring still on.
class BoardAlertsLayer extends ConsumerWidget {
  const BoardAlertsLayer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(boardProvider).value;
    final board = state?.value;
    final now =
        ref.watch(tickProvider).value ?? ref.read(serverClockProvider).now();
    final rings = board == null ? const <Ringing>[] : ringing(board);
    return PopScope(
      canPop: rings.isEmpty,
      child: Column(
        children: [
          if (state != null && !state.live)
            MaterialBanner(
              key: const Key('offline'),
              content: Text(l10n.merchantOffline),
              actions: const [SizedBox.shrink()],
            ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: child),
                if (board != null && rings.isNotEmpty)
                  Positioned.fill(
                    child: RingingPrompt(items: rings, board: board, now: now),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact card (RA §8.2): number and time since placing, the item count
/// and first items, the captain line, the column's timer and its one main
/// button.
class OrderCard extends ConsumerWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.board,
    required this.now,
  });

  final BoardOrder order;
  final Board board;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final late = isLate(order, now);
    final line = captainLine(order);
    final timer = columnTimer(l10n, order, now);
    final count = order.lines.fold<int>(0, (n, line) => n + line.quantity);
    return Card(
      key: Key('card-${order.id}'),
      // RA §8.2: late cards turn red.
      color: late ? Theme.of(context).colorScheme.errorContainer : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: () => context.push('/orders/${order.id}'),
            title: Text(
              '#${order.number} · '
              '${l10n.merchantSincePlaced(now.difference(order.placedAt).inMinutes)}',
            ),
            subtitle: Text(
              [
                l10n.merchantItemCount(count),
                order.lines
                    .take(2)
                    .map((l) => '${l.quantity} × ${l.name}')
                    .join('، '),
                if (line != null) captainLineText(l10n, line, now),
                ?timer,
              ].join('\n'),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: MainAction(order: order, board: board),
          ),
        ],
      ),
    );
  }
}

/// The card's one main button (RA §8.2): «قبول — {د} د», «الطلب جاهز» or
/// «تأكيد الاستلام», with «جارٍ الإرسال…» while its command waits.
class MainAction extends ConsumerWidget {
  const MainAction({super.key, required this.order, required this.board});

  final BoardOrder order;
  final Board board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(boardCommandsProvider).contains(order.id);
    final commands = ref.read(boardCommandsProvider.notifier);
    final request = openRequest(order);
    final (String label, Future<CommandNotice?> Function())? action =
        request != null
        ? (
            l10n.merchantConfirmPickup,
            () => commands.confirmPickup(order.id, request.id),
          )
        : switch (order.status) {
            OrderStatus.placed => (
              l10n.merchantAccept(
                clampPrep(board.prepTime, board.prepTime.defaultMin),
              ),
              () => commands.accept(
                order.id,
                clampPrep(board.prepTime, board.prepTime.defaultMin),
              ),
            ),
            OrderStatus.accepted => (
              l10n.merchantReady,
              () => commands.ready(order.id),
            ),
            _ => null,
          };
    if (action == null) return const SizedBox.shrink();
    return FilledButton(
      key: Key('action-${order.id}'),
      onPressed: sending
          ? null
          : () async {
              final notice = await action.$2();
              if (notice != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(commandText(l10n, notice))),
                );
              }
            },
      child: Text(sending ? l10n.merchantSending : action.$1),
    );
  }
}
