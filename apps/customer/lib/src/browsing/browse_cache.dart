import 'dart:convert';

import 'package:core_auth/core_auth.dart';
import 'package:core_storage/core_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import '../device.dart';
import '../location/delivery_point.dart';
import '../location/position.dart';

/// CU §4.5 «Caching» (slice L.1c): home, the categories and restaurant pages
/// are kept on the device from their last good read, so browsing goes on
/// without a connection. An entry older than this is never shown (owner
/// decision 2026-11-21).
const browseCacheMaxAge = Duration(days: 7);

/// An entry read at a point farther than this from the browsing point does
/// not fit it: fees and «لا يوصل إلى موقعك» change with the distance.
const browseCacheRadiusMetres = 1000.0;

/// The restaurant pages kept, the most recently read first (owner decision
/// 2026-11-21); the next one drops the oldest.
const browseCachePages = 20;

const browseHomeKey = 'browse_home';
const browseCategoriesKey = 'browse_categories';
const _pagesIndexKey = 'browse_pages';

String browsePageKey(String restaurantId) => 'browse_page_$restaurantId';

/// One kept read: when, for which account (null for a guest) and at which
/// point (null for the categories, which are the same everywhere), and the
/// answer's JSON.
class BrowseEntry {
  const BrowseEntry({
    required this.savedAt,
    required this.accountId,
    required this.point,
    required this.body,
  });

  final DateTime savedAt;
  final String? accountId;
  final GeoPoint? point;
  final Object? body;

  /// Whether it may be shown to [accountId] at [point] (any point when
  /// null) at [now].
  bool fits({
    required String? accountId,
    required GeoPoint? point,
    required DateTime now,
  }) {
    final age = now.difference(savedAt);
    if (age > browseCacheMaxAge || age.isNegative) return false;
    if (this.accountId != accountId) return false;
    final at = this.point;
    return point == null ||
        at == null ||
        at.metresTo(point) <= browseCacheRadiusMetres;
  }

  String encode() => jsonEncode({
    'savedAt': savedAt.toUtc().toIso8601String(),
    'accountId': accountId,
    'point': switch (point) {
      final p? => [p.latitude, p.longitude],
      null => null,
    },
    'body': body,
  });

  /// Null for a value this version cannot read.
  static BrowseEntry? decode(String? value) {
    if (value == null) return null;
    try {
      final json = jsonDecode(value) as Map<String, Object?>;
      final point = json['point'] as List<Object?>?;
      return BrowseEntry(
        savedAt: DateTime.parse(json['savedAt']! as String),
        accountId: json['accountId'] as String?,
        point: point == null
            ? null
            : GeoPoint(
                (point[0]! as num).toDouble(),
                (point[1]! as num).toDouble(),
              ),
        body: json['body'],
      );
    } on Object {
      return null;
    }
  }
}

/// The kept reads in the device store.
class BrowseCache {
  BrowseCache(this._store);

  final DeviceStore _store;

  Future<BrowseEntry?> read(String key) async =>
      BrowseEntry.decode(await _store.read(key));

  Future<void> write(String key, BrowseEntry entry) =>
      _store.write(key, entry.encode());

  Future<void> delete(String key) => _store.delete(key);

  /// The index's changes, one after another, so two pages read together
  /// never lose an id.
  Future<void> _pages = Future.value();

  /// A restaurant page, first in the index of the last [browseCachePages]
  /// fetched.
  Future<void> writePage(String restaurantId, BrowseEntry entry) {
    final next = _pages.then((_) => _writePage(restaurantId, entry));
    _pages = next.catchError((Object _) {});
    return next;
  }

  Future<void> _writePage(String restaurantId, BrowseEntry entry) async {
    final ids = await pageIds()
      ..remove(restaurantId)
      ..insert(0, restaurantId);
    while (ids.length > browseCachePages) {
      await _store.delete(browsePageKey(ids.removeLast()));
    }
    await _store.write(_pagesIndexKey, jsonEncode(ids));
    await write(browsePageKey(restaurantId), entry);
  }

  /// The kept pages' restaurants, the most recently fetched first.
  Future<List<String>> pageIds() async {
    try {
      final value = await _store.read(_pagesIndexKey);
      return value == null
          ? []
          : [
              for (final id in jsonDecode(value) as List<Object?>)
                id! as String,
            ];
    } on Object {
      return [];
    }
  }
}

