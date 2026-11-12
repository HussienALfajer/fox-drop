import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:core_platform/core_platform.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'custody.dart';
import 'custody_screen.dart';
import 'peak_bonus.dart';
import 'platform.dart';
import 'settings/max_pickup_form.dart';
import 'terms.dart';
import 'work/alerts.dart';
import 'work/commands.dart';
import 'work/door_payment.dart';
import 'work/location.dart';
import 'work/offer_sheet.dart';
import 'work/emergency_button.dart';
import 'work/order_view.dart';
import 'work/problem_sheet.dart';
import 'work/texts.dart';
import 'work/work.dart';

/// The captain's home (CA §6, §7): the availability and «متصل», or the
/// active order; the offer over either. Unstyled until the design (the design
/// stop in the root CLAUDE.md).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final live = ref.watch(workProvider).value;
    final work = live?.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.captainAppName),
        // CA §11.4: the work rules always one tap away; CA §13: the FAQ.
        actions: [
          TextButton(
            onPressed: () => context.push('/work-rules'),
            child: Text(l10n.captainWorkRules),
          ),
          TextButton(
            onPressed: () => context.push('/faq'),
            child: Text(l10n.faqTitle),
          ),
          TextButton(
            onPressed: () => context.push('/custody'),
            child: Text(l10n.captainCustodyTitle),
          ),
          TextButton(
            onPressed: () => context.push('/settings'),
            child: Text(l10n.captainSettings),
          ),
        ],
      ),
      body: WorkLayer(
        live: live,
        child: switch (work) {
          null =>
            live?.failed == true
                ? Center(child: Text(l10n.statusError))
                : const Center(child: CircularProgressIndicator()),
          Work(order: final order?) => Column(
            children: [
              CashLines(availability: work.availability),
              _LastOrderBar(work: work),
              ProblemBar(order: order),
              EmergencyButton(order: order),
              Expanded(child: OrderView(order: order)),
            ],
          ),
          _ => _AvailabilityView(work: work),
        },
      ),
    );
  }
}

/// CA §7.3, K13: during an active order «لا أريد طلبات جديدة» replaces
/// «متصل»; the captain cancels their own mode before the order ends, never
/// one operations, a suspension or a termination set (CA §7.6, K18), whose
/// reason shows instead.
class _LastOrderBar extends ConsumerWidget {
  const _LastOrderBar({required this.work});

  final Work work;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = work.availability.availability;
    final on = state.state == AvailabilityState.lastOrder;
    final imposed = l10n.lastOrderText(work.availability);
    final sending = ref.watch(commandsProvider).contains('availability');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (imposed != null)
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Text(imposed, key: const Key('last-order-imposed')),
          )
        else
          SwitchListTile(
            key: const Key('last-order-switch'),
            title: Text(
              sending ? l10n.captainSending : l10n.captainLastOrderSwitch,
            ),
            subtitle: on ? Text(l10n.captainLastOrderOn) : null,
            value: on,
            onChanged: sending
                ? null
                : (value) async {
                    final messenger = ScaffoldMessenger.of(context);
                    final notice = await ref
                        .read(commandsProvider.notifier)
                        .setLastOrder(value);
                    if (notice != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.noticeText(notice))),
                      );
                    }
                  },
          ),
      ],
    );
  }
}

/// CA §10.3–10.4 (slice 2.17d): the amber banner at
/// captain.custody_warn_pct («اقتربت من حد العهدة…», amber being the spec's
/// colour; otherwise unstyled until the design), and the hand-in lines: the
/// end of the offers after a cutoff the captain was online across, or the
/// grace running.
class CashLines extends StatelessWidget {
  const CashLines({super.key, required this.availability});

  final Availability availability;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lines = l10n.cashLines(availability);
    final warn = availability.custody.warn;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, line) in lines.indexed)
          if (index == 0 && warn)
            ColoredBox(
              key: const Key('custody-warning'),
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(8),
                child: Text(line),
              ),
            )
          else
            Text(line, key: Key('cash-line-$index')),
      ],
    );
  }
}

