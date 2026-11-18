import 'package:core_auth/core_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
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
  final since = DateTime.now();
  final response = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerFavouritesList(
        latitude: '${point.latitude}',
        longitude: '${point.longitude}',
      );
  final cards = [
    for (final card in response.data!.restaurants) cardOfSearch(card),
  ];
  heartsRead(ref, cards.map((card) => card.id), since);
  return cards;
});

/// A heart this device changed, and when.
typedef Heart = ({bool favourite, DateTime at});

/// The hearts changed on this device, by restaurant: a card or page read
/// before the change shows it, and one read after shows the server's
/// `favourite` again, so a change on another phone reaches this one at its
/// next read (CU §9.6: the account's, on every device). They belong to the
/// account, so a sign-in or sign-out starts again.
class Hearts extends Notifier<Map<String, Heart>> {
  final _sending = <String>{};

  @override
  Map<String, Heart> build() {
    ref.watch(
      customerAuth.session.select(
        (session) => switch (session.value) {
          SignedIn(:final accountId) => accountId,
          _ => null,
        },
      ),
    );
    _sending.clear();
    return const {};
  }

  /// What a card or page shows, given what the server answered with it.
  bool shown(String restaurantId, bool favourite) =>
      state[restaurantId]?.favourite ?? favourite;

  /// Cards read from the server since [since] carry the hearts as they
  /// are: the changes made before it are dropped.
  void read(Iterable<String> restaurantIds, DateTime since) {
    final dropped = {
      for (final id in restaurantIds)
        if (state[id] case final heart?
            when heart.at.isBefore(since) && !_sending.contains(id))
          id,
    };
    if (dropped.isEmpty) return;
    state = {
      for (final entry in state.entries)
        if (!dropped.contains(entry.key)) entry.key: entry.value,
    };
  }

  /// Sets or removes the favourite on the server at once (no confirmation,
  /// owner decision 2026-11-18); a tap while the last one is on its way is
  /// ignored, and a failed call puts the heart back and answers false.
  Future<bool> toggle(String restaurantId, {required bool favourite}) async {
    if (!_sending.add(restaurantId)) return true;
    final before = state[restaurantId];
    final next = !favourite;
    state = {...state, restaurantId: (favourite: next, at: DateTime.now())};
    final api = ref.read(coreApiProvider).getCustomerApi();
    try {
      if (next) {
        await api.customerFavouritesAdd(restaurantId: restaurantId);
      } else {
        await api.customerFavouritesRemove(restaurantId: restaurantId);
      }
    } on Object {
      state = {
        for (final entry in state.entries)
          if (entry.key != restaurantId) entry.key: entry.value,
        restaurantId: ?before,
      };
      return false;
    } finally {
      _sending.remove(restaurantId);
    }
    ref.invalidate(favouritesProvider);
    return true;
  }
}

final heartsProvider = NotifierProvider<Hearts, Map<String, Heart>>(Hearts.new);

/// Called by a provider once its cards are read: they carry the server's
/// hearts from [since], the moment the read started.
void heartsRead(Ref ref, Iterable<String> restaurantIds, DateTime since) {
  final hearts = ref.read(heartsProvider.notifier);
  final ids = restaurantIds.toList();
  Future.microtask(() => hearts.read(ids, since));
}
