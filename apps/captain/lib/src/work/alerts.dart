import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'work.dart';

/// The sounds of CA §4.4. Until the design's bundled sounds (owner decision
/// 2026-11-07, as the restaurant app), the offer ring is the phone's alarm
/// sound, looping on the alarm stream so the media volume and silent mode do
/// not mute it, and the chime and the cancellation sound are the phone's
/// notification sound.
abstract interface class Ringer {
  void ring();
  void stop();
  void chime();

  /// An order operations cancelled (CA §9.10, §14 #11).
  void cancellation();
}

/// The phone's sounds through `flutter_ringtone_player` (Android; iOS waits
/// for its slice). The plugin loops only on Android 9 and later and the
/// system can stop a sound, so while ringing the alarm starts again every
/// [replayEvery] (`apps/merchant/CLAUDE.md`).
class PhoneRinger implements Ringer {
  PhoneRinger({this.replayEvery = const Duration(seconds: 10)});

  final Duration replayEvery;
  final _player = FlutterRingtonePlayer();
  Timer? _replay;

  bool get _supported => defaultTargetPlatform == TargetPlatform.android;

  void _play() => unawaited(_player.playAlarm(looping: true, asAlarm: true));

  @override
  void ring() {
    if (!_supported || _replay != null) return;
    _play();
    _replay = Timer.periodic(replayEvery, (_) => _play());
  }

  @override
  void stop() {
    if (!_supported || _replay == null) return;
    _replay?.cancel();
    _replay = null;
    unawaited(_player.stop());
  }

  @override
  void chime() {
    // One player: a chime would end the ring, which is louder anyway.
    if (!_supported || _replay != null) return;
    unawaited(_player.playNotification());
  }

  // The bundled cancellation sound waits for the design (the design stop).
  @override
  void cancellation() => chime();
}

final ringerProvider = Provider<Ringer>((ref) => PhoneRinger());

/// Keeps the screen on while the captain is online (owner decision
/// 2026-11-07); tests replace it.
final keepScreenOnProvider = Provider<void Function(bool on)>(
  (ref) =>
      (on) => unawaited(on ? WakelockPlus.enable() : WakelockPlus.disable()),
);

/// CA §4.6: 30 seconds offline (fixed) plays one chime.
const offlineChimeAfter = Duration(seconds: 30);

/// The offer that rings now (CA §8.2): open, still in time and not answered
/// on this phone.
Offer? ringingOffer(Work? work, DateTime now, Set<String> answered) {
  final offer = work?.offer;
  if (offer == null || answered.contains(offer.id)) return null;
  return now.isBefore(offer.expiresAt) ? offer : null;
}

/// A message shown with a chime, or silently (CA §14).
sealed class Alert {
  const Alert({this.chimes = true});
  final bool chimes;
}

/// «انتهى العرض» (CA §8.3).
class OfferExpired extends Alert {
  const OfferExpired() : super(chimes: false);
}

/// «لم يعد العرض متاحاً» (CA §14 item 2, silent).
class OfferGone extends Alert {
  const OfferGone() : super(chimes: false);
}

/// «عيّنتك العمليات على طلب #{رقم}» (CA §14 item 4).
class AssignedByOperations extends Alert {
  const AssignedByOperations(this.number);
  final String number;
}

/// «الطلب #{رقم} جاهز» (CA §14 item 5).
class OrderReady extends Alert {
  const OrderReady(this.number);
  final String number;
}

/// «تم الاستلام — توجّه إلى الزبون», or «أكّدت العمليات الاستلام» (CA §9.4,
/// §14 item 7).
class PickedUp extends Alert {
  const PickedUp({required this.byOperations});
  final bool byOperations;
}

/// The restaurant refused the pickup request (CA §9.4, §14 item 8).
class PickupRefused extends Alert {
  const PickupRefused(this.request);
  final PickupRequest request;
}

/// «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات» (CA §9.4,
/// §14 item 9).
class PickupDisputed extends Alert {
  const PickupDisputed();
}

/// «أُلغيت المهمة: {السبب}» (CA §9.10, §14 #11): the cancellation card shows
/// it, with the cancellation sound instead of the chime.
class OrderCancelled extends Alert {
  const OrderCancelled(this.cancelled) : super(chimes: false);
  final Cancelled cancelled;
}

/// The offers and orders answered on this phone, whose closing it does not
/// announce as another's.
class Answered {
  final offers = <String>{};
  final orders = <String>{};
}

final answeredProvider = Provider<Answered>((ref) => Answered());

/// What changed between two states the server answered, as alerts (CA §14).
List<Alert> alertStep(
  Work? before,
  Work after,
  DateTime now,
  Answered answered,
) {
  if (before == null) return const [];
  final alerts = <Alert>[];
  final offer = before.offer;
  if (offer != null &&
      after.offer?.id != offer.id &&
      !answered.offers.contains(offer.id)) {
    alerts.add(
      now.isBefore(offer.expiresAt) ? const OfferGone() : const OfferExpired(),
    );
  }
  final cancelled = after.cancelled;
  if (cancelled != null && before.cancelled?.orderId != cancelled.orderId) {
    alerts.add(OrderCancelled(cancelled));
  }
  final was = before.order;
  final order = after.order;
  if (order == null) return alerts;
  if (was?.id != order.id) {
    if (!answered.orders.contains(order.id)) {
      alerts.add(AssignedByOperations(order.number));
    }
    return alerts;
  }
  if (!was!.preparation.ready && order.preparation.ready) {
    alerts.add(OrderReady(order.number));
  }
  if (was.captainTrack != Track.pickedUp &&
      order.captainTrack == Track.pickedUp) {
    alerts.add(
      PickedUp(
        byOperations:
            order.pickup.request?.outcome == RequestOutcome.operations,
      ),
    );
  }
  final refused = refusedRequest(order);
  if (refused != null &&
      was.pickup.request?.id == refused.id &&
      was.pickup.request?.status == RequestStatus.open) {
    alerts.add(PickupRefused(refused));
  }
  if (was.pickup.disputedAt == null && order.pickup.disputedAt != null) {
    alerts.add(const PickupDisputed());
  }
  return alerts;
}