/// CA §7: the state, why no offers come, the cash held, and «متصل».
class _AvailabilityView extends ConsumerWidget {
  const _AvailabilityView({required this.work});

  final Work work;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final availability = work.availability;
    final state = availability.availability;
    final usage = availability.custody.usage;
    final sending = ref.watch(commandsProvider).contains('availability');
    final suspended = state.state == AvailabilityState.suspended;
    Future<void> toggle(bool on) async {
      // K2: «أقصى مبلغ أحمله» is asked the first time while unanswered.
      if (on) await askMaxPickupUnanswered(context, ref);
      if (!context.mounted) return;
      final commands = ref.read(commandsProvider.notifier);
      final notice = on
          ? await commands.goOnline()
          : await commands.goOffline();
      if (!context.mounted) return;
      // CA §7.2, K7: «Terms not accepted» opens the terms screen.
      if (notice is OnlineBlocked &&
          notice.blocks.any((block) => block['kind'] == 'terms_not_accepted')) {
        final terms = ref.read(termsCheckProvider);
        unawaited(terms.check());
        unawaited(context.push('/terms'));
      }
      if (notice != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noticeText(notice, currency: usage.currency)),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        CashLines(availability: availability),
        Text(
          l10n.stateText(state.state),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        for (final reason in l10n.noOffersTexts(availability)) Text(reason),
        // CA §12.5 (slice 2.16): «مكافأة الذروة الآن…» and the windows.
        PeakBonusLine(onWindows: () => context.push('/peak-bonus')),
        if (l10n.offersExpiredText(availability) case final text?)
          Text(text, key: const Key('offers-expired')),
        if (suspended && state.suspensionReason != null)
          Text(
            state.suspendedUntil == null
                ? l10n.captainBlockSuspended(state.suspensionReason!)
                : l10n.captainBlockSuspendedUntil(
                    l10n.formatDate(state.suspendedUntil!),
                    state.suspensionReason!,
                  ),
          ),
        if (BigInt.parse(usage.amount) > BigInt.zero)
          Text(
            l10n.captainOwes(l10n.formatMoney(usage.amount, usage.currency)),
          ),
        // CA §10.4: the cash limit's bar.
        CustodyLimitBar(
          usage: usage.amount,
          limit: availability.custody.limit.amount,
          currency: availability.custody.limit.currency,
        ),
        // K7: a new version waits for acceptance before going online; an
        // online captain keeps the offers (CA §7.2).
        if (!work.online && ref.watch(termsPendingProvider))
          ListTile(
            key: const Key('terms-pending'),
            title: Text(l10n.captainTermsPendingBanner),
            trailing: TextButton(
              onPressed: () => context.push('/terms'),
              child: Text(l10n.termsTitle),
            ),
          ),
        SwitchListTile(
          key: const Key('online-switch'),
          title: Text(sending ? l10n.captainSending : l10n.captainOnlineSwitch),
          value: work.online,
          onChanged: sending || suspended ? null : toggle,
        ),
        if (!work.online) const SignOutButton(),
      ],
    );
  }
}

/// Over the home: the offline bar (CA §4.6), the offer and its ring (CA
/// §8.2, §4.4), the chimes and messages of CA §14, the hand-in reminder
/// (CA §7.5), the order summary (CA §9.8) and the order operations
/// cancelled (CA §9.10). It also starts and stops the
/// location with the availability (CA §4.3) and keeps the screen on while
/// online.
class WorkLayer extends ConsumerStatefulWidget {
  const WorkLayer({super.key, required this.live, required this.child});

  final LiveState<Work>? live;
  final Widget child;

  @override
  ConsumerState<WorkLayer> createState() => _WorkLayerState();
}

