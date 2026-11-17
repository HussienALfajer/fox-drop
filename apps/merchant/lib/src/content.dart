import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

/// RA Appendix C, AP Appendix B: the restaurant app's reason lists of
/// Content and its FAQ (`GET /v1/merchant/content`, RA §15). Read once and
/// kept; a failed read is read again when a list is next needed
/// (`ref.invalidate` on this provider), and the screens fall back to the
/// built-in labels.
final merchantContentProvider = FutureProvider<MerchantContentDtoOutput>(
  (ref) async =>
      (await ref.watch(coreApiProvider).getMerchantApi().merchantContentGet())
          .data!,
);

/// The active rejection reasons (the closed list `merchant_rejection`),
/// their codes to the labels operations may edit, in Content's order.
final rejectionReasonsProvider = FutureProvider<Map<String, String>>((
  ref,
) async {
  final reasons = (await ref.watch(merchantContentProvider.future)).reasons;
  return {
    for (final reason in reasons.merchantRejection) reason.code: reason.label,
  };
});

/// The item-unavailable report's optional notes (RA §8.12, the list
/// `item_unavailable_note`), their codes to their labels, in Content's
/// order.
final itemReportNotesProvider = FutureProvider<Map<String, String>>((
  ref,
) async {
  final reasons = (await ref.watch(merchantContentProvider.future)).reasons;
  return {
    for (final note in reasons.itemUnavailableNote) note.code: note.label,
  };
});
