import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../content.dart';
import '../work/work.dart';
import 'report_photo.dart';
import 'support.dart';

/// «إبلاغ عن مشكلة» (CA §13): a type of Content's captain_ticket_type list
/// (the requests «طلب تعديل بيانات», «إنهاء التعاقد» and «تبديل العدة»
/// among them, owner decision 2026-11-17), optionally the active order, a
/// note and a photo. Unstyled until the design.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key, this.type});

  /// A type chosen when the screen opens, such as «طلب تعديل بيانات»
  /// (`data_change`) from «ملفي»; one Content does not list is ignored.
  final String? type;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  late String? _type = widget.type;
  bool _aboutOrder = false;
  ReportPhoto? _photo;
  final _note = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  // A type whose text Content requires (AP §9.13) needs the note.
  bool _complete(List<ReasonChoice> types) =>
      types.any((t) => t.code == _type) &&
      (!types.any((t) => t.code == _type && t.needsNote) ||
          _note.text.trim().isNotEmpty);

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

  Future<void> _send(String? orderId) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    final note = _note.text.trim();
    final outcome = await ref
        .read(captainReportsProvider)
        .report(
          typeCode: _type!,
          orderId: _aboutOrder ? orderId : null,
          note: note.isEmpty ? null : note,
          photo: _photo,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    final messenger = ScaffoldMessenger.of(context);
    void say(String text) =>
        messenger.showSnackBar(SnackBar(content: Text(text)));
    switch (outcome) {
      case ReportSent(:final ticket):
        say(
          l10n.captainReportSent(
            ticket.number,
            l10n.formatReplyWithin(ticket.replyWithinMinutes),
          ),
        );
        context.pop();
      case ReportTypeChanged():
        setState(() => _type = null);
        say(l10n.captainReportTypeChanged);
      case ReportPhotoFailed():
        say(l10n.captainReportPhotoFailed);
      case ReportOrderGone():
        setState(() => _aboutOrder = false);
        say(l10n.captainReportOrderGone);
      default:
        say(l10n.captainReportFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(contentProvider);
    final order = ref.watch(workProvider).value?.value?.order;
    final types = content.value?.ticketTypes ?? const <ReasonChoice>[];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainReportProblem)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.captainReportType)),
          ...switch (content) {
            AsyncData() => [
              RadioGroup<String>(
                groupValue: _type,
                onChanged: (code) => setState(() => _type = code),
                child: Column(
                  children: [
                    for (final type in types)
                      RadioListTile<String>(
                        key: Key('type-${type.code}'),
                        value: type.code,
                        title: Text(type.label),
                      ),
                  ],
                ),
              ),
            ],
            AsyncError() => [
              ListTile(
                title: Text(l10n.captainReportTypesFailed),
                trailing: TextButton(
                  onPressed: () => ref.invalidate(contentProvider),
                  child: Text(l10n.captainReportsRetry),
                ),
              ),
            ],
            _ => [const LinearProgressIndicator()],
          },
          if (order != null)
            CheckboxListTile(
              key: const Key('report-about-order'),
              value: _aboutOrder,
              onChanged: (on) => setState(() => _aboutOrder = on ?? false),
              title: Text(l10n.captainReportAboutOrder(order.number)),
            ),
          TextField(
            key: const Key('report-note'),
            controller: _note,
            maxLength: 300,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.captainReportNote),
            onChanged: (_) => setState(() {}),
          ),
          if (_photo case final photo?)
            ListTile(
              key: const Key('report-photo'),
              leading: Image.memory(photo.photo.bytes, width: 56, height: 56),
              trailing: TextButton(
                key: const Key('report-photo-remove'),
                onPressed: () => setState(() => _photo = null),
                child: Text(l10n.photoRemove),
              ),
            )
          else
            Wrap(
              children: [
                if (cameraAvailable)
                  TextButton(
                    key: const Key('report-photo-camera'),
                    onPressed: () => _pick(PhotoSource.camera),
                    child: Text(l10n.photoCamera),
                  ),
                TextButton(
                  key: const Key('report-photo-gallery'),
                  onPressed: () => _pick(PhotoSource.gallery),
                  child: Text(l10n.photoGallery),
                ),
              ],
            ),
          FilledButton(
            key: const Key('report-send'),
            onPressed: _complete(types) && !_sending
                ? () => _send(order?.id)
                : null,
            child: Text(l10n.captainReportSend),
          ),
        ],
      ),
    );
  }
}
