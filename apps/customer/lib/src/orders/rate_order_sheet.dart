import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../content.dart';
import 'order_live.dart';
import 'rate_order.dart';

/// Opens the rating sheet for the parts left (CU §12.1) and tells the
/// customer how it went. Null when the sheet was put away.
Future<RateOutcome?> showRateOrder(
  BuildContext context,
  CustomerOrder order,
  Set<RatingParty> parts,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final outcome = await showModalBottomSheet<RateOutcome>(
    context: context,
    isScrollControlled: true,
    builder: (_) => RateOrderSheet(orderId: order.id, parts: parts),
  );
  final text = switch (outcome) {
    RateOutcome.sent => l10n.customerRatingThanks,
    RateOutcome.refused => l10n.customerRatingRefused,
    RateOutcome.reasonsChanged => l10n.customerRatingReasonsChanged,
    RateOutcome.failed => l10n.customerTryAgain,
    null => null,
  };
  if (text != null) messenger.showSnackBar(SnackBar(content: Text(text)));
  return outcome;
}

/// CU §12.1: «قيّم المطعم» and «قيّم الكابتن» on one screen, each with its
/// stars (required to send that part), the reason chips of Content's list
/// for the stars and a comment; a part without stars is skipped. Unstyled
/// until the design.
class RateOrderSheet extends ConsumerStatefulWidget {
  const RateOrderSheet({super.key, required this.orderId, required this.parts});

  final String orderId;
  final Set<RatingParty> parts;

  @override
  ConsumerState<RateOrderSheet> createState() => _RateOrderSheetState();
}

class _RateOrderSheetState extends ConsumerState<RateOrderSheet> {
  late final Map<RatingParty, RatingDraft> _drafts = {
    for (final party in RatingParty.values)
      if (widget.parts.contains(party)) party: const RatingDraft(),
  };
  bool _sending = false;

  Future<void> _send() async {
    setState(() => _sending = true);
    final outcome = await ref.read(rateOrderProvider(widget.orderId)).send({
      for (final entry in _drafts.entries)
        if (entry.value.ready) entry.key: entry.value,
    });
    // A lost answer retried, or a part sent from another phone, is resent
    // without the parts already in the order (`RateOrder.send`).
    if (!mounted) return;
    if (outcome == RateOutcome.failed) {
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).customerTryAgain)),
      );
      return;
    }
    Navigator.of(context).pop(outcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(contentProvider).value;
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 16,
          end: 16,
          top: 16,
          bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in _drafts.entries)
                _part(l10n, content, entry.key, entry.value),
              FilledButton(
                key: const Key('rating-send'),
                onPressed:
                    _sending ||
                        !_drafts.values.any((draft) => draft.ready) ||
                        !_drafts.values.every((draft) => draft.commentFits)
                    ? null
                    : _send,
                child: Text(l10n.customerRatingSend),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _part(
    AppLocalizations l10n,
    CustomerContent? content,
    RatingParty party,
    RatingDraft draft,
  ) {
    void update(RatingDraft next) => setState(() => _drafts[party] = next);
    final stars = draft.stars;
    final chips = stars == null
        ? const <ReasonChoice>[]
        : content?.ratingReasons[ratingReasonList(party, stars)] ?? const [];
    return Column(
      key: Key('rating-${party.name}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          party == RatingParty.restaurant
              ? l10n.customerRateRestaurant
              : l10n.customerRateCaptain,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            for (var value = 1; value <= 5; value++)
              IconButton(
                key: Key('rating-${party.name}-star-$value'),
                tooltip: l10n.customerRatingStar(value),
                icon: Icon(
                  stars != null && value <= stars
                      ? Icons.star
                      : Icons.star_border,
                ),
                onPressed: _sending
                    ? null
                    : () => update(draft.withStars(value)),
              ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final reason in chips)
              FilterChip(
                key: Key('rating-${party.name}-reason-${reason.code}'),
                label: Text(reason.label),
                selected: draft.reasons.contains(reason.code),
                onSelected: _sending
                    ? null
                    : (_) => update(draft.toggle(reason.code)),
              ),
          ],
        ),
        TextField(
          key: Key('rating-${party.name}-comment'),
          // The counter shows the limit; the send waits for a comment that
          // fits in code points, as the server counts it.
          maxLength: maxRatingComment,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          enabled: !_sending,
          decoration: InputDecoration(labelText: l10n.customerRatingComment),
          onChanged: (value) => update(draft.withComment(value)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// The order's ratings (CU §12.1): each part as sent (never edited, Q16)
/// and «قيّم طلبك» while a part is left within the window; the sheet opens
/// by itself once per order on this phone. Unstyled until the design.
class RatingSection extends ConsumerStatefulWidget {
  const RatingSection({super.key, required this.order});

  final CustomerOrder order;

  @override
  ConsumerState<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends ConsumerState<RatingSection> {
  bool _checked = false;

  Future<void> _openOnce(Set<RatingParty> parts) async {
    final first = await ref.read(ratingSheetOnceProvider).take(widget.order.id);
    if (!first || !mounted) return;
    await showRateOrder(context, widget.order, parts);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = widget.order;
    final now = ref.watch(serverClockProvider).now();
    final left = ratingPartsLeft(order, now);
    if (left.isNotEmpty && !_checked) {
      _checked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openOnce(left));
    }
    final rating = order.rating;
    String details(Iterable<String> reasons, String? comment) => [
      reasons.join('، '),
      comment ?? '',
    ].where((s) => s.isNotEmpty).join('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rating?.restaurant case final sent?)
          ListTile(
            key: const Key('rating-sent-restaurant'),
            title: Text(l10n.customerYourRestaurantRating(sent.stars)),
            subtitle: Text(
              details(sent.reasons.map((r) => r.label), sent.comment),
            ),
          ),
        if (rating?.captain case final sent?)
          ListTile(
            key: const Key('rating-sent-captain'),
            title: Text(l10n.customerYourCaptainRating(sent.stars)),
            subtitle: Text(
              details(sent.reasons.map((r) => r.label), sent.comment),
            ),
          ),
        if (left.isNotEmpty)
          TextButton(
            key: const Key('order-rate'),
            onPressed: () => showRateOrder(context, order, left),
            child: Text(l10n.customerRateOrder),
          ),
      ],
    );
  }
}
