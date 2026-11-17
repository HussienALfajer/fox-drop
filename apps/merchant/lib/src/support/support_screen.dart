import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth.dart';
import 'support.dart';

/// «الدعم» (RA §15): the call and WhatsApp to operations (the numbers from
/// Content; a missing one hides its button), «إبلاغ عن مشكلة», «بلاغاتي»
/// and the FAQ. Unstyled until the design.
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reports = ref.watch(myReportsProvider);
    final faq = ref.watch(merchantFaqProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantSupport)),
      body: ListView(
        children: [
          ...contactTiles(context, ref, null),
          ListTile(
            key: const Key('report-problem'),
            title: Text(l10n.merchantReportProblem),
            onTap: () => context.push('/support/report'),
          ),
          ListTile(title: Text(l10n.merchantMyReports)),
          ...switch (reports) {
            AsyncData(:final value) when value.isEmpty => [
              ListTile(title: Text(l10n.merchantMyReportsEmpty)),
            ],
            AsyncData(:final value) => [
              for (final ticket in value) _TicketTile(ticket: ticket),
            ],
            AsyncError() => [
              ListTile(
                title: Text(l10n.merchantReportsFailed),
                trailing: TextButton(
                  key: const Key('reports-retry'),
                  onPressed: () => ref.invalidate(myReportsProvider),
                  child: Text(l10n.merchantReportsRetry),
                ),
              ),
            ],
            _ => [const LinearProgressIndicator()],
          },
          if (faq.isNotEmpty) ListTile(title: Text(l10n.faqTitle)),
          for (final item in faq)
            ExpansionTile(
              title: Text(item.question),
              children: [ListTile(title: Text(item.answer))],
            ),
        ],
      ),
    );
  }
}

/// «اتصال بالعمليات» and «واتساب العمليات» (RA §15, §8.19); on an order the
/// WhatsApp text names it.
List<Widget> contactTiles(
  BuildContext context,
  WidgetRef ref,
  String? orderNumber,
) {
  final l10n = AppLocalizations.of(context);
  final contact = ref.watch(merchantAuth.contact).value;
  final launch = ref.read(merchantAuth.launch);
  final phone = contact?.phone;
  final whatsapp = contact?.whatsapp;
  return [
    if (phone != null)
      ListTile(
        key: const Key('call-operations'),
        title: Text(l10n.merchantCallOperations),
        onTap: () => launch(Uri(scheme: 'tel', path: phone)),
      ),
    if (whatsapp != null)
      ListTile(
        key: const Key('whatsapp-operations'),
        title: Text(l10n.merchantWhatsappOperations),
        onTap: () => launch(
          Uri.https('wa.me', '/${whatsapp.substring(1)}', {
            if (orderNumber != null)
              'text': l10n.merchantWhatsappOrderMessage(orderNumber),
          }),
        ),
      ),
  ];
}

/// A ticket of «بلاغاتي»: its number and type, the subject, the order, the
/// note, its status, and the resolution message once resolved; an owner
/// sees which ones another user opened.
class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket});

  final MerchantTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subject = l10n.ticketSubjectText(ticket.subject);
    final lines = [
      ?subject,
      if (ticket.orderNumber case final number?)
        l10n.merchantReportOrderLine(number),
      if (ticket.description.isNotEmpty) ticket.description,
      if (!ticket.openedByMe) l10n.merchantReportBy,
      if (ticket.message case final message?) l10n.merchantReportReply(message),
    ];
    return ListTile(
      key: Key('ticket-${ticket.id}'),
      title: Text(l10n.merchantReportTitle(ticket.number, ticket.typeLabel)),
      subtitle: lines.isEmpty ? null : Text(lines.join('\n')),
      trailing: Text(l10n.ticketStatusText(ticket.status)),
    );
  }
}
