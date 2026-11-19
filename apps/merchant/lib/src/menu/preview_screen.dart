import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';
import 'texts.dart';

/// «معاينة كما يراها الزبون» (RA §9.7), the owners': the menu exactly as the
/// customer app shows it (hidden rows left out, unavailable items with their
/// reason, CU §9.3). Unstyled until the design.
class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final preview = ref.watch(customerPreviewProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantMenuCustomerPreview)),
      body: switch (preview) {
        AsyncData(:final value) when value.isEmpty => Center(
          child: Text(l10n.merchantMenuEmpty),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final category in value) ...[
              ListTile(
                key: Key('preview-category-${category.id}'),
                title: Text(category.name),
              ),
              for (final item in category.items)
                Opacity(
                  // CU §9.3: an unavailable item stays visible, faded.
                  opacity: item.available ? 1 : 0.5,
                  child: ListTile(
                    key: Key('preview-item-${item.id}'),
                    title: Text(item.name),
                    subtitle: Text(
                      [
                        ?item.description,
                        l10n.formatMoney(
                          item.price.amount,
                          item.price.currency,
                        ),
                        ?previewReasonText(l10n, item, category),
                      ].join(' · '),
                    ),
                  ),
                ),
            ],
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(customerPreviewProvider),
            child: Text('${l10n.merchantMenuFailed} ${l10n.merchantRetry}'),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
