import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../device.dart';
import 'account.dart';

typedef Overdue = MerchantOverdueDtoOutputOverdue;

/// How often an owner's device reads the overdue amount again while it runs:
/// a payment at the desk or a statement past its days pushes no event the
/// app follows, so the banner keeps up within this (and on every resume).
const overdueRefresh = Duration(minutes: 15);

/// `GET /v1/merchant/account/overdue` (RA §6.3 item 7, §12.6; slice 2.19f):
/// what an owner's amber banner shows; null for a cashier, signed out, when
/// nothing is overdue, or while the read fails (the banner waits for the
/// next read). Read at start, on every resume and every [overdueRefresh].
final overdueProvider = FutureProvider<Overdue?>((ref) async {
  final owner = ref.watch(
    merchantSessionProvider.select(
      (s) => s.value?.role == MerchantSessionDtoOutputRoleEnum.owner,
    ),
  );
  if (!owner) return null;
  final timer = Timer(overdueRefresh, ref.invalidateSelf);
  final lifecycle = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(() {
    timer.cancel();
    lifecycle.dispose();
  });
  final answer = await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantAccountOverdue();
  return answer.data!.overdue;
});

extension OverdueTexts on AppLocalizations {
  /// RA §12.6: «لديك مبلغ متأخر: {المبلغ}. يرجى التسوية في أقرب وقت.»
  String overdueBannerText(Overdue overdue) =>
      merchantOverdueBanner(formatMoney(overdue.amount, overdue.currency));

  /// RA §12.2: «متأخر: {المبلغ} من كشف {التاريخ}».
  String overdueLineText(String amount, String currency, Date statementDate) =>
      merchantAccountOverdue(
        formatMoney(amount, currency),
        formatDate(noonOf(statementDate)),
      );
}

/// RA §6.3 item 7: the owners' banner, after the status banners (items 3
/// and 6). Unstyled until the design (amber then).
class OverdueBanner extends ConsumerWidget {
  const OverdueBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdue = ref.watch(overdueProvider).value;
    if (overdue == null) return const SizedBox.shrink();
    return MaterialBanner(
      key: const Key('overdue-banner'),
      content: Text(AppLocalizations.of(context).overdueBannerText(overdue)),
      actions: const [SizedBox.shrink()],
    );
  }
}
