import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../location/delivery_point.dart';

typedef MyCodes = CustomerCodesDtoOutput;
typedef MyCode = CustomerCodesDtoOutputCodesInner;

/// «أكوادي» (CU §12.4): the codes of the delivery point's city, «متاحة»
/// then «منتهية», as the server answers them. Read when the screen opens;
/// pulling reads again. Null before a point is known: the codes are a
/// city's, and the app knows no city.
final myCodesProvider = FutureProvider.autoDispose<MyCodes?>((ref) async {
  final point = ref.watch(
    deliveryPointProvider.select((p) => p is PointChecked ? p.point : null),
  );
  if (point == null) return null;
  final answer = await ref
      .read(coreApiProvider)
      .getCustomerApi()
      .customerCodesList(
        latitude: '${point.latitude}',
        longitude: '${point.longitude}',
      );
  return answer.data!;
});

/// «استخدم» (CU §12.4): the restaurant when the code is for one, home
/// otherwise.
String useCodePath(MyCode code) => code.restaurants.length == 1
    ? '/restaurants/${Uri.encodeComponent(code.restaurants.first!.id)}'
    : '/';
