import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef RatingsPage = MerchantRatingsDtoOutput;
typedef Rating = MerchantRatingsDtoOutputRatingsInner;

/// The reports' periods (RA §11; owner decision 2026-11-17), and «الكل», in
/// business days counted by the server. `query` is the route's value.
enum RatingPeriod {
  all('all'),
  today('today'),
  yesterday('yesterday'),
  last7Days('last_7_days'),
  last30Days('last_30_days');

  const RatingPeriod(this.query);

  final String query;
}

/// What «التقييمات» filters by: the period, and the stars (null for every
/// star). The summary counts every star of the period.
class RatingsFilter {
  const RatingsFilter({this.period = RatingPeriod.all, this.stars});

  final RatingPeriod period;
  final int? stars;
}

/// The ratings shown: the summary of the first page and every page read
/// since, all as of the first page's `asOf`; `pages` is how many were read.
class RatingsView {
  const RatingsView({
    required this.filter,
    required this.summary,
    required this.ratings,
    required this.pages,
    required this.hasMore,
    this.loadingMore = false,
    this.moreFailed = false,
  });

  final RatingsFilter filter;
  final RatingsPage summary;
  final List<Rating> ratings;
  final int pages;
  final bool hasMore;
  final bool loadingMore;
  final bool moreFailed;

  RatingsView copyWith({
    List<Rating>? ratings,
    int? pages,
    bool? hasMore,
    required bool loadingMore,
    bool moreFailed = false,
  }) => RatingsView(
    filter: filter,
    summary: summary,
    ratings: ratings ?? this.ratings,
    pages: pages ?? this.pages,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore,
    moreFailed: moreFailed,
  );
}

/// `GET /v1/merchant/ratings` (RA §13), the owners' (a cashier gets `403
/// owner_only`): read on opening «التقييمات», on each filter and on
/// «تحديث»; «عرض المزيد» adds the next page, read as of the first.
class RatingsNotifier extends AsyncNotifier<RatingsView> {
  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();

  RatingsFilter _filter = const RatingsFilter();

  // Each read of the first page; a page asked before it is dropped.
  int _read = 0;

  @override
  Future<RatingsView> build() async {
    _read += 1;
    final filter = _filter;
    final page = (await _api.merchantRatingsRead(
      period: filter.period.query,
      stars: filter.stars,
    )).data!;
    return RatingsView(
      filter: filter,
      summary: page,
      ratings: page.ratings.toList(),
      pages: 1,
      hasMore: page.more,
    );
  }

  /// Reads the first page again with another filter.
  void show(RatingsFilter filter) {
    _filter = filter;
    ref.invalidateSelf();
  }

  Future<void> more() async {
    final shown = state.value;
    if (shown == null || !shown.hasMore || shown.loadingMore) return;
    final read = _read;
    state = AsyncData(shown.copyWith(loadingMore: true));
    // The screen closed, or a filter or «تحديث» replaced what was shown.
    bool stale() => !ref.mounted || read != _read;
    try {
      final page = (await _api.merchantRatingsRead(
        period: shown.filter.period.query,
        stars: shown.filter.stars,
        page: shown.pages,
        asOf: shown.summary.asOf,
      )).data!;
      if (stale()) return;
      state = AsyncData(
        shown.copyWith(
          ratings: [...shown.ratings, ...page.ratings],
          pages: shown.pages + 1,
          hasMore: page.more,
          loadingMore: false,
        ),
      );
    } catch (_) {
      if (stale()) return;
      state = AsyncData(shown.copyWith(loadingMore: false, moreFailed: true));
    }
  }
}

/// Why a read was refused (RA §5.4, §5.5): a cashier, or a terminated
/// restaurant; null for any other failure, which is worth a retry.
enum RatingsRefusal { ownersOnly, terminated }

RatingsRefusal? refusalOf(Object error) {
  if (error is! DioException || error.response?.statusCode != 403) return null;
  final body = error.response?.data;
  return body is Map && body['error'] == 'restaurant_terminated'
      ? RatingsRefusal.terminated
      : RatingsRefusal.ownersOnly;
}

final ratingsProvider =
    AsyncNotifierProvider.autoDispose<RatingsNotifier, RatingsView>(
      RatingsNotifier.new,
    );

/// The average as the server rounds it, without a needless «.0».
String averageText(num average) {
  final tenths = (average * 10).round();
  return tenths % 10 == 0
      ? '${tenths ~/ 10}'
      : '${tenths ~/ 10}.${tenths % 10}';
}

extension RatingsTexts on AppLocalizations {
  String periodLabel(RatingPeriod period) => switch (period) {
    RatingPeriod.all => merchantRatingsPeriodAll,
    RatingPeriod.today => merchantRatingsPeriodToday,
    RatingPeriod.yesterday => merchantRatingsPeriodYesterday,
    RatingPeriod.last7Days => merchantRatingsPeriodLast7Days,
    RatingPeriod.last30Days => merchantRatingsPeriodLast30Days,
  };

  /// A rating's reasons as the customer picked them, «، » between.
  String reasonsText(Rating rating) => rating.reasons
      .whereType<AdminCustomerDtoOutputRatingsInnerReasonsInner>()
      .map((reason) => reason.label)
      .join(merchantRatingsReasonSeparator);
}
