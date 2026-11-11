import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import 'call.dart';
import 'commands.dart';
import 'order_view.dart';
import 'work.dart';

/// K12: how long «طوارئ» must be held (fixed).
const emergencyHold = Duration(seconds: 2);

/// The operations number kept on the phone after each fetch, so «طوارئ»
/// still calls when the fetch fails with no signal.
const operationsPhoneKey = 'captain.operations_phone';

/// CA §9.11 «طوارئ» (C15, K12; slice 2.13c): the red button on the active
/// order. Held for [emergencyHold], with its progress ring, it calls
/// operations (directly on Android with the call permission) and, for the
/// order's own captain while none is open, sends the emergency with the
/// latest fix. Once open it says so and only calls again; it cannot be
/// withdrawn (owner decision 2026-11-11). Unstyled until the design, but
/// for the red the spec gives it.
class EmergencyButton extends ConsumerStatefulWidget {
  const EmergencyButton({super.key, required this.order});

  final ActiveOrder order;

  @override
  ConsumerState<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends ConsumerState<EmergencyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hold =
      AnimationController(vsync: this, duration: emergencyHold)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _fire();
        });

  @override
  void initState() {
    super.initState();
    ref.listenManual(captainAuth.contact, (_, next) {
      final phone = next.value?.phone;
      if (phone != null) {
        unawaited(ref.read(captainAuth.store).write(operationsPhoneKey, phone));
      }
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  Future<String?> _phone() async {
    final live = ref.read(captainAuth.contact).value?.phone;
    if (live != null) return live;
    try {
      return await ref.read(captainAuth.store).read(operationsPhoneKey);
    } on Object {
      return null;
    }
  }

  Future<void> _fire() async {
    final order = widget.order;
    // The second captain of a handover does not have the order yet: they
    // only call (CA §15).
    final send = order.emergency == null && receiving(order) == null
        ? ref.read(commandsProvider.notifier).emergency(order.id)
        : null;
    final phone = await _phone();
    if (phone != null) await ref.read(operationsCallerProvider).call(phone);
    final notice = phone == null ? const NoOperationsNumber() : await send;
    if (phone == null) await send;
    if (mounted) {
      _hold.reset();
      showNotice(context, notice);
    }
  }

  void _release() {
    if (_hold.status != AnimationStatus.completed) _hold.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Kept loaded, so the call needs no request when it is pressed.
    ref.watch(captainAuth.contact);
    final pressed = widget.order.emergency;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pressed != null)
            Text(
              pressed.located
                  ? l10n.captainEmergencySent
                  : l10n.captainEmergencySentNoLocation,
            ),
          Semantics(
            button: true,
            hint: l10n.captainEmergencyHold,
            child: GestureDetector(
              onTapDown: (_) => _hold.forward(from: 0),
              onTapUp: (_) => _release(),
              onTapCancel: _release,
              child: Material(
                color: scheme.error,
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _hold,
                        builder: (context, _) => SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            value: _hold.value,
                            color: scheme.onError,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.captainEmergency,
                        style: TextStyle(color: scheme.onError),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
