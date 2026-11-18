import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../device.dart';
import '../media_image.dart';
import 'browsing.dart';

/// The restaurants that deliver to the point (CU §8.2), or with
/// [categoryId] a category's (slice 2.27a). Pull to refresh (CU §8.1).
class RestaurantList extends ConsumerWidget {
  const RestaurantList({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = switch (categoryId) {
      final id? => categoryRestaurantsProvider(id),
      null => restaurantsProvider,
    };
    final restaurants = ref.watch(provider);
    final now = ref.watch(clockProvider)();
    return RefreshIndicator(
      onRefresh: () => ref.refresh(provider.future),
      child: switch (restaurants) {
        AsyncData(:final value) when value.isEmpty => ListView(
          children: [ListTile(title: Text(l10n.customerNoRestaurantsHere))],
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final card in value)
              ListTile(
                key: Key('restaurant-${card.id}'),
                leading: switch (card.logoKey) {
                  final logo? => MediaImage(
                    imageKey: logo,
                    width: 56,
                    height: 56,
                    label: card.nameAr,
                  ),
                  null => null,
                },
                title: Text(card.nameAr),
                subtitle: Text(
                  [
                    // CU §8.2: only an admin test account sees one.
                    if (card.testMode) l10n.customerTestMode,
                    ?categoriesText(
                      card.categories.nonNulls.map((c) => c.name),
                    ),
                    card.rating == null
                        ? l10n.customerNew
                        : card.rating!.toStringAsFixed(1),
                    l10n.customerEstimate(
                      card.estimate.fromMin,
                      card.estimate.toMin,
                    ),
                    if (card.deliveryFee case final fee?)
                      fee.free
                          ? l10n.customerFreeDelivery
                          : l10n.customerDeliveryFeeValue(
                              l10n.formatMoney(
                                fee.fee!.amount,
                                fee.fee!.currency,
                              ),
                            ),
                    ?restaurantBadge(
                      l10n,
                      RestaurantState.ofCard(card.state),
                      now,
                    ),
                  ].join(' · '),
                ),
                onTap: () => context.push('/restaurants/${card.id}'),
              ),
          ],
        ),
        AsyncError() => ListView(
          children: [
            ListTile(title: Text(l10n.statusError)),
            TextButton(
              onPressed: () => ref.invalidate(provider),
              child: Text(l10n.customerTryAgain),
            ),
          ],
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