final browseCacheProvider = Provider<BrowseCache>(
  (ref) => BrowseCache(ref.watch(deviceStoreProvider)),
);

/// A browsing answer and where it came from: [savedAt] is set for a kept
/// one, [offline] when the server could not be reached, so the screen shows
/// «لا يوجد اتصال بالإنترنت» over it.
class Browsed<T> {
  const Browsed(this.body, {this.savedAt, this.offline = false});

  final T body;
  final DateTime? savedAt;
  final bool offline;

  /// A kept read shown while the live read runs.
  bool get pending => savedAt != null && !offline;
}

/// The server sent no answer: the connection or a timeout failed. A 4xx or
/// 5xx is an answer and keeps its error.
bool noAnswer(Object error) => error is DioException && error.response == null;

/// Browsing has no point and nothing kept to show.
class NothingKept implements Exception {
  const NothingKept();
}

/// The signed-in account, null for a guest.
String? browsingAccount(Ref ref) => ref.watch(
  customerAuth.session.select(
    (session) => switch (session.value) {
      SignedIn(:final accountId) => accountId,
      _ => null,
    },
  ),
);

/// Where browsing reads: the served point, live; after a failed zone check
/// (CU §4.5, cold start offline: owner decision 2026-11-21), the last kept
/// home's point, from the kept reads only; else null. Watches the account
/// and the point, so either change reads again.
Future<({GeoPoint point, bool offline})?> browsingPlace(Ref ref) async {
  final account = browsingAccount(ref);
  final state = ref.watch(deliveryPointProvider);
  if (state case PointChecked(:final point, coverage: PointCoverage.served)) {
    return (point: point, offline: false);
  }
  if (state is! PointUnavailable || state.failure != null) return null;
  final home = await ref.read(browseCacheProvider).read(browseHomeKey);
  final now = ref.read(clockProvider)();
  if (home?.point case final point?
      when home!.fits(accountId: account, point: null, now: now)) {
    return (point: point, offline: true);
  }
  return null;
}

/// CU §4.5 «cached first, then live» (owner decision 2026-11-21): a kept
/// read that fits shows at once, then the live read replaces it and is kept.
/// With no answer from the server the kept read stays, marked offline; an
/// answer with an error, or nothing kept, fails as before. [offline] reads
/// only what is kept.
Stream<Browsed<T>> browse<T>(
  Ref ref, {
  required String key,
  required String? accountId,
  required GeoPoint? point,
  required bool offline,
  required Future<T> Function() read,
  required Object? Function(T body) encode,
  required T Function(Object? json) decode,
  required void Function(T body, DateTime since) seen,
  Future<void> Function(BrowseCache cache, BrowseEntry entry)? save,
}) async* {
  final cache = ref.read(browseCacheProvider);
  final clock = ref.read(clockProvider);
  final entry = await cache.read(key);
  Browsed<T>? kept;
  if (entry != null &&
      entry.fits(accountId: accountId, point: point, now: clock())) {
    try {
      kept = Browsed(decode(entry.body), savedAt: entry.savedAt);
    } on Object {
      kept = null;
    }
  }
  if (offline) {
    if (kept == null) throw const NothingKept();
    seen(kept.body, kept.savedAt!);
    yield Browsed(kept.body, savedAt: kept.savedAt, offline: true);
    return;
  }
  if (kept != null) {
    seen(kept.body, kept.savedAt!);
    yield kept;
  }
  final since = clock();
  final T live;
  try {
    live = await read();
  } on Object catch (error) {
    // A page customers no longer see is not shown offline either.
    if (error is DioException && error.response?.statusCode == 404) {
      await cache.delete(key);
    }
    if (kept == null || !noAnswer(error)) rethrow;
    yield Browsed(kept.body, savedAt: kept.savedAt, offline: true);
    return;
  }
  seen(live, since);
  yield Browsed(live);
  final fresh = BrowseEntry(
    savedAt: since,
    accountId: accountId,
    point: point,
    body: encode(live),
  );
  await (save ?? (cache, entry) => cache.write(key, entry))(cache, fresh);
}
