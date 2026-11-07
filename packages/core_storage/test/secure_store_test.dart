import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the memory store reads what it wrote until it is deleted', () async {
    final store = MemorySecureStore();
    expect(await store.read('token'), isNull);
    await store.write('token', 'a');
    expect(await store.read('token'), 'a');
    await store.delete('token');
    expect(await store.read('token'), isNull);
  });
}
