import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

typedef HistoryPage = CaptainOrderHistoryDtoOutput;
typedef HistoryOrder = CaptainOrderHistoryDtoOutputOrdersInner;
typedef HistoryLine =
    CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner;

/// The range of business days «السجل» reads (CA §9.13); none for every
/// order.
class HistoryRange {
  const HistoryRange(this.from, this.to);

  final Date from;
  final Date to;
}

/// The orders shown: every page read since the first, the pay's currency
/// and the cursor of the next.
class HistoryView {
  const HistoryView({
    required this.range,
    required this.payCurrency,
    required this.orders,
    required this.next,
    this.loadingMore = false,
    this.moreFailed = false,
  });

  final HistoryRange? range;
  final String payCurrency;
  final List<HistoryOrder> orders;
  final String? next;
  final bool loadingMore;
  final bool moreFailed;

  HistoryView copyWith({
    List<HistoryOrder>? orders,
    required String? next,
    required bool loadingMore,
    bool moreFailed = false,
  }) => HistoryView(
    range: range,
    payCurrency: payCurrency,
    orders: orders ?? this.orders,
    next: next,
    loadingMore: loadingMore,
    moreFailed: moreFailed,
  );
}

/// `GET /v1/captain/orders/history` (CA §9.13): read when «السجل» opens and
/// on each range; «عرض المزيد» reads the page after `next`.
class HistoryNotifier extends AsyncNotifier<HistoryView> {
  CaptainApi get _api => ref.read(coreApiProvider).getCaptainApi();

  HistoryRange? _range;

  // Each read of the first page; a later page of an older one is dropped.
  int _read = 0;

  Future<HistoryPage> _page(HistoryRange? range, String? cursor) async =>
      (await _api.captainHistoryHistory(
        from: range?.from,
        to: range?.to,
        cursor: cursor,
      )).data!;

  @override
  Future<HistoryView> build() async {
    _read += 1;
    final range = _range;
    final page = await _page(range, null);
    return HistoryView(
      range: range,
      payCurrency: page.payCurrency,
      orders: page.orders.toList(),
      next: page.next,
    );
  }

  /// Reads the first page again for another range (null: every order).
  void show(HistoryRange? range) {
    _range = range;
    ref.invalidateSelf();
  }

  Future<void> more() async {
    final shown = state.value;
    if (shown == null || shown.next == null || shown.loadingMore) return;
    final read = _read;
    state = AsyncData(shown.copyWith(next: shown.next, loadingMore: true));
    bool stale() => !ref.mounted || read != _read;
    try {
      final page = await _page(shown.range, shown.next);
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

/// The orders by business day, in the server's order (newest first).
List<(Date, List<HistoryOrder>)> daysOf(List<HistoryOrder> orders) {
  final days = <(Date, List<HistoryOrder>)>[];
  for (final order in orders) {
    if (days.isNotEmpty && days.last.$1 == order.day) {
      days.last.$2.add(order);
    } else {
      days.add((order.day, [order]));
    }
  }
  return days;
}

extension HistoryTexts on AppLocalizations {
  /// Currency lines as «5 $ + 195 ₺».
  String linesText(Iterable<HistoryLine> lines) =>
      lines.map((line) => formatMoney(line.amount, line.currency)).join(' + ');

  /// A business day as dd/mm/yyyy.
  String dayText(Date day) => formatDate(day.toDateTime(utc: true));

  /// How the order ended for the captain: handed over, or its status.
  String endText(HistoryOrder order) => order.handedOver
      ? captainHistoryHandedOver
      : switch (order.status.name) {
          'delivered' => captainHistoryStatusDelivered,
          'failed' => captainHistoryStatusFailed,
          _ => captainHistoryStatusCancelled,
        };

  String stepText(String step) => switch (step) {
    'assigned' => captainHistoryStepAssigned,
    'receivedHandover' => captainHistoryStepReceivedHandover,
    'arrivedAtRestaurant' => captainHistoryStepArrivedAtRestaurant,
    'pickedUp' => captainHistoryStepPickedUp,
    'handedOver' => captainHistoryStepHandedOver,
    'arrivedAtCustomer' => captainHistoryStepArrivedAtCustomer,
    'delivered' => captainHistoryStepDelivered,
    'failed' => captainHistoryStepFailed,
    _ => captainHistoryStepCancelled,
  };
}
