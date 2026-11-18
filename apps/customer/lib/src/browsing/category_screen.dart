import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../media_image.dart';
import 'categories.dart';
import 'restaurant_list.dart';

/// CU §8.1 «التصنيفات»: the active categories in the panel's order, each
/// opening its page. Nothing while they load or when there is none; a failed
/// read offers a retry.
class CategoryRow extends ConsumerWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(categoriesProvider)) {
      AsyncData(:final value) when value.isNotEmpty => SingleChildScrollView(
        key: const Key('categories'),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final category in value)
              ActionChip(
                key: Key('category-${category.id}'),
                avatar: switch (category.imageKey) {
                  final key? => MediaImage(
                    imageKey: key,
                    width: 24,
                    height: 24,
                    label: category.name,
                  ),
                  null => null,
                },
                label: Text(category.name),
                onPressed: () => context.push('/categories/${category.id}'),
              ),
          ],
        ),
      ),
      AsyncError() => TextButton(
        onPressed: () => ref.invalidate(categoriesProvider),
        child: Text(l10n.customerTryAgain),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// CU §8.2: a category's page, every restaurant of that category that
/// delivers to the point, in the list's order (open first, closed last),
/// titled with its name once the categories are read.
class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref
        .watch(categoriesProvider)
        .value
        ?.where((category) => category.id == categoryId)
        .firstOrNull
        ?.name;
    return Scaffold(
      appBar: AppBar(title: Text(name ?? l10n.customerCategory)),
      body: RestaurantList(categoryId: categoryId),
    );
  }
}
