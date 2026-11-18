import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../browsing/favourites.dart';
import '../browsing/restaurant_list.dart';

/// «حسابي» → «المفضلة» (CU §9.6): the favourite restaurants that deliver to
/// the selected point, with their state and estimate, open first; a heart
/// removed here reads the list again. Unstyled until the design.
class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favourites = ref.watch(favouritesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerFavouritesTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(favouritesProvider.future),
        child: switch (favourites) {
          AsyncData(:final value) when value.isEmpty => ListView(
            children: [ListTile(title: Text(l10n.customerNoFavourites))],
          ),
          AsyncData(:final value) => ListView(
            children: [for (final card in value) RestaurantTile(card: card)],
          ),
          AsyncError() => ListView(
            children: [
              ListTile(title: Text(l10n.statusError)),
              TextButton(
                onPressed: () => ref.invalidate(favouritesProvider),
                child: Text(l10n.customerTryAgain),
              ),
            ],
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
