import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

/// A reason of a Content list (AP §9.13): the code goes back to the server,
/// the label is shown, and «أخرى» needs its text.
class ReasonChoice {
  const ReasonChoice(this.code, this.label, {this.needsText = false});

  final String code;
  final String label;
  final bool needsText;
}

/// What the captain app reads from Content (`GET /v1/captain/content`): the
/// reason lists it picks from, the captain FAQ set and the work rules page
/// (CA §11.4, §13).
class CaptainContent {
  const CaptainContent({
    required this.away,
    required this.shortfall,
    required this.faq,
    required this.workRules,
  });

  /// Arrival or delivery away from the pin (C9, K4).
  final List<ReasonChoice> away;

  /// Collected less than due (K16).
  final List<ReasonChoice> shortfall;
  final List<({String question, String answer})> faq;

  /// One rule per line.
  final String workRules;
}

List<ReasonChoice> _choices(
  Iterable<MerchantContentDtoOutputReasonsMerchantRejectionInner> list,
) => [
  for (final reason in list)
    ReasonChoice(reason.code, reason.label, needsText: reason.needsText),
];

/// Read once and kept; a failed read is read again by the next screen that
/// needs it (`ref.invalidate`).
final contentProvider = FutureProvider<CaptainContent>((ref) async {
  final answer = await ref
      .watch(coreApiProvider)
      .getCaptainApi()
      .captainContentGet();
  final body = answer.data!;
  return CaptainContent(
    away: _choices(body.reasons.captainAway),
    shortfall: _choices(body.reasons.shortfall),
    faq: [
      for (final item in body.faq)
        (question: item.question, answer: item.answer),
    ],
    workRules: body.workRules,
  );
});

/// The content, or null after a failed read, which shows «تعذّر التحميل»
/// and is read again next time.
Future<CaptainContent?> readContent(BuildContext context, WidgetRef ref) async {
  try {
    return await ref.read(contentProvider.future);
  } catch (_) {
    ref.invalidate(contentProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).contentFailed)),
      );
    }
    return null;
  }
}

/// CA §11.4: the work rules page, always one tap away. Unstyled.
class WorkRulesScreen extends ConsumerWidget {
  const WorkRulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainWorkRules)),
      body: _ContentBody(
        builder: (content) => ListView(
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            for (final line in content.workRules.split('\n'))
              if (line.trim().isNotEmpty) Text(line),
          ],
        ),
      ),
    );
  }
}

/// CA §13: the captain FAQ set. Unstyled.
class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.faqTitle)),
      body: _ContentBody(
        builder: (content) => content.faq.isEmpty
            ? Center(child: Text(l10n.faqEmpty))
            : ListView(
                children: [
                  for (final item in content.faq)
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
      ),
    );
  }
}

class _ContentBody extends ConsumerWidget {
  const _ContentBody({required this.builder});

  final Widget Function(CaptainContent content) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(contentProvider)) {
      AsyncData(:final value) => builder(value),
      AsyncError() => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(contentProvider),
          child: Text(l10n.contentFailed),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
