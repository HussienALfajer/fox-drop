import 'package:core_api/core_api.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../device.dart';

typedef Board = MerchantOrdersDtoOutput;
typedef BoardOrder = MerchantOrdersDtoOutputOrdersInner;
typedef OrderStatus = MerchantOrdersDtoOutputOrdersInnerStatusEnum;
typedef CaptainTrack = MerchantOrdersDtoOutputOrdersInnerCaptainTrackEnum;
typedef PickupRequest = MerchantOrdersDtoOutputOrdersInnerPickupRequest;
typedef PickupRequestStatus =
    MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum;
typedef PickupOutcome =
    MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum;
typedef BoardCancellation = MerchantOrdersDtoOutputOrdersInnerCancellation;
typedef BoardItemReport = MerchantOrdersDtoOutputOrdersInnerItemReport;
typedef BoardEdit = MerchantOrdersDtoOutputOrdersInnerEditsInner;
typedef BoardEditChange =
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner;
typedef EditChangeKind =
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum;

/// The board's columns, right to left (RA §8.1–8.2).
enum BoardColumn { incoming, preparing, ready, withCaptain }

/// The column an order shows in (RA §8.1). A delivered order stays in «مع
/// الكابتن» while its pickup dispute window is open, for «المبلغ غير صحيح»
/// (RA §8.10 item 8); the server lists it until then.
BoardColumn? columnOf(BoardOrder order) => switch (order.status) {
  OrderStatus.placed => BoardColumn.incoming,
  OrderStatus.accepted => BoardColumn.preparing,
  OrderStatus.ready => BoardColumn.ready,
  OrderStatus.pickedUp ||
  OrderStatus.arrived ||
  OrderStatus.delivered => BoardColumn.withCaptain,
  _ => null,
};

/// RA §8.2: a new order past `order.merchant_accept_alert_min`, or an order
/// in preparation past its prep time.
bool isLate(BoardOrder order, DateTime now) => switch (order.status) {
  OrderStatus.placed =>
    order.acceptAlertAt != null && !now.isBefore(order.acceptAlertAt!),
  OrderStatus.accepted =>
    order.acceptance != null && !now.isBefore(order.acceptance!.prepDueAt),
  _ => false,
};

/// The open pickup request that rings (RA §8.10 item 3), or null.
PickupRequest? openRequest(BoardOrder order) {
  final request = order.pickup.request;
  return request?.status == PickupRequestStatus.open ? request : null;
}

/// Whether «صنف غير متوفر — اتصلوا بالزبون» is offered (RA §8.12, §8.10):
/// an accepted or ready order, before pickup, with no pickup request open and
/// no report open already.
bool canReportItems(BoardOrder order) =>
    (order.status == OrderStatus.accepted ||
        order.status == OrderStatus.ready) &&
    order.captainTrack != CaptainTrack.pickupPending &&
    openRequest(order) == null &&
    order.itemReport == null;

/// Whether «تراجع — الصنف متوفر» is offered: the report is open and the
/// order still accepted or ready (RA §8.12).
bool canWithdrawItemReport(BoardOrder order) =>
    order.itemReport != null &&
    (order.status == OrderStatus.accepted || order.status == OrderStatus.ready);

