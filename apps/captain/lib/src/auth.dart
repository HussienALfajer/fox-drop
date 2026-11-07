import 'package:core_auth/core_auth.dart';

import 'api.dart';

/// The captain's sign-in and session (CA §4.9): one device at a time, and
/// «لديّ رمز من العمليات» when no code can be sent.
final captainAuth = AuthScope(
  party: (ref) => CaptainAuth(ref.watch(authApiProvider)),
  offersOperationsCode: true,
);
