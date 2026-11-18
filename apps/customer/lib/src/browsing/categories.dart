import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';

/// The active categories in the panel's order (AP §9.13, CU §8.1), public
/// like the list. A failed read is read again with `ref.invalidate`.
final categoriesProvider =
    FutureProvider.autoDispose<
      List<CustomerCategoriesDtoOutputCategoriesInner>
    >((ref) async {
      final response = await ref
          .watch(coreApiProvider)
          .getCustomerApi()
          .customerCategoriesList();
      return response.data!.categories.toList();
    });
