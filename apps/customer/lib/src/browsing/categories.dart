import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../location/delivery_point.dart';
import 'browse_cache.dart';

typedef Category = CustomerCategoriesDtoOutputCategoriesInner;

/// The active categories in the panel's order (AP §9.13, CU §8.1), public
/// like the list. A failed read is read again with `ref.invalidate`. CU
/// §4.5: the last good read is kept for every account and point, shown
/// first and offline (`browse_cache.dart`).
final categoriesProvider = StreamProvider.autoDispose<List<Category>>((
  ref,
) async* {
  final api = ref.watch(coreApiProvider).getCustomerApi();
  // After a failed zone check only the kept read is shown, as home's.
  final offline = ref.watch(
    deliveryPointProvider.select(
      (point) => point is PointUnavailable && point.failure == null,
    ),
  );
  final answers = browse<CustomerCategoriesDtoOutput>(
    ref,
    key: browseCategoriesKey,
    accountId: null,
    point: null,
    offline: offline,
    read: () async => (await api.customerCategoriesList()).data!,
    encode: (body) => standardSerializers.serializeWith(
      CustomerCategoriesDtoOutput.serializer,
      body,
    ),
    decode: (json) => standardSerializers.deserializeWith(
      CustomerCategoriesDtoOutput.serializer,
      json,
    )!,
    seen: (_, _) {},
  );
  await for (final answer in answers) {
    yield answer.body.categories.toList();
  }
});