class _WorkLayerState extends ConsumerState<WorkLayer>
    with WidgetsBindingObserver {
  Timer? _tick;
  Timer? _offlineChime;
  String? _expiredFetched;
  DateTime? _cashFetched;
  late final Ringer _ringer = ref.read(ringerProvider);
  late final void Function(bool on) _keepScreenOn = ref.read(
    keepScreenOnProvider,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Read now: the providers cannot be read in dispose, which a screen
    // left before its first offer (such as for /blocked) reaches unread.
    _keepScreenOn;
    _ringer;
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    _offlineChime?.cancel();
    _ringer.stop();
    _keepScreenOn(false);
    super.dispose();
  }

  // The plugin's sound would outlive the Flutter engine.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) _ringer.stop();
  }

  Work? get _work => widget.live?.value;

  void _onTick() {
    if (!mounted) return;
    setState(() {});
    final now = ref.read(serverClockProvider).now();
    final offer = _work?.offer;
    final ringing = ringingOffer(_work, now, ref.read(answeredProvider).offers);
    if (ringing != null) {
      _ringer.ring();
    } else {
      _ringer.stop();
    }
    // A lost event never leaves an expired offer on screen.
    if (offer != null &&
        !now.isBefore(offer.expiresAt) &&
        _expiredFetched != offer.id) {
      _expiredFetched = offer.id;
      unawaited(ref.read(workFeedProvider)?.refresh());
    }
    // CA §10.3 (slice 2.17d): no event marks the cutoff, the end of the
    // offers after it or the grace's end, so the state is read again then.
    final work = _work;
    if (work != null) {
      final turn = nextCashTurn(work.availability);
      if (!now.isBefore(turn) && _cashFetched != turn) {
        _cashFetched = turn;
        unawaited(ref.read(workFeedProvider)?.refresh());
      }
    }
  }

  void _show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(workProvider, (previous, next) {
      // While loading (a sign-out, a new session) the provider still holds
      // the last state, which must not start the location again.
      if (next.isLoading) return;
      final before = previous?.value?.value;
      final after = next.value?.value;
      final live = next.value?.live ?? false;
      if (live) {
        _offlineChime?.cancel();
        _offlineChime = null;
      } else if (after != null && _offlineChime == null) {
        _offlineChime = Timer(offlineChimeAfter, _ringer.chime);
      }
      if (after == null) return;
      final tracker = ref.read(locationTrackerProvider);
      if (after.online) {
        tracker.start();
      } else {
        tracker.stop();
      }
      _keepScreenOn(after.online);
      if (identical(before, after)) return;
      if (handInAfterLastOrder(before, after) case final handIn?) {
        ref.read(handInProvider.notifier).show(handIn);
      }
      final now = ref.read(serverClockProvider).now();
      for (final alert in alertStep(
        before,
        after,
        now,
        ref.read(answeredProvider),
      )) {
        // The cancellation and withdrawal cards say it, with their sound.
        if (alert is OrderCancelled ||
            alert is OrderWithdrawn ||
            alert is OrderHandedOver) {
          _ringer.cancellation();
          continue;
        }
        // The outcome card says it; the chime alone.
        if (alert is OutcomeSet) {
          _ringer.chime();
          continue;
        }
        if (alert.chimes) _ringer.chime();
        _show(l10n.alertText(alert));
      }
    });
    final work = _work;
    final now = ref.watch(serverClockProvider).now();
    final ringing = ringingOffer(work, now, ref.watch(answeredProvider).offers);
    // An answer on its way keeps the sheet, with «جارٍ الإرسال…».
    final sending = work?.offer;
    final offer =
        ringing ??
        (sending != null && ref.watch(commandsProvider).contains(sending.id)
            ? sending
            : null);
    final summary = ref.watch(summaryProvider);
    final handIn = ref.watch(handInProvider);
    return PopScope(
      canPop: offer == null,
      child: Stack(
        children: [
          Column(
            children: [
              if (widget.live != null && !widget.live!.live)
                MaterialBanner(
                  key: const Key('offline'),
                  content: Text(l10n.captainNoConnection),
                  actions: const [SizedBox.shrink()],
                ),
              // CA §6.3 item 2, after no connection.
              if (ref.watch(emergencyStopProvider) case final stop?)
                EmergencyStopBanner(check: stop),
              Expanded(child: widget.child),
            ],
          ),
          if (summary != null)
            Positioned.fill(child: _SummaryCard(summary: summary)),
          if (handIn != null)
            Positioned.fill(child: _HandInCard(amount: handIn)),
          if (work?.cancelled case final cancelled?)
            Positioned.fill(child: _CancelledCard(cancelled: cancelled)),
          if (work?.withdrawn case final withdrawn?)
            Positioned.fill(child: _WithdrawnCard(withdrawn: withdrawn)),
          if (work?.ended case final ended?)
            Positioned.fill(child: _EndedCard(ended: ended)),
          if (work?.handedOver case final handedOver?)
            Positioned.fill(child: _HandedOverCard(handedOver: handedOver)),
          if (offer != null) Positioned.fill(child: OfferSheet(offer: offer)),
        ],
      ),
    );
  }
}

