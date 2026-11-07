import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  test(
    'the preferences store reads what it wrote until it is deleted',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      final store = PreferencesDeviceStore();
      expect(await store.read('cart'), isNull);
      await store.write('cart', '{"lines":[]}');
      expect(await store.read('cart'), '{"lines":[]}');
      await store.delete('cart');
      expect(await store.read('cart'), isNull);
    },
  );
}
