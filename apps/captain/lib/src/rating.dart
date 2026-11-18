import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

typedef CaptainRating = CaptainRatingsDtoOutput;

/// CA §11.2 (C14): `GET /v1/captain/ratings`, read each time the screen
/// opens.
final captainRatingProvider = FutureProvider.autoDispose<CaptainRating>((
  ref,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getCaptainApi()
      .captainRatingsRead();
  return answer.data!;
});

/// CA §11.2 «تقييمي» (slice 2.26c): the average over every rating, the count
/// and the reasons customers picked with their counts; never a customer's
/// name nor a comment (CU Q16). It moves into «أدائي» in 2.36.
class RatingScreen extends ConsumerWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rating = ref.watch(captainRatingProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainRating)),
      body: switch (rating) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            Text(
              value.average == null
                  ? l10n.captainRatingNone
                  : l10n.captainRatingAverage(formatAverage(value.average!)),
              key: const Key('rating-average'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(l10n.captainRatingCount(value.count)),
            if (value.reasons.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.captainRatingReasons,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final reason in value.reasons)
                Text(l10n.captainRatingReason(reason.label, reason.count)),
            ],
            const SizedBox(height: 16),
            Text(l10n.captainRatingPrivate),
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(captainRatingProvider),
            child: Text(l10n.captainRetry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
