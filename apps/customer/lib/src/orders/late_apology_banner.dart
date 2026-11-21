import 'dart:async';

import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'order_live.dart';

/// CU §11.6, §14 #14: from `lateApologyAt`, by the server clock, while the
/// order has not ended, «نعتذر، طلبك متأخر قليلاً. نتابعه الآن.». It appears
/// by itself when the time passes with the screen open. Unstyled until the
/// design.
class LateApologyBanner extends ConsumerStatefulWidget {
  const LateApologyBanner({super.key, required this.order});

  final CustomerOrder order;

  @override
  ConsumerState<LateApologyBanner> createState() => _LateApologyBannerState();
}

class _LateApologyBannerState extends ConsumerState<LateApologyBanner> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timer?.cancel();
    _timer = null;
    final order = widget.order;
    final at = order.lateApologyAt;
    if (at == null || endedStatuses.contains(order.status.name)) {
      return const SizedBox.shrink();
    }
    final now = ref.watch(serverClockProvider).now();
    if (now.isBefore(at)) {
      _timer = Timer(at.difference(now), () {
        if (mounted) setState(() {});
      });
      return const SizedBox.shrink();
    }
    return ListTile(
      key: const Key('late-apology-banner'),
      title: Text(AppLocalizations.of(context).customerLateApology),
    );
  }
}
