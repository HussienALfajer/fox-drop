import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'browsing.dart';
import 'categories.dart';
import 'category_screen.dart';
import 'restaurant_list.dart';

/// The home (CU §8.1, AP §9.11.3; slice 2.27b): the sections the panel
/// shows, in its order, then every restaurant that delivers to the point.
/// A section's restaurants come open first and closed last (the server's
/// order). «البانرات» waits for its slice. Pull to refresh reads the
/// sections and the categories again.
class HomeSections extends ConsumerWidget {
  const HomeSections({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final home = ref.watch(homeProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(categoriesProvider);
        return ref.refresh(homeProvider.future);
      },
      child: switch (home) {
        AsyncData(:final value) when value.restaurants.isEmpty => ListView(
          children: [ListTile(title: Text(l10n.customerNoRestaurantsHere))],
        ),
        AsyncData(:final value) => ListView(
          // A short home still pulls to refresh.
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            for (final section in value.sections)
              ?_section(l10n, value, section),
            Column(
              key: const Key('home-all'),
              children: [
                ListTile(title: Text(l10n.customerHomeAll)),
                for (final card in value.restaurants)
                  RestaurantTile(card: card),
              ],
            ),
          ],
        ),
        AsyncError() => ListView(
          children: [
            ListTile(title: Text(l10n.statusError)),
            TextButton(
              onPressed: () => ref.invalidate(homeProvider),
              child: Text(l10n.customerTryAgain),
            ),
          ],
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget? _section(AppLocalizations l10n, HomeView home, HomeSection section) {
    final kind = section.kind;
    if (kind == HomeSectionKind.banners) return null;
    if (kind == HomeSectionKind.categories) return const CategoryRow();
    final title = switch (kind) {
      HomeSectionKind.nearest => l10n.customerHomeNearest,
      HomeSectionKind.mostOrdered => l10n.customerHomeMostOrdered,
      HomeSectionKind.new_ => l10n.customerHomeNew,
      HomeSectionKind.offers => l10n.customerHomeOffers,
      // A custom section, under the title the admin wrote.
      _ => section.title,
    };
    final cards = home.cardsOf(section);
    if (title == null || cards.isEmpty) return null;
    return Column(
      key: Key('home-section-${home.sections.indexOf(section)}'),
      children: [
        ListTile(title: Text(title)),
        for (final card in cards) RestaurantTile(card: card),
      ],
    );
  }
}
