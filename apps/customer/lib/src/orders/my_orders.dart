import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'order_screen.dart';

typedef OrderSummary = CustomerOrderHistoryDtoOutputOrdersInner;

/// «طلباتي» as read so far: the active orders first, then the past ones,
/// newest first, and the cursor of the next page of past ones.
class MyOrdersView {
  const MyOrdersView(this.orders, this.next, {this.loadingMore = false});

  final List<OrderSummary> orders;

  /// Null once every page is read.
  final String? next;
  final bool loadingMore;

  List<OrderSummary> get active => [
    for (final order in orders)
      if (order.active) order,
  ];

  List<OrderSummary> get past => [
    for (final order in orders)
      if (!order.active) order,
  ];
}

/// CU §12.3 «طلباتي» (slice 2.28b): `GET /v1/customer/orders`, the first
/// page on opening, then «عرض المزيد» reads the next 20 past orders.
class MyOrders extends AsyncNotifier<MyOrdersView> {
  @override
  Future<MyOrdersView> build() async {
    final page = await _page(null);
    return MyOrdersView(page.orders.toList(), page.next);
  }

  Future<CustomerOrderHistoryDtoOutput> _page(String? cursor) async =>
      (await ref
              .read(coreApiProvider)
              .getCustomerApi()
              .customerOrdersHistory(cursor: cursor))
          .data!;

  /// The next page, once at a time; a failed one leaves the list as it was.
  Future<bool> loadMore() async {
    final view = state.value;
    if (view == null || view.next == null || view.loadingMore) return true;
    state = AsyncData(MyOrdersView(view.orders, view.next, loadingMore: true));
    try {
      final page = await _page(view.next);
      state = AsyncData(
        MyOrdersView([...view.orders, ...page.orders], page.next),
      );
      return true;
    } on Object {
      state = AsyncData(view);
      return false;
    }
  }
}

final myOrdersProvider =
    AsyncNotifierProvider.autoDispose<MyOrders, MyOrdersView>(MyOrders.new);

/// A status in «طلباتي» and a step of the detail's timeline (CU §12.3).
String historyStatusText(AppLocalizations l10n, String status) =>
    switch (status) {
      'delivered' => l10n.customerTimelineDelivered,
      'failed' => l10n.customerTimelineFailed,
      'rejected' => l10n.customerTimelineRejected,
      'cancelled' => l10n.customerTimelineCancelled,
      _ => statusText(l10n, status),
    };

/// A step of the order detail's timeline (CU §12.3).
String timelineStepText(AppLocalizations l10n, String step) => switch (step) {
  'placed' => l10n.customerTimelinePlaced,
  'accepted' => l10n.customerTimelineAccepted,
  'picked_up' || 'pickedUp' => l10n.customerTimelinePickedUp,
  'arrived' => l10n.customerTimelineArrived,
  _ => historyStatusText(l10n, step),
};

/// CU §12.3: «اطلب مرة أخرى» on a delivered, rejected or cancelled order,
/// never on a free re-delivery.
bool canOrderAgain(String status, {required bool redelivery}) =>
    !redelivery &&
    const {'delivered', 'rejected', 'cancelled'}.contains(status);
