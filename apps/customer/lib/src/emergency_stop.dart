import 'dart:async';

import 'package:core_api/core_api.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';
import 'checkout/quote.dart';
import 'location/delivery_point.dart';
import 'orders/order_live.dart';

/// The server's answer as the stop the app keeps (AP §9.1.6).
EmergencyStop emergencyStopOf(CustomerEmergencyStopDtoOutput answer) =>
    EmergencyStop(
      active: answer.active,
      startedAt: answer.startedAt,
      browseMessage: answer.browseMessage,
      delayNotice: answer.delayNotice,
    );

EmergencyStopCheck _check(Ref ref, num latitude, num longitude) {
  final api = ref.watch(coreApiProvider).getCustomerApi();
  final check = EmergencyStopCheck(() async {
    final answer = await api.customerEmergencyStopRead(
      latitude: '$latitude',
      longitude: '$longitude',
    );
    return emergencyStopOf(answer.data!);
  });
  ref.onDispose(check.dispose);
  check.start();
  return check;
}

/// The stop of the delivery point's city while browsing (CU §4.7): read
/// when a point is checked and on each return to the foreground. The app
/// has no channel of its own, so a stop that starts while it stays open
/// shows at the next read; ordering is refused by the quote meanwhile. Null
/// without a checked point.
final emergencyStopProvider = Provider.autoDispose<EmergencyStopCheck?>((ref) {
  final point = ref.watch(
    deliveryPointProvider.select((p) => p is PointChecked ? p.point : null),
  );
  if (point == null) return null;
  final check = _check(ref, point.latitude, point.longitude);
  // A stop seen ending asks the quote again, so checkout's «تأكيد الطلب»
  // does not wait for another change (CU §4.7).
  final switches = check.switched.listen((on) {
    if (!on) ref.invalidate(quoteProvider);
  });
  ref.onDispose(() => unawaited(switches.cancel()));
  return check;
});

/// The stop of an open order's city (CU §11.6): read at its address when
/// the order screen opens, and again on each `platform.emergency_stop` on
/// the order's channel and whenever it connects. Null until the order is
/// read.
final orderEmergencyStopProvider = Provider.autoDispose
    .family<EmergencyStopCheck?, String>((ref, id) {
      final location = ref.watch(
        orderProvider(
          id,
        ).select((state) => state.value?.value?.address.location),
      );
      if (location == null) return null;
      final check = _check(ref, location.latitude, location.longitude);
      final following = followPlatformBroadcasts(
        ref.watch(realtimeTransportProvider).channel('order:$id'),
        stop: check,
      );
      ref.onDispose(() => unawaited(following.cancel()));
      return check;
    });

/// The browsing banner (CU §4.7, §6.2 item 2): the stop's browsing message
/// while it is on; nothing otherwise.
class EmergencyStopNotice extends ConsumerWidget {
  const EmergencyStopNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final check = ref.watch(emergencyStopProvider);
    if (check == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: check,
      builder: (context, _) {
        final message = check.stop.browseMessage;
        return !check.stop.active || message == null
            ? const SizedBox.shrink()
            : ListTile(key: const Key('emergency-stop'), title: Text(message));
      },
    );
  }
}

/// The delay banner on an active order's screen (CU §11.6): the stop's
/// delay notice, its reason filled, while the stop is on.
class EmergencyDelayNotice extends ConsumerWidget {
  const EmergencyDelayNotice({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final check = ref.watch(orderEmergencyStopProvider(orderId));
    if (check == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: check,
      builder: (context, _) {
        final notice = check.stop.delayNotice;
        return !check.stop.active || notice == null
            ? const SizedBox.shrink()
            : ListTile(key: const Key('emergency-delay'), title: Text(notice));
      },
    );
  }
}
