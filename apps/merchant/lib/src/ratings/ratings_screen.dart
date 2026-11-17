import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ratings.dart';

/// «التقييمات», the owners' (RA §13, §6.1 row 7): the period's average,
/// count and distribution by stars, the period and stars filters, and each
/// rating's stars, reasons, comment and date, never the customer or the
/// order. No replies (R16). Unstyled until the design.
class RatingsScreen extends ConsumerWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ratings = ref.watch(ratingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.merchantRatings),
        actions: [
          IconButton(
            key: const Key('ratings-refresh'),
            tooltip: l10n.merchantRetry,
            onPressed: () => ref.invalidate(ratingsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (ratings) {
        AsyncData(:final value) => _RatingsView(view: value),
        // A 403 (a cashier, a terminated restaurant) would fail again.
        AsyncError(:final error)
            when error is DioException && error.response?.statusCode == 403 =>
          Center(child: Text(l10n.merchantRatingsNotAllowed)),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.merchantRatingsFailed),
              TextButton(
                onPressed: () => ref.invalidate(ratingsProvider),
                child: Text(l10n.merchantRetry),
              ),
            ],
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _RatingsView extends ConsumerWidget {
  const _RatingsView({required this.view});

  final RatingsView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(ratingsProvider.notifier);
    final filter = view.filter;
    final summary = view.summary;
    final average = summary.average;
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final period in RatingPeriod.values)
              ChoiceChip(
                key: Key('ratings-period-${period.name}'),
                label: Text(l10n.periodLabel(period)),
                selected: filter.period == period,
                onSelected: (_) => notifier.show(
                  RatingsFilter(period: period, stars: filter.stars),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          key: const Key('ratings-average'),
          average == null
              ? l10n.merchantRatingsNone
              : l10n.merchantRatingsAverage(averageText(average)),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          key: const Key('ratings-count'),
          l10n.merchantRatingsCount(summary.count),
        ),
        const SizedBox(height: 8),
        for (final row in summary.distribution)
          Row(
            key: Key('ratings-stars-${row.stars}'),
            children: [
              SizedBox(
                width: 56,
                child: Text(l10n.merchantRatingsStarsRow(row.stars)),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: summary.count == 0 ? 0 : row.count / summary.count,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text('${row.count}', textAlign: TextAlign.end),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              key: const Key('ratings-stars-all'),
              label: Text(l10n.merchantRatingsAllStars),
              selected: filter.stars == null,
              onSelected: (_) =>
                  notifier.show(RatingsFilter(period: filter.period)),
            ),
            for (final stars in [5, 4, 3, 2, 1])
              ChoiceChip(
                key: Key('ratings-filter-$stars'),
                label: Text(l10n.merchantRatingsStarsRow(stars)),
                selected: filter.stars == stars,
                onSelected: (_) => notifier.show(
                  RatingsFilter(period: filter.period, stars: stars),
                ),
              ),
          ],
        ),
        const Divider(),
        if (view.ratings.isEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
            child: Text(
              key: const Key('ratings-empty'),
              l10n.merchantRatingsEmpty,
              textAlign: TextAlign.center,
            ),
          ),
        for (final rating in view.ratings) _RatingTile(rating: rating),
        if (view.next != null)
          Center(
            child: view.loadingMore
                ? const CircularProgressIndicator()
                : TextButton(
                    key: const Key('ratings-more'),
                    onPressed: notifier.more,
                    child: Text(
                      view.moreFailed
                          ? l10n.merchantRatingsMoreFailed
                          : l10n.merchantRatingsMore,
                    ),
                  ),
          ),
      ],
    );
  }
}

class _RatingTile extends StatelessWidget {
  const _RatingTile({required this.rating});

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reasons = l10n.reasonsText(rating);
    final comment = rating.comment;
    return ListTile(
      key: Key('rating-${rating.id}'),
      contentPadding: EdgeInsetsDirectional.zero,
      title: Text(l10n.merchantRatingStars(rating.stars)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reasons.isNotEmpty) Text(reasons),
          if (comment != null) Text(l10n.merchantRatingComment(comment)),
          Text(
            l10n.merchantRatingAt(
              l10n.formatDate(rating.at),
              l10n.formatTime(rating.at),
            ),
          ),
        ],
      ),
    );
  }
}
