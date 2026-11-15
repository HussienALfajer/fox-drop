import 'dart:ui' as ui;

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'statements.dart';

/// CA §10.7: the weekly statements, newest first, reached from «أرباحي».
/// Unstyled until the design.
class StatementsScreen extends ConsumerWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statements = ref.watch(statementsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainStatementsTitle)),
      body: switch (statements) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Text(l10n.captainStatementsNone),
        ),
        AsyncData(:final value) => ListView(
          key: const Key('statements'),
          children: [
            for (final statement in value)
              ListTile(
                title: Text(l10n.summaryText(statement)),
                subtitle: Text(l10n.captainStatementOrders(statement.orders)),
                onTap: () =>
                    context.push('/earnings/statements/${statement.id}'),
              ),
          ],
        ),
        AsyncError() => _Retry(
          onRetry: () => ref.invalidate(statementsProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// CA §10.7 «كشف الأسبوع»: the period, the orders, pay by part, bonuses,
/// charges, instalments and the net paid, as the desk prints it, and
/// «مشاركة كصورة». A plain layout until the design, the image included.
class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key, required this.statementId});

  final String statementId;

  @override
  ConsumerState<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends ConsumerState<StatementScreen> {
  /// The statement as the image shows it.
  final _image = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sharer = ref.read(imageSharerProvider);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    setState(() => _sharing = true);
    try {
      final boundary =
          _image.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      await sharer(
        bytes!.buffer.asUint8List(),
        'statement-${widget.statementId}.png',
      );
    } on Object catch (error) {
      debugPrint('Statement share: $error');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.captainStatementShareFailed)),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statement = ref.watch(statementProvider(widget.statementId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainStatementTitle)),
      body: switch (statement) {
        AsyncData(:final value) => SingleChildScrollView(
          key: const Key('statement'),
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RepaintBoundary(
                key: _image,
                // The image needs its own background: a PNG is otherwise
                // transparent.
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(8),
                    child: _StatementView(statement: value),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('statement-share'),
                onPressed: _sharing ? null : _share,
                child: Text(l10n.captainStatementShare),
              ),
            ],
          ),
        ),
        AsyncError() => _Retry(
          onRetry: () => ref.invalidate(statementProvider(widget.statementId)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _StatementView extends StatelessWidget {
  const _StatementView({required this.statement});

  final Statement statement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.captainStatementTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(l10n.captainStatementCaptain(statement.captainName)),
        Text(l10n.periodText(statement)),
        Text(l10n.captainStatementOrders(statement.orders)),
        const SizedBox(height: 8),
        for (final line in l10n.statementLines(statement)) Text(line),
      ],
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.signInError),
          TextButton(onPressed: onRetry, child: Text(l10n.captainRetry)),
        ],
      ),
    );
  }
}
