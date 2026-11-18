import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import '../auth.dart';
import '../router.dart';
import '../search/search.dart';
import 'browsing.dart';

/// CU §9.6 «المفضلة» (slice 2.28b): the favourites that deliver to the
/// selected point, with their state and estimate (`GET
/// /v1/customer/favourites`, whose cards are the search's); empty before a
/// served point.
final favouritesProvider = FutureProvider.autoDispose<List<RestaurantCard>>((
  ref,
) async {
  final point = browsingPoint(ref);
  if (point == null) return const [];
  final response = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerFavouritesList(
        latitude: '${point.latitude}',
        longitude: '${point.longitude}',
      );
  return [for (final card in response.data!.restaurants) cardOfSearch(card)];
});

/// The hearts changed on this device since the cards were read, by
/// restaurant: a card shows its own `favourite` until then. They belong to
/// the account, so a sign-in or sign-out starts again.
class Hearts extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    ref.watch(
      customerAuth.session.select(
        (session) => switch (session.value) {
          SignedIn(:final accountId) => accountId,
          _ => null,
        },
      ),
    );
    return const {};
  }

  /// Sets or removes the favourite on the server at once (no confirmation,
  /// owner decision 2026-11-18); a failed call puts the heart back and
  /// answers false.
  Future<bool> toggle(String restaurantId, {required bool favourite}) async {
    final next = !favourite;
    state = {...state, restaurantId: next};
    final api = ref.read(coreApiProvider).getCustomerApi();
    try {
      if (next) {
        await api.customerFavouritesAdd(restaurantId: restaurantId);
      } else {
        await api.customerFavouritesRemove(restaurantId: restaurantId);
      }
    } on Object {
      state = {...state, restaurantId: favourite};
      return false;
    }
    ref.invalidate(favouritesProvider);
    return true;
  }
}

final heartsProvider = NotifierProvider<Hearts, Map<String, bool>>(Hearts.new);

/// The heart on a restaurant card and page (CU §9.6). A guest is sent to
/// sign in, then back where they were.
class HeartButton extends ConsumerWidget {
  const HeartButton({
    super.key,
    required this.restaurantId,
    required this.favourite,
  });

  final String restaurantId;

  /// What the server answered with the card or the page.
  final bool favourite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shown = ref.watch(heartsProvider)[restaurantId] ?? favourite;
    return IconButton(
      key: Key('heart-$restaurantId'),
      tooltip: shown ? l10n.customerRemoveFavourite : l10n.customerAddFavourite,
      icon: Icon(shown ? Icons.favorite : Icons.favorite_border),
      onPressed: () async {
        if (ref.read(customerAuth.session).value is! SignedIn) {
          context.go(signInFrom(GoRouterState.of(context).uri.toString()));
          return;
        }
        final messenger = ScaffoldMessenger.of(context);
        final done = await ref
            .read(heartsProvider.notifier)
            .toggle(restaurantId, favourite: shown);
        if (!done) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.statusError)));
        }
      },
    );
  }
}
