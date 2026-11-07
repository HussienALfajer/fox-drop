import 'package:core_auth/core_auth.dart';

import 'api.dart';

/// The customer's sign-in and session (CU §5.2–5.4). Guests browse without
/// one (CU §5.1); there is no operations code for customers (architecture
/// §8.3.5).
final customerAuth = AuthScope(
  party: (ref) => CustomerAuth(ref.watch(authApiProvider)),
);
