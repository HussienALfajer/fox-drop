import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/api.dart';
import 'src/app.dart';

void main() {
  // A release build without API_BASE_URL stops here, before its first screen.
  apiBaseUrl();
  runApp(const ProviderScope(child: CustomerApp()));
}
