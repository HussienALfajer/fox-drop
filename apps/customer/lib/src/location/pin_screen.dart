import 'package:core_l10n/core_l10n.dart';
import 'package:core_maps/core_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pin.dart';

/// «اختر على الخريطة» (CU §7.1, §7.4): the customer moves the map under a
/// fixed pin and confirms at street level; the screen answers the point.
/// Unstyled until the design.
class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key, required this.initial});

  final MapCamera initial;

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  late MapCamera _camera = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final confirmable = _camera.pinConfirmable;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerChooseOnMap)),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(pinMapProvider)(
              initial: widget.initial,
              onCamera: (camera) => setState(() => _camera = camera),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!confirmable)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 8),
                    child: Text(
                      l10n.customerZoomInToConfirm,
                      textAlign: TextAlign.center,
                    ),
                  ),
                FilledButton(
                  key: const Key('confirm-pin'),
                  onPressed: confirmable
                      ? () => context.pop(_camera.centre)
                      : null,
                  child: Text(l10n.customerConfirmLocation),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
