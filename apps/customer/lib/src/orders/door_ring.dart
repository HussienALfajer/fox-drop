import 'dart:async';

import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../api.dart';
import '../auth.dart';
import 'order_live.dart';

/// CU §11.7: the open app's ring lasts 30 seconds from the ping (fixed).
const doorRingFor = Duration(seconds: 30);

/// The door ping's sound while the app is open: the phone's ringtone,
/// looping, until the design's bundled sounds (as the restaurant and captain
/// apps). Android only for now; tests give a fake.
abstract interface class DoorRinger {
  void ring();
  void stop();
}

class PhoneDoorRinger implements DoorRinger {
  final _player = FlutterRingtonePlayer();
  bool _ringing = false;

  bool get _supported => defaultTargetPlatform == TargetPlatform.android;

  @override
  void ring() {
    if (!_supported || _ringing) return;
    _ringing = true;
    unawaited(_player.playRingtone(looping: true));
  }

  @override
  void stop() {
    if (!_supported || !_ringing) return;
    _ringing = false;
    unawaited(_player.stop());
  }
}

final doorRingerProvider = Provider<DoorRinger>((ref) => PhoneDoorRinger());

/// The ping the open app rings for now (CU §11.7): the order at the door,
/// its latest ping unanswered, under 30 seconds old, and not put away on
/// this phone (an answer sent, or «اتصال بالكابتن»).
DateTime? ringingPing(CustomerOrder order, DateTime now, Set<DateTime> done) {
  final ping = order.doorPing;
  if (order.status.name != 'arrived' || ping == null) return null;
  if (ping.answer != null || done.contains(ping.at)) return null;
  final age = now.difference(ping.at);
  return age.isNegative || age >= doorRingFor ? null : ping.at;
}

/// «أنا قادم» or «سأتصل بالمستلم» (CU §11.7): one key per ping until an
/// answer, so a retry after a lost answer replays; any answer refreshes the
/// order, and a refusal (answered on another device) changes nothing.
class AnswerPing {
  AnswerPing(this._ref, this.orderId);

  final Ref _ref;
  final String orderId;
  final _keys = <DateTime, String>{};

  Future<void> send(DateTime ping) async {
    final alive = _ref.keepAlive();
    final key = _keys[ping] ??= uuidV4();
    try {
      await _ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerOrdersAnswerPing(orderId: orderId, idempotencyKey: key);
      _keys.remove(ping);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status != null && status < 500) _keys.remove(ping);
    } finally {
      _ref.read(orderFeedProvider(orderId)).refresh();
      alive.close();
    }
  }
}

final answerPingProvider = Provider.autoDispose.family<AnswerPing, String>(
  AnswerPing.new,
);

/// CU §11.7: over the order screen, the full-screen ring while a ping rings:
/// «الكابتن عند الباب ويحاول الوصول إليك» (or «… إلى {المستلم}»), «أنا قادم»
/// (or «سأتصل بالمستلم») and «اتصال بالكابتن» when the server gives the
/// number. It rings for 30 seconds from the ping, then the screen shows again.
class DoorRingGate extends ConsumerStatefulWidget {
  const DoorRingGate({super.key, required this.order, required this.child});

  final CustomerOrder order;
  final Widget child;

  @override
  ConsumerState<DoorRingGate> createState() => _DoorRingGateState();
}

class _DoorRingGateState extends ConsumerState<DoorRingGate> {
  final _done = <DateTime>{};
  Timer? _end;
  bool _ringing = false;
  late final DoorRinger _ringer = ref.read(doorRingerProvider);

  @override
  void dispose() {
    _end?.cancel();
    if (_ringing) _ringer.stop();
    super.dispose();
  }

  void _follow(DateTime? ping, DateTime now) {
    _end?.cancel();
    if (ping == null) {
      if (_ringing) _ringer.stop();
      _ringing = false;
      return;
    }
    if (!_ringing) _ringer.ring();
    _ringing = true;
    _end = Timer(ping.add(doorRingFor).difference(now), () {
      if (mounted) setState(() {});
    });
  }

  void _putAway(DateTime ping) => setState(() => _done.add(ping));

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final now = ref.watch(serverClockProvider).now();
    final ping = ringingPing(order, now, _done);
    _follow(ping, now);
    if (ping == null) return widget.child;
    final l10n = AppLocalizations.of(context);
    final recipient = order.address.recipientName;
    final phone = order.captain?.phone;
    return Scaffold(
      key: const Key('door-ring'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                recipient == null
                    ? l10n.customerDoorRing
                    : l10n.customerDoorRingRecipient(recipient),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('door-ring-answer'),
                onPressed: () {
                  _putAway(ping);
                  unawaited(ref.read(answerPingProvider(order.id)).send(ping));
                },
                child: Text(
                  recipient == null
                      ? l10n.customerComing
                      : l10n.customerCallingRecipient,
                ),
              ),
              if (phone != null)
                OutlinedButton(
                  key: const Key('door-ring-call'),
                  onPressed: () {
                    _putAway(ping);
                    unawaited(
                      ref.read(customerAuth.launch)(
                        Uri(scheme: 'tel', path: phone),
                      ),
                    );
                  },
                  child: Text(l10n.customerCallCaptain),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
