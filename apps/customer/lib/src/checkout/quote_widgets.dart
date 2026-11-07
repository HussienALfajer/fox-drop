import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../cart/cart.dart';
import 'problems.dart';
import 'quote.dart';

/// A blocking problem with the action that fixes it (CU §10.6, Appendix C),
/// shown by the cart and checkout.
class ProblemTile extends ConsumerWidget {
  const ProblemTile({
    super.key,
    required this.problem,
    this.onChangeAddress,
    this.enabled = true,
  });

  final ProblemView problem;

  /// «تغيير العنوان»; the cart has none.
  final VoidCallback? onChangeAddress;

  /// Off while a new quote is asked for.
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.read(cartProvider.notifier);
    final line = problem.lineKey;
    final (String? label, VoidCallback? action) = switch (problem.action) {
      ProblemAction.remove when line != null => (
        l10n.customerRemove,
        () => cart.removeKey(line),
      ),
      ProblemAction.acceptPrice when line != null => (
        l10n.customerOk,
        () => cart.acceptPrice(line, problem.newPrice!),
      ),
      ProblemAction.addItems => (
        l10n.customerAddItems,
        () {
          final id = ref.read(cartProvider).value?.cart?.restaurantId;
          if (id != null) context.push('/restaurants/$id');
        },
      ),
      ProblemAction.changeAddress when onChangeAddress != null => (
        l10n.customerChangeAddress,
        onChangeAddress,
      ),
      ProblemAction.retry => (
        l10n.customerRetry,
        () => ref.invalidate(quoteProvider),
      ),
      _ => (null, null),
    };
    return ListTile(
      title: Text(problem.text),
      trailing: label == null
          ? null
          : TextButton(onPressed: enabled ? action : null, child: Text(label)),
    );
  }
}

/// The minimum order and the free delivery with their progress bars (CU
/// §10.2), compared with the items value before discounts.
class Thresholds extends StatelessWidget {
  const Thresholds({super.key, required this.quote});

  final Quote quote;

  static double _progress(String missing, String target) {
    final whole = BigInt.parse(target);
    if (whole == BigInt.zero) return 1;
    return 1 - BigInt.parse(missing) / whole;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String money(String minor) => l10n.formatMoney(minor, quote.currency);
    final minimum = quote.minimumOrder;
    final free = quote.freeDelivery;
    return Column(
      children: [
        if (!minimum.reached) ...[
          ListTile(
            title: Text(
              l10n.customerBelowMinimumProgress(
                money(minimum.missing),
                l10n.formatMoney(minimum.amount, minimum.currency),
              ),
            ),
          ),
          LinearProgressIndicator(
            value: _progress(minimum.missing, minimum.amount),
          ),
        ],
        if (free != null)
          if (free.reached)
            ListTile(title: Text(l10n.customerFreeDeliveryReached))
          else ...[
            ListTile(
              title: Text(
                l10n.customerFreeDeliveryProgress(money(free.missing)),
              ),
            ),
            LinearProgressIndicator(
              value: _progress(free.missing, free.threshold),
            ),
          ],
      ],
    );
  }
}
