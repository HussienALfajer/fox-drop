import 'dart:convert';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../browsing/browsing.dart';
import '../browsing/favourites.dart';
import '../device.dart';
import '../location/delivery_point.dart';

typedef SearchItem = CustomerSearchDtoOutputItemsInner;

/// CU §8.3: the search waits until typing stops.
const searchDelay = Duration(milliseconds: 400);

/// The server takes a search of 2 to 50 characters.
const searchMinLength = 2;
const searchMaxLength = 50;

/// CU §8.3, Appendix A: the last 10 searches, fixed.
const recentSearchesMax = 10;
const _recentKey = 'recent_searches';

/// What a search found for the point, open restaurants first and closed
/// ones last, as the server sorts them.
class SearchView {
  const SearchView({required this.restaurants, required this.items});

  final List<RestaurantCard> restaurants;
  final List<SearchItem> items;

  bool get isEmpty => restaurants.isEmpty && items.isEmpty;
}

/// The text the box sends: trimmed, null while too short or, counted in
/// UTF-16 units as the server counts it (diacritics included), too long.
String? searchQuery(String typed) {
  final query = typed.trim();
  return query.length < searchMinLength || query.length > searchMaxLength
      ? null
      : query;
}

/// «لم تجده؟ أخبرنا»: the server takes a name of 1 to 60 and a note up to
/// 200, counted in UTF-16 units after trimming.
const suggestionNameMax = 60;
const suggestionNoteMax = 200;

bool suggestionFits(String name, String note) {
  final trimmed = name.trim();
  return trimmed.isNotEmpty &&
      trimmed.length <= suggestionNameMax &&
      note.trim().length <= suggestionNoteMax;
}

/// The recent searches with [query] first, once, at most
/// [recentSearchesMax].
List<String> withRecent(List<String> recent, String query) => [
  query,
  ...recent.where((each) => each != query),
].take(recentSearchesMax).toList();

/// CU §8.3: the recent searches, kept on the device only, newest first.
class RecentSearches extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final stored = await ref.read(deviceStoreProvider).read(_recentKey);
    if (stored == null) return const [];
    try {
      return [
        for (final each in jsonDecode(stored) as List<Object?>)
          if (each is String) each,
      ].take(recentSearchesMax).toList();
    } on FormatException {
      return const [];
    }
  }

  Future<void> add(String query) async {
    final next = withRecent(await future, query);
    state = AsyncData(next);
    await ref.read(deviceStoreProvider).write(_recentKey, jsonEncode(next));
  }

  /// «مسح».
  Future<void> clear() async {
    state = const AsyncData([]);
    await ref.read(deviceStoreProvider).delete(_recentKey);
  }
}

final recentSearchesProvider =
    AsyncNotifierProvider<RecentSearches, List<String>>(RecentSearches.new);

/// `GET /v1/customer/search` at the served point; null without one. A
/// search that finds nothing is kept by the server for the lost-demand
/// report (AP §9.17).
final searchProvider = FutureProvider.autoDispose.family<SearchView?, String>((
  ref,
  query,
) async {
  final point = browsingPoint(ref);
  if (point == null) return null;
  final since = DateTime.now();
  final response = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerSearchSearch(
        latitude: '${point.latitude}',
        longitude: '${point.longitude}',
        q: query,
      );
  final data = response.data!;
  heartsRead(ref, data.restaurants.map((card) => card.id), since);
  return SearchView(
    restaurants: [for (final card in data.restaurants) cardOfSearch(card)],
    items: data.items.toList(),
  );
});

/// The search's card as the list's, which has the same fields, so the
/// restaurant tile serves both.
RestaurantCard cardOfSearch(CustomerSearchDtoOutputRestaurantsInner card) =>
    standardSerializers.deserializeWith(
      RestaurantCard.serializer,
      standardSerializers.serializeWith(
        CustomerSearchDtoOutputRestaurantsInner.serializer,
        card,
      ),
    )!;

/// «لم تجده؟ أخبرنا» (CU §8.3): `POST /v1/customer/restaurant-suggestions`
/// at the served point, with a key per command body until an answer.
class RestaurantSuggestion {
  RestaurantSuggestion(this._ref);

  final Ref _ref;
  String? _key;
  String? _keyFor;

  /// Whether the server took it; false with no point or no answer.
  Future<bool> send({
    required String restaurantName,
    required String? note,
    required String? query,
  }) async {
    final point = switch (_ref.read(deliveryPointProvider)) {
      PointChecked(coverage: PointCoverage.served, :final point) => point,
      _ => null,
    };
    if (point == null) return false;
    final alive = _ref.keepAlive();
    final fingerprint = [
      point.latitude,
      point.longitude,
      restaurantName,
      note,
      query,
    ].join('\n');
    if (_keyFor != fingerprint) {
      _key = uuidV4();
      _keyFor = fingerprint;
    }
    try {
      await _ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerSearchSuggest(
            idempotencyKey: _key!,
            customerSuggestionDto: CustomerSuggestionDto(
              (b) => b
                ..latitude = point.latitude
                ..longitude = point.longitude
                ..restaurantName = restaurantName
                ..note = note
                ..query = query,
            ),
          );
      _key = null;
      _keyFor = null;
      return true;
    } on DioException catch (error) {
      // A refusal takes a new key next time; a lost answer or a server
      // error keeps it, since the server may have recorded it.
      final status = error.response?.statusCode;
      if (status != null && status < 500) {
        _key = null;
        _keyFor = null;
      }
      return false;
    } finally {
      alive.close();
    }
  }
}

final restaurantSuggestionProvider = Provider.autoDispose(
  RestaurantSuggestion.new,
);