/// One column's orders in the order RA §8.2 sorts them.
List<BoardOrder> columnOrders(Board board, BoardColumn column) {
  final orders = board.orders.where((o) => columnOf(o) == column).toList();
  int at(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  switch (column) {
    case BoardColumn.incoming:
      orders.sort((a, b) => a.placedAt.compareTo(b.placedAt));
    case BoardColumn.preparing:
      // Least time left first, so late orders come on top.
      orders.sort(
        (a, b) => at(a.acceptance?.prepDueAt, b.acceptance?.prepDueAt),
      );
    case BoardColumn.ready:
      // The captain waiting on top, longest first; then the order readied
      // first. The captain's ETA comes with its slice.
      orders.sort((a, b) {
        final waiting = at(a.captainArrival?.at, b.captainArrival?.at);
        return waiting != 0 ? waiting : at(a.readyAt, b.readyAt);
      });
    case BoardColumn.withCaptain:
      orders.sort((a, b) => at(a.pickup.pickedUpAt, b.pickup.pickedUpAt));
  }
  return orders;
}

/// The captain line on a card (RA §8.1).
sealed class CaptainLine {
  const CaptainLine();
}

/// «بانتظار كابتن».
class WaitingForCaptain extends CaptainLine {
  const WaitingForCaptain();
}

/// «الكابتن {الاسم} في الطريق»; the ETA comes with its slice.
class CaptainOnTheWay extends CaptainLine {
  const CaptainOnTheWay(this.name);
  final String name;
}

/// «وصل الكابتن — ينتظر منذ {د} د».
class CaptainWaiting extends CaptainLine {
  const CaptainWaiting(this.since);
  final DateTime since;
}

/// «الكابتن يطلب تأكيد الاستلام».
class CaptainAsksPickup extends CaptainLine {
  const CaptainAsksPickup();
}

/// «مع الكابتن {الاسم}».
class WithCaptain extends CaptainLine {
  const WithCaptain(this.name);
  final String name;
}

CaptainLine? captainLine(BoardOrder order) {
  final name = order.captain?.firstName ?? '';
  return switch (order.captainTrack) {
    CaptainTrack.searching || CaptainTrack.offered => const WaitingForCaptain(),
    CaptainTrack.assigned => CaptainOnTheWay(name),
    CaptainTrack.atMerchant => CaptainWaiting(
      order.captainArrival?.at ?? order.placedAt,
    ),
    CaptainTrack.pickupPending => const CaptainAsksPickup(),
    CaptainTrack.pickedUp ||
    CaptainTrack.atCustomer ||
    CaptainTrack.done => WithCaptain(name),
    // RA §8.8: ready with no captain yet shows «بانتظار كابتن».
    _ => order.status == OrderStatus.ready ? const WaitingForCaptain() : null,
  };
}

/// Whether operations' unacknowledged edits include one that added items:
/// it rings until «اطلعت على التعديل» and blocks the pickup (RA §8.13).
bool editRings(BoardOrder order) => order.edits.any((edit) => edit.addsItems);

/// What rings on the board (RA §4.4): new orders, open pickup requests,
/// operations' cancellations after acceptance and their edits that added
/// items, oldest first. One sound plays
/// for all of them; the prompts stack.
sealed class Ringing {
  const Ringing(this.order);
  final BoardOrder order;
  DateTime get since;
}

/// The new-order prompt (RA §8.3).
class NewOrderRinging extends Ringing {
  const NewOrderRinging(super.order);
  @override
  DateTime get since => order.placedAt;
}

/// The pickup prompt (RA §8.10 item 3).
class PickupRinging extends Ringing {
  const PickupRinging(super.order, this.request);
  final PickupRequest request;
  @override
  DateTime get since => request.confirmBy;
}

/// «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}» until «حسناً» on any
/// device (RA §8.14, §18). The server lists a cancelled order with its
/// `cancellation` only until then.
class CancelledRinging extends Ringing {
  const CancelledRinging(super.order, this.cancellation);
  final BoardCancellation cancellation;
  @override
  DateTime get since => cancellation.at;
}

/// «تم تعديل الطلب #{رقم} — أُضيفت أصناف» until «اطلعت على التعديل» on any
/// device (RA §8.13), with every edit not yet acknowledged.
class EditRinging extends Ringing {
  const EditRinging(super.order);
  @override
  DateTime get since => order.edits.first.at;
}

List<Ringing> ringing(Board board) {
  final items = <Ringing>[
    for (final order in board.orders)
      if (order.status == OrderStatus.placed && !editRings(order))
        NewOrderRinging(order)
      else if (editRings(order))
        EditRinging(order)
      else if (order.status == OrderStatus.cancelled &&
          order.cancellation != null)
        CancelledRinging(order, order.cancellation!)
      else if (openRequest(order) case final request?)
        PickupRinging(order, request),
  ]..sort((a, b) => a.since.compareTo(b.since));
  return items;
}

/// The prep time chosen in the accept prompt: the default, kept within the
/// floor and the ceiling (RA §8.5).
int clampPrep(MerchantOrdersDtoOutputPrepTime prep, int minutes) =>
    minutes.clamp(prep.floorMin, prep.ceilingMin);

/// The board kept current over `merchant:{restaurant_id}` (RA §4.3): fetched
/// on opening, after each newer event and every reconnect without recovery,
/// and polled while the connection is down.
final boardFeedProvider = Provider.autoDispose<LiveFeed<Board>?>((ref) {
  final session = ref.watch(merchantSessionProvider).value;
  if (session == null) return null;
  final api = ref.watch(coreApiProvider).getMerchantApi();
  final feed = LiveFeed<Board>(
    transport: ref.watch(realtimeTransportProvider),
    channel: 'merchant:${session.restaurantId}',
    fetch: () async => (await api.merchantOrdersBoard()).data!,
    versions: (board) => {for (final o in board.orders) o.id: o.version},
  );
  feed.start();
  ref.onDispose(feed.close);
  return feed;
});

/// The board's latest state.
final boardProvider = StreamProvider.autoDispose<LiveState<Board>>((ref) {
  final feed = ref.watch(boardFeedProvider);
  if (feed == null) return const Stream.empty();
  return feed.watch();
});
