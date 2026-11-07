import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:flutter/foundation.dart';

import 'api.dart';

/// The platform the code request and the device record name. Windows has no
/// App Check and says so (the identity module's `CLAUDE.md`).
MerchantDeviceDtoPlatformEnum devicePlatform() =>
    switch (defaultTargetPlatform) {
      TargetPlatform.windows => MerchantDeviceDtoPlatformEnum.windows,
      TargetPlatform.iOS => MerchantDeviceDtoPlatformEnum.ios,
      _ => MerchantDeviceDtoPlatformEnum.android,
    };

/// A restaurant user's sign-in and session (RA §5.2–5.3), with «لديّ رمز من
/// العمليات» when no code can be sent.
final merchantAuth = AuthScope(
  party: (ref) => MerchantAuth(
    ref.watch(authApiProvider),
    platform: MerchantCodeRequestDtoPlatformEnum.valueOf(devicePlatform().name),
  ),
  offersOperationsCode: true,
);
