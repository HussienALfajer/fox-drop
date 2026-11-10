import 'dart:async';
import 'dart:math';

import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../api.dart';
import '../content.dart';
import '../push.dart';
import 'door_payment.dart';
import 'location.dart';
import 'work.dart';

/// What a command's refusal says (CA §4.6: the app explains what happened).
sealed class Notice {
  const Notice();
}

/// The phone gives no position: location off or not allowed.
class LocationNeeded extends Notice {
  const LocationNeeded(this.problem);
  final LocationProblem? problem;
}

/// CA §7.2: every block of going online, as the server sends them.
class OnlineBlocked extends Notice {
  const OnlineBlocked(this.blocks);
  final List<Map<Object?, Object?>> blocks;
}

/// CA §15: no going offline with an active order.
class OfflineWithOrder extends Notice {
  const OfflineWithOrder();
}

/// «لم يعد العرض متاحاً» (CA §8.3).
class OfferUnavailable extends Notice {
  const OfferUnavailable();
}

/// Too far from the restaurant (C6) or the customer (K4), by the server's
/// measure.
class TooFar extends Notice {
  const TooFar({required this.fromCustomer, this.distanceMetres});
  final bool fromCustomer;
  final int? distanceMetres;
}

/// K3: «إشارة الموقع ضعيفة — اتصل بالعمليات لتسجيل وصولك».
class WeakLocation extends Notice {
  const WeakLocation();
}

/// A mock location is active (CA §4.3).
class SimulatedLocation extends Notice {
  const SimulatedLocation();
}

/// The fix sent was older than the server allows.
class StaleLocation extends Notice {
  const StaleLocation();
}

/// The server sees the captain offline.
class NotOnline extends Notice {
  const NotOnline();
}

/// «المبلغ لا يطابق المطلوب» (CA §9.4).
class AmountMismatch extends Notice {
  const AmountMismatch();
}

/// The net received is short: «المبلغ المقبوض أقل من المطلوب بـ {المبلغ}»,
/// and a reason is needed (K16).
class ShortfallReasonRequired extends Notice {
  const ShortfallReasonRequired(this.shortfall);
  final Money shortfall;
}

/// «سجّل الباقي الذي أعدته للزبون» (CA §9.7).
class Overpaid extends Notice {
  const Overpaid();
}

/// «تغيّر المبلغ المطلوب إلى {المبلغ}» (CA §9.7).
class AmountDueChanged extends Notice {
  const AmountDueChanged(this.amountDue);
  final Money? amountDue;
}

/// The order changed before the command arrived.
class StateChanged extends Notice {
  const StateChanged();
}

/// The restaurant reported an item unavailable (`409 item_report_open`):
/// «بانتظار تعديل الطلب من العمليات» (CA §9 step 2).
class ItemReportOpen extends Notice {
  const ItemReportOpen();
}

/// The restaurant has not acknowledged an edit that added items (`409
/// edit_unacknowledged`): «بانتظار تأكيد المطعم للتعديل» (CA §9 step 2, RA
/// §8.13).
class EditUnacknowledged extends Notice {
  const EditUnacknowledged();
}

/// Any other refusal.
class CommandFailed extends Notice {
  const CommandFailed();
}

/// The reason sent is no longer in its Content list, or its note rule
/// changed (`unknown_reason`, `reason_note_required`,
/// `reason_note_not_allowed`): the lists are read again, and the captain
/// chooses again.
class ReasonChanged extends Notice {
  const ReasonChanged();
}

/// The cash to hand in after going offline (CA §7.5), shown once.
class HandInNotifier extends Notifier<Money?> {
  @override
  Money? build() => null;

  void show(Money? amount) => state = amount;
}

final handInProvider = NotifierProvider<HandInNotifier, Money?>(
  HandInNotifier.new,
);

/// The order summary after delivery (CA §9.8), shown until closed.
class SummaryNotifier extends Notifier<Summary?> {
  @override
  Summary? build() => null;

  void show(Summary? summary) => state = summary;
}

final summaryProvider = NotifierProvider<SummaryNotifier, Summary?>(
  SummaryNotifier.new,
);

/// The app's version for going online (CA §4.2), as `1.2.3`.
final appVersionProvider = FutureProvider<String>(
  (ref) async => (await PackageInfo.fromPlatform()).version,
);

/// The commands of CA §15 in flight, by what they act on ('availability',
/// an offer's id or an order's id), which show «جارٍ الإرسال…» and cannot
/// be pressed again (CA §4.6).
class Commands extends Notifier<Set<String>> {
  final Map<String, String> _keys = {};

