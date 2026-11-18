import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'browsing.dart';
import 'restaurant_list.dart';

/// A banner's own list of restaurants (AP §9.11.2, owner decision
/// 2026-11-18), under the banner's title: its cards from the home's answer,
/// open first and closed last. A banner gone from the home since says there
/// is no restaurant here.
class BannerListScreen extends ConsumerWidget {
  const BannerListScreen({super.key, required this.bannerId});

  final String bannerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final home = ref.watch(homeProvider).value;
    final banner = home?.bannerById(bannerId);
    final cards = banner == null
        ? const <RestaurantCard>[]
        : home!.cardsOfBanner(banner);
    return Scaffold(
      appBar: AppBar(title: Text(banner?.title ?? '')),
      body: home == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: cards.isEmpty
                  ? [ListTile(title: Text(l10n.customerNoRestaurantsHere))]
                  : [for (final card in cards) RestaurantTile(card: card)],
            ),
    );
  }
}
