import 'package:core_auth/core_auth.dart';
import 'package:core_platform/core_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';
import 'home_screen.dart';
import 'platform.dart';

/// The blocking update or maintenance screen (CU §4.2, §4.7), with the
/// active orders still reachable: their screens stay readable.
class BlockedScreen extends ConsumerWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final check = ref.watch(platformCheckProvider);
    final signedIn = ref.watch(customerAuth.session).value is SignedIn;
    return ListenableBuilder(
      listenable: check,
      builder: (context, _) => PlatformBlockScreen(
        status: check.status,
        url: updateUrl(),
        extra: signedIn ? const ActiveOrdersBar() : null,
      ),
    );
  }
}