/// CA §7.5, C13: the cash to hand in after going offline, with the office's
/// closing time or when it opens, and the office on the map.
class _HandInCard extends ConsumerWidget {
  const _HandInCard({required this.amount});

  final Money amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final office = ref.watch(
      workProvider.select((live) => live.value?.value?.availability.office),
    );
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.handInText(amount, office), key: const Key('hand-in')),
            if (office != null) OfficeMapButton(office: office),
            FilledButton(
              onPressed: () => ref.read(handInProvider.notifier).show(null),
              child: Text(l10n.captainOk),
            ),
          ],
        ),
      ),
    );
  }
}

/// CA §9.10: the order operations cancelled, what to do about the cash paid
/// to the restaurant and the compensation, until «حسناً»; the availability
/// shows under it.
class _CancelledCard extends ConsumerWidget {
  const _CancelledCard({required this.cancelled});

  final Cancelled cancelled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(commandsProvider).contains(cancelled.orderId);
    final cash = l10n.cashText(cancelled.cash);
    final compensation = cancelled.compensation;
    return Material(
      child: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.captainTaskCancelled(cancelled.reason),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (cash != null) Text(cash),
          if (compensation != null)
            Text(
              l10n.captainCompensation(
                l10n.formatMoney(compensation.amount, compensation.currency),
              ),
            ),
          FilledButton(
            onPressed: sending
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final notice = await ref
                        .read(commandsProvider.notifier)
                        .acknowledgeCancellation(cancelled.orderId);
                    if (notice != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.noticeText(notice))),
                      );
                    }
                  },
            child: Text(sending ? l10n.captainSending : l10n.captainOk),
          ),
        ],
      ),
    );
  }
}

/// CA §9.10 (slice 2.12a): the order operations took from the captain before
/// the pickup, and what to do about the cash paid to the restaurant, until
/// «حسناً»; the availability shows under it.
class _WithdrawnCard extends ConsumerWidget {
  const _WithdrawnCard({required this.withdrawn});

  final Withdrawn withdrawn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(commandsProvider).contains(withdrawn.orderId);
    final cash = l10n.withdrawnCashText(withdrawn.cash);
    return Material(
      child: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.captainOrderWithdrawn(withdrawn.reason),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (cash != null) Text(cash),
          FilledButton(
            onPressed: sending
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final notice = await ref
                        .read(commandsProvider.notifier)
                        .acknowledgeWithdrawal(withdrawn.orderId);
                    if (notice != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.noticeText(notice))),
                      );
                    }
                  },
            child: Text(sending ? l10n.captainSending : l10n.captainOk),
          ),
        ],
      ),
    );
  }
}

