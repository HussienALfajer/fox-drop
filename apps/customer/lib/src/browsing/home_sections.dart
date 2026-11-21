import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/delivery_point.dart';
import 'browsing.dart';
import 'banner_strip.dart';
import 'categories.dart';
import 'category_screen.dart';
import 'restaurant_list.dart';

/// The home (CU §8.1, AP §9.11.3; slice 2.27b): the sections the panel
/// shows, in its order, then every restaurant that delivers to the point.
/// A section's restaurants come open first and closed last (the server's
/// order); «البانرات» is the strip of banners (slice 2.27c). Pull to refresh
/// reads the sections, the banners and the categories again.
///
/// CU §4.5: shown from the last kept read without a connection, under
/// «لا يوجد اتصال بالإنترنت»; pull to refresh and the app's return to the
/// foreground then ask again: the zone check after it failed, else home.
class HomeSections extends ConsumerStatefulWidget {
  const HomeSections({super.key});

  @override
  ConsumerState<HomeSections> createState() => _HomeSectionsState();
}

class _HomeSectionsState extends ConsumerState<HomeSections> {
  late final _lifecycle = AppLifecycleListener(
    onResume: () {
      if (ref.read(homeProvider).value?.offline ?? false) _refresh();
    },
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    if (ref.read(deliveryPointProvider) case PointUnavailable(failure: null)) {
      return ref.read(deliveryPointProvider.notifier).retry();
    }
    ref.invalidate(categoriesProvider);
    ref.invalidate(homeProvider);
    // The indicator stays until the live read ends, not the kept one.
    final done = Completer<void>();
    final listening = ref.listenManual(homeProvider, (_, next) {
      final ended =
          next.hasError ||
          (!next.isLoading && next.hasValue && !next.requireValue.pending);
      if (ended && !done.isCompleted) done.complete();
    }, fireImmediately: true);
    return done.future.whenComplete(listening.close);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final home = ref.watch(homeProvider);
    final offline = home.value?.offline ?? false;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: switch (home) {
        // No restaurant at the point: a code banner still opens (the
        // server keeps it), so the strip stays above the message.
        AsyncData(:final value) when value.restaurants.isEmpty => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (offline) _offlineBar(l10n),
            if (value.banners.isNotEmpty &&
                value.sections.any((s) => s.kind == HomeSectionKind.banners))
              BannerStrip(banners: value.banners),
            ListTile(title: Text(l10n.customerNoRestaurantsHere)),
          ],
        ),
        AsyncData(:final value) => ListView(
          // A short home still pulls to refresh.
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (offline) _offlineBar(l10n),
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

  Widget _offlineBar(AppLocalizations l10n) =>
      ListTile(key: const Key('offline'), title: Text(l10n.customerOffline));

  Widget? _section(AppLocalizations l10n, HomeView home, HomeSection section) {
    final kind = section.kind;
    if (kind == HomeSectionKind.banners) {
      return home.banners.isEmpty ? null : BannerStrip(banners: home.banners);
    }
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