  /// Waits before each retry; tests make it short.
  Duration Function(int attempt) backoff = (attempt) {
    final base = min(15000, 1000 * pow(2, attempt).toInt());
    return Duration(milliseconds: base ~/ 2 + Random().nextInt(base ~/ 2 + 1));
  };

  @override
  Set<String> build() => const {};

  CaptainApi get _api => ref.read(coreApiProvider).getCaptainApi();
  LocationTracker get _tracker => ref.read(locationTrackerProvider);

  /// «متصل» (CA §7.2): the location first, since online means tracked.
  /// The notification permission is asked before it, never blocking.
  Future<Notice?> goOnline() async {
    await askNotifications(ref);
    final source = ref.read(locationSourceProvider);
    final problem = await source.ensureAccess();
    if (problem != null) return LocationNeeded(problem);
    // The mock-location check needs a position (CA §7.2); it is kept as
    // the latest but never sent, since the captain is still offline.
    final fix = await source.current();
    if (fix == null) return const LocationNeeded(LocationProblem.failed);
    _tracker.see(fix);
    final version = await ref.read(appVersionProvider.future);
    final (_, notice) = await _send(
      'availability',
      'online',
      (_) => _api.captainAvailabilityOnline(
        captainGoOnlineDto: CaptainGoOnlineDto(
          (b) => b
            ..appVersion = plainVersion(version)
            ..simulatedLocation = fix.simulated,
        ),
      ),
    );
    return notice;
  }

  /// Going offline (CA §7.5), with the hand-in reminder when cash is due.
  Future<Notice?> goOffline() async {
    final (answer, notice) = await _send(
      'availability',
      'offline',
      (_) => _api.captainAvailabilityOffline(),
    );
    if (answer?.data case final CaptainWentOfflineDtoOutput gone) {
      final handIn = gone.handIn;
      ref
          .read(handInProvider.notifier)
          .show(handIn == null ? null : Money(handIn.amount, handIn.currency));
    }
    return notice;
  }

  /// «قبول» (CA §8.3).
  Future<Notice?> accept(String offerId) async => (await _send(
    offerId,
    'accept',
    (key) => _api.captainOffersAccept(offerId: offerId, idempotencyKey: key),
  )).$2;

  /// «رفض» (CA §8.3): no reason needed.
  Future<Notice?> decline(String offerId) async => (await _send(
    offerId,
    'decline',
    (key) => _api.captainOffersDecline(offerId: offerId, idempotencyKey: key),
  )).$2;

  /// «وصلت إلى المطعم» (CA §9.2).
  Future<Notice?> arrive(String orderId) => _withFix(
    orderId,
    'arrive',
    (key, location) => _api.captainOrdersArrive(
      orderId: orderId,
      idempotencyKey: key,
      captainArriveDto: CaptainArriveDto((b) => b..location.replace(location)),
    ),
  );

  /// «دفعت للمطعم واستلمت الطلب» (CA §9.4) with the lines paid.
  Future<Notice?> requestPickup(String orderId, List<Money> lines) => _withFix(
    orderId,
    'pickup ${lines.map((l) => '${l.amount} ${l.currency}').join(',')}',
    (key, location) => _api.captainOrdersRequestPickup(
      orderId: orderId,
      idempotencyKey: key,
      captainPickupRequestDto: CaptainPickupRequestDto(
        (b) => b
          ..lines.addAll([
            for (final line in lines)
              MerchantPickupDisputeDtoReceivedLinesInner(
                (l) => l
                  ..amount = line.amount
                  ..currency = line.currency,
              ),
          ])
          ..location.replace(location),
      ),
    ),
  );

  /// «وصلت» at the customer (CA §9.6), with a reason when away (K4).
  Future<Notice?> arriveAtCustomer(String orderId, Reason? away) => _withFix(
    orderId,
    'at-customer ${away?.key}',
    (key, location) => _api.captainOrdersArriveAtCustomer(
      orderId: orderId,
      idempotencyKey: key,
      captainArriveAtCustomerDto: CaptainArriveAtCustomerDto(
        (b) => b
          ..location.replace(location)
          ..away = away == null
              ? null
              : (CaptainArriveAtCustomerDtoAwayBuilder()
                  ..reason = away.reason
                  ..note = away.note),
      ),
    ),
  );