/// CA §9.10.1 (slice 2.12b): the order the captain handed to another; they
/// are offline now (K17). Until «حسناً»; the availability shows under it.
class _HandedOverCard extends ConsumerWidget {
  const _HandedOverCard({required this.handedOver});

  final HandedOver handedOver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(commandsProvider).contains(handedOver.orderId);
    return Material(
      child: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.captainHandedOver(handedOver.toCaptainName),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          FilledButton(
            onPressed: sending
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final notice = await ref
                        .read(commandsProvider.notifier)
                        .acknowledgeHandover(handedOver.orderId);
                    if (notice != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.noticeText(notice))),
                      );
                    }
                  },
            child: Text(sending ? l10n.captainSending : l10n.captainOk),
          ),
        ],
      ),
    );
  }
}

/// CA §9.10, §9.12 (slice 2.11a): the order operations ended with an outcome,
/// where the food goes, and the pay or the charge, until «حسناً»; the
/// availability shows under it.
class _EndedCard extends ConsumerWidget {
  const _EndedCard({required this.ended});

  final Ended ended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(commandsProvider).contains(ended.orderId);
    final outcome = outcomeText(l10n, ended.outcome);
    final food = foodText(l10n, ended.food);
    final pay = ended.pay;
    final charge = ended.charge;
    return Material(
      child: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.captainOutcomeSet(outcome),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (food != null) Text(food),
          if (pay != null)
            Text(
              l10n.captainOutcomePay(
                l10n.formatMoney(pay.amount, pay.currency),
              ),
            ),
          if (charge != null)
            Text(
              l10n.captainOutcomeCharge(
                l10n.formatMoney(charge.amount, charge.currency),
                outcome,
              ),
            ),
          FilledButton(
            key: const Key('outcome-ok'),
            onPressed: sending
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final notice = await ref
                        .read(commandsProvider.notifier)
                        .acknowledgeOutcome(ended.orderId);
                    if (notice != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.noticeText(notice))),
                      );
                    }
                  },
            child: Text(sending ? l10n.captainSending : l10n.captainOk),
          ),
        ],
      ),
    );
  }
}

/// The order summary (CA §9.8): the pay in its parts, the custody change and
/// the cash to hand in today; the captain is online again at once.
class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pay = summary.pay;
    String money(String amount) => l10n.formatMoney(amount, pay.currency);
    final sending = ref.watch(commandsProvider).contains('availability');
    void close() => ref.read(summaryProvider.notifier).show(null);
    return Material(
      child: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(
            l10n.captainEarned(money(pay.total)),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(l10n.captainPayBase(money(pay.base_))),
          Text(l10n.captainPayDistance(money(pay.distance))),
          if (BigInt.parse(pay.topUp) > BigInt.zero)
            Text(l10n.captainPayTopUp(money(pay.topUp))),
          if (BigInt.parse(pay.waiting) > BigInt.zero)
            Text(l10n.captainPayWaiting(money(pay.waiting))),
          // AP §9.12.5, D15 (slice 2.16): delivered inside a peak window.
          if (BigInt.parse(pay.peak) > BigInt.zero)
            Text(l10n.captainPayPeak(money(pay.peak))),
          Text(
            l10n.captainCustodyChanged(
              l10n.signedMoney(
                summary.custodyChange.amount,
                summary.custodyChange.currency,
              ),
            ),
          ),
          Text(
            l10n.captainHandInToday(
              l10n.formatMoney(
                summary.handInToday.amount,
                summary.handInToday.currency,
              ),
            ),
          ),
          FilledButton(onPressed: close, child: Text(l10n.captainKeepWorking)),
          OutlinedButton(
            onPressed: sending
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    close();
                    final notice = await ref
                        .read(commandsProvider.notifier)
                        .goOffline();
                    if (notice != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.noticeText(notice))),
                      );
                    }
                  },
            child: Text(l10n.captainEndWork),
          ),
        ],
      ),
    );
  }
}
