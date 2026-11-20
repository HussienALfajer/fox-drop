import 'dart:ui' as ui;

import 'package:core_api/core_api.dart' show Date;
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../account/account.dart' show noonOf;
import '../account/records.dart' show imageRatio, imageSharerProvider;
import 'reports.dart';

/// «الملخص اليومي» (RA §11 «Daily summary image»): a chosen business day's
/// key numbers against the day before, as a plain table, and «مشاركة كصورة»
/// through the system share sheet (owner decision 2026-11-20: the image's
/// own layout comes with the design, as the statement's).
class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  /// The summary as the image shows it.
  final _image = GlobalKey();
  bool _sharing = false;

  /// The day shown, `YYYY-MM-DD`; null until today's business day is known.
  String? _day;

  Future<void> _share(String day) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sharer = ref.read(imageSharerProvider);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    setState(() => _sharing = true);
    try {
      final boundary =
          _image.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(
        pixelRatio: imageRatio(pixelRatio, boundary.size),
      );
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      await sharer(bytes!.buffer.asUint8List(), 'summary-$day.png');
    } on Object catch (error) {
      debugPrint('Summary share: $error');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.merchantReportsShareFailed)),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _pick(String shown, String today) async {
    DateTime parse(String day) => DateTime.parse('${day}T00:00:00Z');
    final picked = await showDatePicker(
      context: context,
      initialDate: parse(shown),
      firstDate: parse(today).subtract(const Duration(days: 365)),
      lastDate: parse(today),
    );
    if (picked == null) return;
    setState(
      () => _day = DateTime.utc(
        picked.year,
        picked.month,
        picked.day,
      ).toIso8601String().substring(0, 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Today's business day: the start of «اليوم»'s period.
    final today = ref.watch(reportsProvider(ReportsPeriod.today));
    final todayDay = today.value == null
        ? null
        : businessDayOf(today.value!.from);
    final day = _day ?? todayDay;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantReportsOpenSummary)),
      body: switch ((today, day)) {
        (AsyncError(:final error), _) => _failed(context, error),
        (_, final String day) => _summary(context, day, todayDay!),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _failed(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Text(switch (refusalOf(error)) {
        ReportsRefusal.terminated => l10n.merchantReportsTerminated,
        ReportsRefusal.ownersOnly => l10n.merchantReportsNotAllowed,
        null => l10n.merchantReportsFailed,
      }),
    );
  }

  Widget _summary(BuildContext context, String day, String today) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(summaryProvider(day));
    final date = DateTime.parse('${day}T00:00:00Z');
    final title = l10n.merchantReportsSummaryTitle(
      l10n.formatDate(noonOf(Date(date.year, date.month, date.day))),
    );
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            key: const Key('summary-pick-day'),
            onPressed: () => _pick(day, today),
            child: Text(l10n.merchantReportsSummaryPickDay),
          ),
        ),
        switch (summary) {
          AsyncData(:final value) => Column(
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
                    child: Column(
                      key: const Key('summary'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(l10n.merchantReportsSummaryCompared),
                        Table(
                          children: [
                            for (final metric in summaryMetrics)
                              TableRow(
                                key: ValueKey('summary-${metric.name}'),
                                children: [
                                  Text(l10n.metricLabel(metric)),
                                  Text(
                                    l10n.metricValue(
                                      metric,
                                      value.current,
                                      value.currency,
                                    ),
                                  ),
                                  Text(
                                    l10n.changeText(
                                      changeOf(
                                        metric.of(value.current),
                                        metric.of(value.previous),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('summary-share'),
                onPressed: _sharing ? null : () => _share(day),
                child: Text(l10n.merchantReportsShare),
              ),
            ],
          ),
          AsyncError(:final error) => Column(
            children: [
              _failed(context, error),
              TextButton(
                onPressed: () => ref.invalidate(summaryProvider(day)),
                child: Text(l10n.merchantRetry),
              ),
            ],
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ],
    );
  }
}
