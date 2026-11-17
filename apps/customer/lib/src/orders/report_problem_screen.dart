import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../content.dart';
import '../reports/photo_fields.dart';
import '../reports/report_photos.dart';
import 'order_live.dart';
import 'report_problem.dart';

/// «الإبلاغ عن مشكلة» on a delivered order (CU §12.2): the type from
/// Content, the order's lines with how many for the types that name them,
/// the note («أخرى» requires it) and up to 3 photos. Sending answers
/// «استلمنا بلاغك T-{رقم}…» and goes back to the order. Unstyled until the
/// design.
class ReportProblemScreen extends ConsumerStatefulWidget {
  const ReportProblemScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<ReportProblemScreen> createState() =>
      _ReportProblemScreenState();
}

class _ReportProblemScreenState extends ConsumerState<ReportProblemScreen> {
  String? _type;
  final _items = <int, int>{};
  final _note = TextEditingController();
  final _photos = <ReportPhoto>[];
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider(widget.orderId)).value?.value;
    final content = ref.watch(contentProvider);
    final types = content.value?.problemTypes ?? const <ReasonChoice>[];
    final chosen = types.where((t) => t.code == _type).firstOrNull;
    final namesItems = itemReportTypes.contains(_type);
    final note = _note.text.trim();
    final ready =
        chosen != null &&
        (!namesItems || _items.values.any((q) => q > 0)) &&
        (!chosen.needsNote || note.isNotEmpty);

    Future<void> send() async {
      setState(() => _sending = true);
      final outcome = await ref
          .read(reportProblemProvider(widget.orderId))
          .send(
            typeCode: chosen!.code,
            note: chosen.takesNote && note.isNotEmpty ? note : null,
            items: namesItems ? _items : const {},
            photos: _photos,
          );
      if (!mounted) return;
      setState(() => _sending = false);
      final messenger = ScaffoldMessenger.of(this.context);
      void say(String text) =>
          messenger.showSnackBar(SnackBar(content: Text(text)));
      switch (outcome) {
        case ReportSent(:final number):
          say(l10n.customerReportSent(number));
          this.context.pop();
        case ReportRefused(:final already):
          say(already ? l10n.customerReportAlready : l10n.customerReportClosed);
          this.context.pop();
        case ReportTypeChanged():
          setState(() => _type = null);
        case ReportPhotoFailed():
          say(l10n.customerReportPhotoFailed);
        case ReportFailed():
          say(l10n.customerTryAgain);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerReportProblem)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.customerReportType)),
          if (content.hasError)
            TextButton(
              onPressed: () => ref.invalidate(contentProvider),
              child: Text(l10n.customerTryAgain),
            ),
          RadioGroup<String>(
            groupValue: _type,
            onChanged: (value) => setState(() => _type = value),
            child: Column(
              children: [
                for (final type in types)
                  RadioListTile<String>(
                    key: Key('report-type-${type.code}'),
                    value: type.code,
                    title: Text(type.label),
                  ),
              ],
            ),
          ),
          if (namesItems && order != null) ...[
            ListTile(title: Text(l10n.customerReportItems)),
            for (final line in order.lines)
              ListTile(
                key: Key('report-line-${line.position}'),
                title: Text(line.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: Key('report-line-less-${line.position}'),
                      onPressed: (_items[line.position] ?? 0) > 0
                          ? () => setState(
                              () => _items[line.position] =
                                  _items[line.position]! - 1,
                            )
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${_items[line.position] ?? 0}'),
                    IconButton(
                      key: Key('report-line-more-${line.position}'),
                      onPressed: (_items[line.position] ?? 0) < line.quantity
                          ? () => setState(
                              () => _items[line.position] =
                                  (_items[line.position] ?? 0) + 1,
                            )
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
          ],
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: TextField(
              key: const Key('report-note'),
              controller: _note,
              maxLength: 300,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: chosen?.needsNote ?? false
                    ? l10n.customerReportNoteRequired
                    : l10n.customerReportNote,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          ListTile(title: Text(l10n.customerReportPhotos)),
          PhotoFields(
            photos: _photos,
            max: maxReportPhotos,
            onChanged: () => setState(() {}),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: FilledButton(
              key: const Key('report-send'),
              onPressed: ready && !_sending ? send : null,
              child: Text(l10n.customerReportSend),
            ),
          ),
        ],
      ),
    );
  }
}
