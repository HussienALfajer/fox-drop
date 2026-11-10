import 'package:core_api/core_api.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef CustomerOrder = CustomerOrderDtoOutputOrder;

/// The statuses that end an order (AP §8.1).
const endedStatuses = {'delivered', 'rejected', 'cancelled', 'failed'};

/// One order kept current over `order:{order_id}` (CU §4.3, §11): fetched
/// on opening, after each newer event and every reconnect without recovery,
/// and every 30 seconds while the socket is down.
final orderFeedProvider = Provider.autoDispose
    .family<LiveFeed<CustomerOrder>, String>((ref, id) {
      final api = ref.watch(coreApiProvider).getCustomerApi();
      final feed = LiveFeed<CustomerOrder>(
        transport: ref.watch(realtimeTransportProvider),
        channel: 'order:$id',
        fetch: () async =>
            (await api.customerOrdersOrder(orderId: id)).data!.order,
        versions: (order) => {order.id: order.version},
      );
      feed.start();
      ref.onDispose(feed.close);
      return feed;
    });

final orderProvider = StreamProvider.autoDispose
    .family<LiveState<CustomerOrder>, String>((ref, id) async* {
      yield* ref.watch(orderFeedProvider(id)).watch();
    });

/// The five steps of the progress bar (CU §11.1): «تأكيد المطعم» ·
/// «التحضير» · «في الطريق» · «عند الباب» · «التسليم».
enum OrderStep { confirm, preparing, onTheWay, atDoor, delivered }

/// The step an order is at; null once it ended without delivery. A pending
/// pickup request stays at the restaurant's step (CU §11.2).
OrderStep? stepOf(String status) => switch (status) {
  'placed' => OrderStep.confirm,
  'accepted' || 'ready' => OrderStep.preparing,
  'pickedUp' || 'picked_up' => OrderStep.onTheWay,
  'arrived' => OrderStep.atDoor,
  'delivered' => OrderStep.delivered,
  _ => null,
};

/// The title and subtitle of CU §11.2 and §11.9, as data the screen turns
/// into strings.
sealed class OrderTitle {
  const OrderTitle();
}

/// «بانتظار تأكيد المطعم» — «أرسلنا طلبك إلى {المطعم}».
class AwaitingRestaurant extends OrderTitle {
  const AwaitingRestaurant(this.restaurant);
  final String restaurant;
}

/// «المطعم يحضّر طلبك», with «يصل حوالي {الساعة}», or the captain on the
/// way to the restaurant or at it.
class Preparing extends OrderTitle {
  const Preparing({this.promisedAt, this.captain, this.captainThere = false});
  final DateTime? promisedAt;
  final String? captain;
  final bool captainThere;
}

/// «طلبك جاهز» — «ينتظر الكابتن» or «الكابتن يستلم طلبك الآن».
class ReadyForCaptain extends OrderTitle {
  const ReadyForCaptain({required this.captainThere});
  final bool captainThere;
}

/// «في الطريق إليك» — «الكابتن {الاسم} استلم طلبك», or «المبلغ المطلوب
/// الآن: {المبلغ}» once operations set an outcome with an amount to collect.
class OnTheWay extends OrderTitle {
  const OnTheWay(this.captain, {this.dueNow});
  final String captain;

  /// CU §11.6 (K9, slice 2.11b): the amount the captain still collects, in
  /// minor units of the order's currency.
  final String? dueNow;
}

/// «الكابتن عند الباب» — «جهّز {المبلغ}», or «المبلغ المطلوب الآن: {المبلغ}».
class AtDoor extends OrderTitle {
  const AtDoor({this.dueNow});

  final String? dueNow;
}

/// «تم التسليم» — «بالعافية!».
class Delivered extends OrderTitle {
  const Delivered({this.paidNothing = false});

  /// CU §11.9: a free or damaged order operations delivered with nothing to
  /// pay, «لم تدفع شيئاً لهذا الطلب» (AP §8.9).
  final bool paidNothing;
}

/// CU §11.9: «لم يرد المطعم على طلبك، نعتذر» (AP §8.3), its own wording.
class NoRestaurantResponse extends OrderTitle {
  const NoRestaurantResponse();
}

/// CU §11.9: «نعتذر، لم يقبل المطعم طلبك», with the reason's customer text
/// the order kept (CU Appendix C).
class Rejected extends OrderTitle {
  const Rejected(this.text);

  final String? text;
}

/// CU §11.9: «أُلغي طلبك» by operations, with the customer-facing reason
/// the order kept from Content (CU Appendix C).
class Cancelled extends OrderTitle {
  const Cancelled(this.text);

  final String? text;
}

/// CU §11.9: «ألغيت طلبك», the customer's own while placed (§11.4).
class CancelledByYou extends OrderTitle {
  const CancelledByYou();
}

/// CU §11.9: «تعذّر التسليم», with the reason the outcome kept from Content
/// (CU Appendix C).
class Failed extends OrderTitle {
  const Failed(this.text);

  final String? text;
}

OrderTitle titleOf(CustomerOrder order) {
  final captain = order.captain;
  final outcome = order.outcome;
  // CU §11.6: an outcome waiting for the captain to collect its amount.
  final dueNow = outcome != null && outcome.awaitingCollection
      ? outcome.amountToCollect.amount
      : null;
  return switch (order.status.name) {
    'placed' => AwaitingRestaurant(order.restaurant.nameAr),
    'accepted' => Preparing(
      promisedAt: order.promisedAt,
      captain: captain?.firstName,
      captainThere: captain?.atRestaurant ?? false,
    ),
    'ready' => ReadyForCaptain(captainThere: captain?.atRestaurant ?? false),
    'pickedUp' ||
    'picked_up' => OnTheWay(captain?.firstName ?? '', dueNow: dueNow),
    'arrived' => AtDoor(dueNow: dueNow),
    'delivered' => Delivered(
      paidNothing: order.outcome?.amountToCollect.amount == '0',
    ),
    'rejected' => Rejected(order.rejection?.text),
    'failed' => Failed(order.outcome?.text),
    _ =>
      order.cancellation?.byCustomer ?? false
          ? const CancelledByYou()
          : order.cancellation?.reason == 'merchant_auto_cancel'
          ? const NoRestaurantResponse()
          : Cancelled(order.cancellation?.text),
  };
}

/// The customer's active orders (CU §6), newest first, for the home's bar.
/// Fetched when home opens; the order screen keeps each one live.
final activeOrdersProvider =
    FutureProvider.autoDispose<List<CustomerActiveOrdersDtoOutputOrdersInner>>((
      ref,
    ) async {
      final response = await ref
          .watch(coreApiProvider)
          .getCustomerApi()
          .customerOrdersActive();
      return response.data!.orders.toList();
    });
