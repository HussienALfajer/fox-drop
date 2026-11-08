import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

typedef CustomerNotification = CustomerNotificationsDtoOutputNotificationsInner;

/// «الإشعارات» (CU §13): every push the account received in the last 30
/// days, newest first, as the server answers them. Read when the screen
/// opens; pulling reads again.
final notificationsProvider =
    FutureProvider.autoDispose<List<CustomerNotification>>((ref) async {
      final answer = await ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerNotificationsList();
      return answer.data!.notifications.toList();
    });