  /// «تم التسليم» with the door payment (CA §9.7–9.8); the summary opens.
  Future<Notice?> deliver(String orderId, DoorPayment payment, Reason? away) =>
      _withFix(orderId, 'deliver ${payment.key} ${away?.key}', (
        key,
        location,
      ) async {
        final answer = await _api.captainOrdersDeliver(
          orderId: orderId,
          idempotencyKey: key,
          captainDeliverDto: CaptainDeliverDto(
            (b) => b
              ..received.addAll(payment.received.map(_line))
              ..change.addAll(payment.change.map(_line))
              ..amountDue.replace(
                AdminRecordDeliveryDtoAmountDue(
                  (m) => m
                    ..amount = payment.amountDue.amount
                    ..currency = payment.amountDue.currency,
                ),
              )
              ..shortfall = payment.shortfall == null
                  ? null
                  : (AdminRecordDeliveryDtoShortfallBuilder()
                      ..reason = payment.shortfall!.reason
                      ..note = payment.shortfall!.note)
              ..location.replace(location)
              ..away = away == null
                  ? null
                  : (CaptainDeliverDtoAwayBuilder()
                      ..reason = away.reason
                      ..note = away.note),
          ),
        );
        ref.read(summaryProvider.notifier).show(answer.data!.summary);
        return answer;
      });

  /// The payment of the amount operations set to collect with an outcome
  /// (CA §9.10, K9), with the latest fix when there is one (CA §15; no
  /// radius applies, since the screen opens wherever the captain is); the
  /// summary opens.
  Future<Notice?> collectOutcome(String orderId, DoorPayment payment) async {
    final (answer, notice) = await _send(
      orderId,
      'outcome-payment ${payment.key}',
      (key) async {
        final fix = await _freshFix();
        return _api.captainOrdersCollectOutcome(
          orderId: orderId,
          idempotencyKey: key,
          captainOutcomePaymentDto: CaptainOutcomePaymentDto(
            (b) => b
              ..location = fix == null
                  ? null
                  : (CaptainOutcomePaymentDtoLocationBuilder()
                      ..latitude = fix.latitude
                      ..longitude = fix.longitude
                      ..accuracyMetres = fix.accuracyMetres
                      ..recordedAt = fix.recordedAt
                      ..simulated = fix.simulated)
              ..received.addAll(payment.received.map(_line))
              ..change.addAll(payment.change.map(_line))
              ..amountDue.replace(
                AdminRecordDeliveryDtoAmountDue(
                  (m) => m
                    ..amount = payment.amountDue.amount
                    ..currency = payment.amountDue.currency,
                ),
              )
              ..shortfall = payment.shortfall == null
                  ? null
                  : (AdminRecordDeliveryDtoShortfallBuilder()
                      ..reason = payment.shortfall!.reason
                      ..note = payment.shortfall!.note),
          ),
        );
      },
    );
    final data = answer?.data;
    if (data is CaptainDeliverySummaryDtoOutput) {
      ref.read(summaryProvider.notifier).show(data.summary);
    }
    return notice;
  }

  /// «حسناً» on an order operations cancelled (CA §9.10): no key and no
  /// location, since it only records once that the captain saw it.
  Future<Notice?> acknowledgeCancellation(String orderId) async => (await _send(
    orderId,
    'acknowledge-cancellation',
    (_) => _api.captainOrdersAcknowledgeCancellation(orderId: orderId),
  )).$2;

  /// «حسناً» on an order operations ended with an outcome (CA §9.12): no key
  /// and no location, as the cancellation's.
  Future<Notice?> acknowledgeOutcome(String orderId) async => (await _send(
    orderId,
    'acknowledge-outcome',
    (_) => _api.captainOrdersAcknowledgeOutcome(orderId: orderId),
  )).$2;

  static AdminRecordDeliveryDtoReceivedInner _line(Money line) =>
      AdminRecordDeliveryDtoReceivedInner(
        (l) => l
          ..amount = line.amount
          ..currency = line.currency,
      );

  /// A command that carries the latest fix (CA §15): the tracked one when
  /// recent, else a fresh position.
  Future<Notice?> _withFix(
    String orderId,
    String body,
    Future<Object?> Function(String key, CaptainArriveDtoLocation location)
    call,
  ) async {
    final first = await _freshFix();
    if (first == null) {
      return LocationNeeded(
        await ref.read(locationSourceProvider).ensureAccess(),
      );
    }
    // Each attempt takes the latest fix, so a retry on weak internet never
    // sends one past the server's minute; the key leaves the fix out.
    var fix = first;
    return (await _send(orderId, body, (key) async {
      fix = await _freshFix() ?? fix;
      final location = CaptainArriveDtoLocation(
        (l) => l
          ..latitude = fix.latitude
          ..longitude = fix.longitude
          ..accuracyMetres = fix.accuracyMetres
          ..recordedAt = fix.recordedAt
          ..simulated = fix.simulated,
      );
      return call(key, location);
    })).$2;
  }

