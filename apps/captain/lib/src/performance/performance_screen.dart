import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../rating.dart';
import 'performance.dart';

/// CA §11 «أدائي» (slice 2.36b), from «المزيد»: the acceptance rate with the
/// warning below `captain.acceptance_alert_pct` and the last offers counted
/// (time, restaurant, response), on time, the cancellations, the rating
/// (C14), online hours, the violations with their appeal, and the work
/// rules one tap away (CA §11.4). A plain layout until the design.
class PerformanceScreen extends ConsumerWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final performance = ref.watch(performanceProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainPerformance)),
      body: switch (performance) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            _Acceptance(performance: value),
            const SizedBox(height: 16),
            Text(
              value.onTime.counted == 0
                  ? l10n.captainOnTimeNone
                  : l10n.captainOnTime(
                      value.onTime.onTime,
                      value.onTime.counted,
                    ),
            ),
            Text(
              l10n.captainCancellations(value.windowDays, value.cancellations),
            ),
            Text(
              l10n.captainOnlineHours(
                hoursOf(value.online.todayMinutes),
                hoursOf(value.online.weekMinutes),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.captainRating,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const RatingSummary(),
            const SizedBox(height: 16),
            _Violations(performance: value),
            const SizedBox(height: 16),
            ListTile(
              key: const Key('performance-work-rules'),
              title: Text(l10n.captainWorkRules),
              onTap: () => context.push('/work-rules'),
            ),
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(performanceProvider),
            child: Text(l10n.captainRetry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Acceptance extends StatelessWidget {
  const _Acceptance({required this.performance});

  final Performance performance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final acceptance = performance.acceptance;
    final rate = acceptance.rate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rate == null
              ? l10n.captainAcceptanceNone
              : l10n.captainAcceptanceRate(rate),
          key: const Key('performance-rate'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (rate != null)
          Text(
            l10n.captainAcceptanceCounts(
              acceptance.accepted,
              acceptance.answered,
              acceptance.windowOffers,
            ),
          ),
        if (acceptance.warn && rate != null)
          Text(
            l10n.captainAcceptanceWarning(rate),
            key: const Key('performance-warning'),
          ),
        if (acceptance.offers.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            l10n.captainLastOffers,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final offer in acceptance.offers)
            Text(
              l10n.captainOfferLine(
                '${l10n.formatDate(offer.offeredAt)} ${l10n.formatTime(offer.offeredAt)}',
                offer.restaurantName ?? '',
                l10n.responseText(offer.response),
              ),
            ),
        ],
      ],
    );
  }
}

class _Violations extends StatelessWidget {
  const _Violations({required this.performance});

  final Performance performance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.captainViolations,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (performance.violations.isEmpty) Text(l10n.captainViolationsNone),
        for (final violation in performance.violations)
          Padding(
            key: Key('violation-${violation.id}'),
            padding: const EdgeInsetsDirectional.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.captainViolationLine(
                    l10n.formatDate(violation.recordedAt),
                    violation.type,
                    l10n.stepText(violation.step),
                  ),
                ),
                if (violation.orderNumber != null)
                  Text(l10n.captainViolationOrder(violation.orderNumber!)),
                if (violation.suspendedUntil != null)
                  Text(
                    l10n.captainViolationSuspendedUntil(
                      '${l10n.formatDate(violation.suspendedUntil!)} ${l10n.formatTime(violation.suspendedUntil!)}',
                    ),
                  ),
                if (l10n.appealText(appealStateOf(violation)) case final text?)
                  Text(text)
                else
                  TextButton(
                    key: Key('appeal-${violation.id}'),
                    onPressed: () =>
                        context.push('/performance/appeal/${violation.id}'),
                    child: Text(l10n.captainAppeal),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
