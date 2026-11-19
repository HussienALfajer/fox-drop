import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../support/report_photo.dart';
import '../support/support.dart';

/// CA §11.3 «اعتراض» (slice 2.36b): the captain's text and an optional
/// photo on one violation, which opens a ticket for the supervisor; its
/// status and the decision show in «بلاغاتي». Unstyled until the design.
class AppealScreen extends ConsumerStatefulWidget {
  const AppealScreen({required this.violationId, super.key});

  final String violationId;

  @override
  ConsumerState<AppealScreen> createState() => _AppealScreenState();
}

class _AppealScreenState extends ConsumerState<AppealScreen> {
  final _text = TextEditingController();
  ReportPhoto? _photo;
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _pick(PhotoSource source) async {
    final l10n = AppLocalizations.of(context);
    final photo = await ref.read(photoPickerProvider)(source);
    if (photo == null || !mounted) return;
    if (photo.bytes.length > maxPhotoBytes) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.photoTooLarge)));
      return;
    }
    setState(() => _photo = ReportPhoto(photo));
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    final outcome = await ref
        .read(captainReportsProvider)
        .appeal(
          violationId: widget.violationId,
          text: _text.text.trim(),
          photo: _photo,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    final messenger = ScaffoldMessenger.of(context);
    void say(String text) =>
        messenger.showSnackBar(SnackBar(content: Text(text)));
    switch (outcome) {
      case ReportSent(:final ticket):
        say(l10n.captainAppealSent(ticket.number));
        context.pop();
      case AppealAlreadySent():
        say(l10n.captainAppealAlready);
        context.pop();
      case ReportPhotoFailed():
        say(l10n.captainReportPhotoFailed);
      default:
        say(l10n.captainReportFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainAppeal)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          TextField(
            key: const Key('appeal-text'),
            controller: _text,
            maxLength: 300,
            maxLines: 4,
            decoration: InputDecoration(labelText: l10n.captainAppealText),
            onChanged: (_) => setState(() {}),
          ),
          if (_photo case final photo?)
            ListTile(
              key: const Key('appeal-photo'),
              leading: Image.memory(photo.photo.bytes, width: 56, height: 56),
              trailing: TextButton(
                onPressed: () => setState(() => _photo = null),
                child: Text(l10n.photoRemove),
              ),
            )
          else
            Wrap(
              children: [
                if (cameraAvailable)
                  TextButton(
                    onPressed: () => _pick(PhotoSource.camera),
                    child: Text(l10n.photoCamera),
                  ),
                TextButton(
                  key: const Key('appeal-photo-gallery'),
                  onPressed: () => _pick(PhotoSource.gallery),
                  child: Text(l10n.photoGallery),
                ),
              ],
            ),
          FilledButton(
            key: const Key('appeal-send'),
            onPressed: _text.text.trim().isNotEmpty && !_sending ? _send : null,
            child: Text(l10n.captainAppealSend),
          ),
        ],
      ),
    );
  }
}
