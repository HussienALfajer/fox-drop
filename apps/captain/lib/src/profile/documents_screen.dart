import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../joining/application_screen.dart';
import '../joining/texts.dart';
import 'profile.dart';

/// CA §12.2 «المستندات» (slice 2.35a): each document with its state and
/// expiry, a replacement waiting, and «رفع نسخة جديدة». Unstyled until the
/// design.
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final documents = ref.watch(captainDocumentsProvider);
    final controller = ref.read(captainDocumentsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainProfileDocuments)),
      body: switch (documents) {
        AsyncData(:final value) => ListView(
          children: [
            for (final banner in documentBanners(l10n, value))
              ListTile(key: const Key('document-banner'), title: Text(banner)),
            for (final document in value)
              ListTile(
                key: Key('document-${document.kind.wire}'),
                title: Text(documentText(l10n, document.kind)),
                subtitle: Text(
                  [
                    documentStateText(l10n, document),
                    if (document.expiresOn != null)
                      l10n.captainDocumentExpiresOn(
                        dayText(l10n, document.expiresOn!),
                      ),
                    if (!document.required) l10n.captainDocumentOptional,
                    if (document.pending)
                      l10n.captainDocumentReplacementPending,
                    if (document.rejection != null)
                      l10n.captainDocumentRejected(document.rejection!),
                  ].join(' · '),
                ),
                trailing: TextButton(
                  key: Key('document-replace-${document.kind.wire}'),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => DocumentSheet(
                      kind: document.kind,
                      save: controller.replace,
                    ),
                  ),
                  child: Text(l10n.captainDocumentUploadAgain),
                ),
              ),
          ],
        ),
        AsyncError() => Column(
          children: [
            Text(l10n.signInError),
            TextButton(
              onPressed: () => ref.invalidate(captainDocumentsProvider),
              child: Text(l10n.captainRetry),
            ),
          ],
        ),
        _ => const LinearProgressIndicator(),
      },
    );
  }
}
