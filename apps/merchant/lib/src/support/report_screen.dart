import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../board/board.dart';
import '../content.dart';
import 'report_photo.dart';
import 'support.dart';

/// «إبلاغ عن مشكلة» (RA §15): a type of Content's list, optionally an order
/// of the board, a data change's subject (owner decision 2026-11-17), a note
/// and a photo. Unstyled until the design.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  String? _type;
  String? _orderId;
  DataChangeSubject? _subject;
  ReportPhoto? _photo;
  final _note = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _complete =>
      _type != null && (_type != dataChangeType || _subject != null);

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
    final note = _note.text.trim();
    final outcome = await ref
        .read(merchantReportsProvider)
        .report(
          typeCode: _type!,
          orderId: _orderId,
          subject: _type == dataChangeType ? _subject : null,
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
          l10n.merchantReportSent(
            ticket.number,
            l10n.formatReplyWithin(ticket.replyWithinMinutes),
          ),
        );
        context.pop();
      case ReportTypeChanged():
        setState(() => _type = null);
        say(l10n.merchantReportTypeChanged);
      case ReportPhotoFailed():
        say(l10n.merchantReportPhotoFailed);
      case ReportOrderGone():
        setState(() => _orderId = null);
        say(l10n.merchantReportOrderGone);
      case ReportFailed():
        say(l10n.merchantReportFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final types = ref.watch(ticketTypesProvider);
    final orders = [...?ref.watch(boardProvider).value?.value?.orders];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantReportProblem)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.merchantReportType)),
          ...switch (types) {
            AsyncData(:final value) => [
              RadioGroup<String>(
                groupValue: _type,
                onChanged: (code) => setState(() => _type = code),
                child: Column(
                  children: [
                    for (final type in value)
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
                title: Text(l10n.merchantReportTypesFailed),
                trailing: TextButton(
                  onPressed: () => ref.invalidate(merchantContentProvider),
                  child: Text(l10n.merchantReportsRetry),
                ),
              ),
            ],
            _ => [const LinearProgressIndicator()],
          },
          if (_type == dataChangeType) ...[
            ListTile(title: Text(l10n.merchantReportSubject)),
            RadioGroup<DataChangeSubject>(
              groupValue: _subject,
              onChanged: (subject) => setState(() => _subject = subject),
              child: Column(
                children: [
                  for (final subject in DataChangeSubject.values)
                    RadioListTile<DataChangeSubject>(
                      key: Key('subject-${subject.name}'),
                      value: subject,
                      title: Text(l10n.subjectText(subject)),
                    ),
                ],
              ),
            ),
          ],
          if (orders.isNotEmpty) ...[
            ListTile(title: Text(l10n.merchantReportOrder)),
            RadioGroup<String?>(
              groupValue: _orderId,
              onChanged: (id) => setState(() => _orderId = id),
              child: Column(
                children: [
                  RadioListTile<String?>(
                    key: const Key('order-none'),
                    value: null,
                    title: Text(l10n.merchantReportNoOrder),
                  ),
                  for (final order in orders)
                    RadioListTile<String?>(
                      key: Key('order-${order.id}'),
                      value: order.id,
                      title: Text(l10n.merchantReportOrderLine(order.number)),
                    ),
                ],
              ),
            ),
          ],
          TextField(
            key: const Key('report-note'),
            controller: _note,
            maxLength: 300,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.merchantReportNote),
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
            onPressed: _complete && !_sending ? _send : null,
            child: Text(l10n.merchantReportSend),
          ),
        ],
      ),
    );
  }
}
