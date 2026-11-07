import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

/// What the customer app reads from Content (`GET /v1/customer/content`, AP
/// §9.13): «الملاحظات الجاهزة» at checkout (CU §10.3) and the customer FAQ
/// set (CU §13). The other lists come with their screens.
class CustomerContent {
  const CustomerContent({required this.orderNotes, required this.faq});

  final List<String> orderNotes;
  final List<({String question, String answer})> faq;
}

/// Read once and kept; a failed read shows nothing at checkout and a retry
/// in the FAQ.
final contentProvider = FutureProvider<CustomerContent>((ref) async {
  final answer = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerContentGet();
  final body = answer.data!;
  return CustomerContent(
    orderNotes: [for (final note in body.reasons.orderNote) note.label],
    faq: [
      for (final item in body.faq)
        (question: item.question, answer: item.answer),
    ],
  );
});

/// CU §13 «المساعدة»: the customer FAQ set. Unstyled.
class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.faqTitle)),
      body: switch (ref.watch(contentProvider)) {
        AsyncData(:final value) when value.faq.isEmpty => Center(
          child: Text(l10n.faqEmpty),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final item in value.faq)
              ExpansionTile(
                title: Text(item.question),
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.all(16),
                    child: Text(item.answer),
                  ),
                ],
              ),
          ],
        ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(contentProvider),
            child: Text(l10n.contentFailed),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
