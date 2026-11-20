import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef HistoryPage = MerchantOrderHistoryDtoOutput;
typedef HistoryOrder = MerchantOrderHistoryDtoOutputOrdersInner;
typedef HistoryStatus = MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum;
typedef HistoryDetail = MerchantOrderWithTimelineDtoOutput;
typedef TimelineStep = MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum;

/// What «السجل» filters by (RA §8.18): the range of business days (null:
/// the server's default, today and the 7 days before, which is all a
/// cashier sees), the status (null for every one) and the order number.
class HistoryFilter {
  const HistoryFilter({this.from, this.to, this.status, this.number});

  final Date? from;
  final Date? to;
  final HistoryStatus? status;
  final String? number;

  HistoryFilter withRange(Date? from, Date? to) =>
      HistoryFilter(from: from, to: to, status: status, number: number);

  HistoryFilter withStatus(HistoryStatus? status) =>
      HistoryFilter(from: from, to: to, status: status, number: number);

  HistoryFilter withNumber(String? number) => HistoryFilter(
    from: from,
    to: to,
    status: status,
    number: number == null || number.isEmpty ? null : number,
  );
}

/// The orders shown: the first page's answer (the range and whether the user
/// is an owner) and every order read since.
class HistoryView {
  const HistoryView({
    required this.filter,
    required this.first,
    required this.orders,
    required this.next,
    required this.today,
    this.loadingMore = false,
    this.moreFailed = false,
  });

  final HistoryFilter filter;
  final HistoryPage first;
  final List<HistoryOrder> orders;
  final String? next;
  // The business day today, from the first read with the default range,
  // for the owners' presets.
  final Date today;
  final bool loadingMore;
  final bool moreFailed;

  HistoryView copyWith({
    List<HistoryOrder>? orders,
    String? next,
    required bool loadingMore,
    bool moreFailed = false,
  }) => HistoryView(
    filter: filter,
    first: first,
    orders: orders ?? this.orders,
    next: next,
    today: today,
    loadingMore: loadingMore,
    moreFailed: moreFailed,
  );
}

/// `GET /v1/merchant/orders/history` (RA §8.18): read on opening «السجل»
/// and on each filter; «عرض المزيد» reads the page after `next`.
class HistoryNotifier extends AsyncNotifier<HistoryView> {
  MerchantApi get _api => ref.read(coreApiProvider).getMerchantApi();

  HistoryFilter _filter = const HistoryFilter();
  Date? _today;

  // Each read of the first page; a later page of an older one is dropped.
  int _read = 0;

  Future<HistoryPage> _page(HistoryFilter filter, String? cursor) async =>
      (await _api.merchantOrdersHistory(
        from: filter.from,
        to: filter.to,
        status: filter.status == null ? null : statusQuery(filter.status!),
        number: filter.number,
        cursor: cursor,
      )).data!;

  @override
  Future<HistoryView> build() async {
    _read += 1;
    final filter = _filter;
    final page = await _page(filter, null);
    if (filter.from == null) _today = page.toDay;
    return HistoryView(
      filter: filter,
      first: page,
      orders: page.orders.toList(),
      next: page.next,
      today: _today ?? page.toDay,
    );
  }

  /// Reads the first page again with another filter.
  void show(HistoryFilter filter) {
    _filter = filter;
    ref.invalidateSelf();
  }

  Future<void> more() async {
    final shown = state.value;
    if (shown == null || shown.next == null || shown.loadingMore) return;
    final read = _read;
    state = AsyncData(shown.copyWith(next: shown.next, loadingMore: true));
    bool stale() => !ref.mounted || read != _read;
    try {
      final page = await _page(shown.filter, shown.next);
      if (stale()) return;
      state = AsyncData(
        shown.copyWith(
          orders: [...shown.orders, ...page.orders],
          next: page.next,
          loadingMore: false,
        ),
      );
    } catch (_) {
      if (stale()) return;
      state = AsyncData(
        shown.copyWith(next: shown.next, loadingMore: false, moreFailed: true),
      );
    }
  }
}

final historyProvider =
    AsyncNotifierProvider.autoDispose<HistoryNotifier, HistoryView>(
      HistoryNotifier.new,
    );

/// One order with its timeline, `GET /v1/merchant/orders/{orderId}`.
final historyOrderProvider = FutureProvider.autoDispose
    .family<HistoryDetail, String>((ref, orderId) async {
      final answer = await ref
          .read(coreApiProvider)
          .getMerchantApi()
          .merchantOrdersOrder(orderId: orderId);
      return answer.data!;
    });

/// The status as the route takes it (the enum's wire name).
String statusQuery(HistoryStatus status) => status.name.replaceAllMapped(
  RegExp('[A-Z]'),
  (match) => '_${match[0]!.toLowerCase()}',
);

/// The statuses of the filter, in the order's life.
final List<HistoryStatus> historyStatuses = HistoryStatus.values.toList();

/// The order the server does not give (`404`): another restaurant's, or one
/// past a cashier's range. Retrying never helps.
bool orderMissing(Object error) =>
    error is DioException && error.response?.statusCode == 404;

/// The range a preset asks, from the last business day the server answered
/// (`today`): «اليوم» or «آخر 30 يوماً».
(Date, Date) todayRange(Date today) => (today, today);
(Date, Date) last30Range(Date today) => (
  today.toDateTime(utc: true).subtract(const Duration(days: 29)).toDate(),
  today,
);

extension HistoryTexts on AppLocalizations {
  String historyStatusText(String status) => switch (status) {
    'placed' => merchantHistoryStatusPlaced,
    'accepted' => merchantHistoryStatusAccepted,
    'ready' => merchantHistoryStatusReady,
    'picked_up' || 'pickedUp' => merchantHistoryStatusPickedUp,
    'arrived' => merchantHistoryStatusArrived,
    'delivered' => merchantHistoryStatusDelivered,
    'failed' => merchantHistoryStatusFailed,
    'rejected' => merchantHistoryStatusRejected,
    _ => merchantHistoryStatusCancelled,
  };

  String timelineText(String step) => switch (step) {
    'placed' => merchantTimelinePlaced,
    'accepted' => merchantTimelineAccepted,
    'picked_up' || 'pickedUp' => merchantTimelinePickedUp,
    'arrived' => merchantTimelineArrived,
    'delivered' => merchantTimelineDelivered,
    'failed' => merchantTimelineFailed,
    'rejected' => merchantTimelineRejected,
    _ => merchantTimelineCancelled,
  };

  /// A business day as dd/mm/yyyy.
  String dayText(Date day) => formatDate(day.toDateTime(utc: true));
}