  Future<Fix?> _freshFix() async {
    final latest = _tracker.latest;
    final now = ref.read(serverClockProvider).now();
    if (latest != null &&
        now.difference(latest.recordedAt) < const Duration(seconds: 20)) {
      return latest;
    }
    final fix = await ref.read(locationSourceProvider).current();
    if (fix == null) return latest;
    _tracker.remember(fix);
    return _tracker.latest;
  }

  // One command at a time per subject. Its key belongs to the command and
  // its body: a call without an answer (none, a 5xx, a 408 or a 429) is sent
  // again with the same key after a backoff until the server answers
  // (CA §4.6), and an answered command drops it. Any answer refreshes the
  // captain's state.
  Future<(Response<Object?>?, Notice?)> _send(
    String subject,
    String body,
    Future<Object?> Function(String key) call,
  ) async {
    if (state.contains(subject)) return (null, null);
    state = {...state, subject};
    final command = '$subject $body';
    final key = _keys[command] ??= uuidV4();
    try {
      for (var attempt = 0; ; attempt++) {
        try {
          final answer = await call(key);
          return (answer is Response<Object?> ? answer : null, null);
        } on DioException catch (error) {
          final answer = error.response;
          final status = answer?.statusCode ?? 0;
          if (answer != null &&
              status < 500 &&
              status != 408 &&
              status != 429) {
            final notice = refusal(answer.data);
            // The panel changed the list since the app read it.
            if (notice is ReasonChanged) ref.invalidate(contentProvider);
            return (null, notice);
          }
          if (!ref.mounted) return (null, null);
          await Future<void>.delayed(backoff(attempt));
          if (!ref.mounted) return (null, null);
        }
      }
    } on Object {
      // An answer the client could not read: the next fetch shows what
      // happened.
      return (null, const CommandFailed());
    } finally {
      _keys.remove(command);
      if (ref.mounted) {
        state = {...state}..remove(subject);
        refreshWork(ref);
      }
    }
  }
}

/// A refusal's body as the notice the screen shows.
Notice refusal(Object? body) {
  final error = body is Map ? body['error'] : null;
  Money? money(Object? value) =>
      value is Map ? Money('${value['amount']}', '${value['currency']}') : null;
  switch (error) {
    case 'online_blocked':
      final blocks = (body as Map)['blocks'];
      return OnlineBlocked([
        if (blocks is List)
          for (final block in blocks)
            if (block is Map) block,
      ]);
    case 'active_order':
      return const OfflineWithOrder();
    case 'offer_unavailable' || 'unknown_offer':
      return const OfferUnavailable();
    case 'too_far_from_restaurant' || 'too_far_from_customer':
      final distance = (body as Map)['distanceMetres'];
      return TooFar(
        fromCustomer: error == 'too_far_from_customer',
        distanceMetres: distance is num ? distance.round() : null,
      );
    case 'weak_location':
      return const WeakLocation();
    case 'simulated_location':
      return const SimulatedLocation();
    case 'stale_location':
      return const StaleLocation();
    case 'not_online':
      return const NotOnline();
    case 'amount_mismatch' || 'currency_not_accepted' || 'invalid_lines':
      return const AmountMismatch();
    case 'shortfall_reason_required':
      final shortfall = money((body as Map)['shortfall']);
      return shortfall == null
          ? const CommandFailed()
          : ShortfallReasonRequired(shortfall);
    case 'overpaid':
      return const Overpaid();
    case 'amount_due_changed':
      final order = (body as Map)['order'];
      return AmountDueChanged(order is Map ? money(order['collect']) : null);
    case 'item_report_open':
      return const ItemReportOpen();
    case 'edit_unacknowledged':
      return const EditUnacknowledged();
    case 'order_state_changed' || 'unknown_order':
      return const StateChanged();
    case 'unknown_reason' ||
        'reason_note_required' ||
        'reason_note_not_allowed':
      return const ReasonChanged();
    default:
      return const CommandFailed();
  }
}

/// The server takes the version as `1.2.3`; a build suffix is dropped.
/// The version without its build number, as the server takes it.
String plainVersion(String version) =>
    RegExp(r'^\d+\.\d+\.\d+').stringMatch(version) ?? version;

final commandsProvider = NotifierProvider<Commands, Set<String>>(Commands.new);
