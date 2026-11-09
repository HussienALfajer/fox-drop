import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

/// RA Appendix C, AP Appendix B: the active rejection reasons of Content
/// (`GET /v1/merchant/content`, the closed list `merchant_rejection`), their
/// codes to the labels operations may edit, in Content's order. Read once
/// and kept; a failed read is read again on the next rejection
/// (`ref.invalidate`), and the screens fall back to the built-in labels.
final rejectionReasonsProvider = FutureProvider<Map<String, String>>((
  ref,
) async {
  final answer = await ref
      .watch(coreApiProvider)
      .getMerchantApi()
      .merchantContentGet();
  return {
    for (final reason in answer.data!.reasons.merchantRejection)
      reason.code: reason.label,
  };
});
