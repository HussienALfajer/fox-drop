import 'package:core_l10n/core_l10n.dart';

/// A code's kind as the API sends it (`percentage`, `fixed_amount`,
/// `free_delivery`), shared by checkout's «الأكواد المتاحة لك» and «أكوادي».
enum CodeKind { percentage, fixedAmount, freeDelivery }

/// A code's value (CU §10.4, §12.4): «خصم 20% بحد أقصى 50 ₺», «خصم 25 ₺» or
/// «توصيل مجاني». Amounts are the API's minor units in [currency].
String codeValueText(
  AppLocalizations l10n, {
  required CodeKind kind,
  required int? percentBp,
  required String? amount,
  required String? maxDiscount,
  required String currency,
}) {
  switch (kind) {
    case CodeKind.percentage:
      final percent = percentText(percentBp ?? 0);
      return maxDiscount == null
          ? l10n.customerCodePercent(percent)
          : l10n.customerCodePercentCapped(
              percent,
              l10n.formatMoney(maxDiscount, currency),
            );
    case CodeKind.fixedAmount:
      return l10n.customerCodeFixed(l10n.formatMoney(amount ?? '0', currency));
    case CodeKind.freeDelivery:
      return l10n.customerCodeFreeDelivery;
  }
}

/// Basis points as a percentage with Western digits: 2000 is «20», 1250
/// «12.5», 3333 «33.33».
String percentText(int basisPoints) {
  final whole = basisPoints ~/ 100;
  final cents = basisPoints % 100;
  if (cents == 0) return '$whole';
  final fraction = cents.toString().padLeft(2, '0');
  return '$whole.${fraction.endsWith('0') ? fraction[0] : fraction}';
}

/// One code per order (CU §10.4): whether applying [code] replaces the
/// applied one, which the customer confirms first.
bool replacesCode(String? applied, String code) =>
    applied != null && applied.toUpperCase() != code.toUpperCase();
