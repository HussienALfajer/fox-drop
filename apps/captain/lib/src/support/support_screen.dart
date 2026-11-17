import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth.dart';
import 'support.dart';

/// «الدعم» (CA §13): the call and WhatsApp to operations (the numbers from
/// Content; a missing one hides its button), «إبلاغ عن مشكلة», «بلاغاتي»
/// and the FAQ. «الرسائل» and the appeals come with their slices (owner
/// decision 2026-11-17). Unstyled until the design.
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reports = ref.watch(myReportsProvider);
    final contact = ref.watch(captainAuth.contact).value;
    final launch = ref.read(captainAuth.launch);
    final phone = contact?.phone;
    final whatsapp = contact?.whatsapp;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainSupport)),
      body: ListView(
        children: [
          if (phone != null)
            ListTile(
              key: const Key('call-operations'),
              title: Text(l10n.signInCallOperations),
              onTap: () => launch(Uri(scheme: 'tel', path: phone)),
            ),
          if (whatsapp != null)
            ListTile(
              key: const Key('whatsapp-operations'),
              title: Text(l10n.signInWhatsappOperations),
              onTap: () => launch(
                Uri.https(
                  'wa.me',
                  '/${whatsapp.replaceAll(RegExp(r'\D'), '')}',
                ),
              ),
            ),
          ListTile(
            key: const Key('report-problem'),
            title: Text(l10n.captainReportProblem),
            onTap: () => context.push('/support/report'),
          ),
          ListTile(
            key: const Key('faq'),
            title: Text(l10n.faqTitle),
            onTap: () => context.push('/faq'),
          ),
          ListTile(title: Text(l10n.captainMyReports)),
          ...switch (reports) {
            AsyncData(:final value) when value.isEmpty => [
              ListTile(title: Text(l10n.captainMyReportsEmpty)),
            ],
            AsyncData(:final value) => [
              for (final ticket in value) _TicketTile(ticket: ticket),
            ],
            AsyncError() => [
              ListTile(
                title: Text(l10n.captainReportsFailed),
                trailing: TextButton(
                  key: const Key('reports-retry'),
                  onPressed: () => ref.invalidate(myReportsProvider),
                  child: Text(l10n.captainReportsRetry),
                ),
              ),
            ],
            _ => [const LinearProgressIndicator()],
          },
        ],
      ),
    );
  }
}

/// A ticket of «بلاغاتي»: its number and type, the order, the note, its
/// status, who opened it when operations did, and the resolution message.
class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket});

  final CaptainTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lines = [
      if (ticket.orderNumber case final number?)
        l10n.captainReportOrderLine(number),
      if (ticket.description.isNotEmpty) ticket.description,
      if (ticket.openedBy ==
          CaptainReportTicketDtoOutputTicketOpenedByEnum.operations)
        l10n.captainReportByOperations,
      if (ticket.message case final message?) l10n.captainReportReply(message),
    ];
    return ListTile(
      key: Key('ticket-${ticket.id}'),
      title: Text(l10n.captainReportTitle(ticket.number, ticket.typeLabel)),
      subtitle: lines.isEmpty ? null : Text(lines.join('\n')),
      trailing: Text(l10n.ticketStatusText(ticket.status)),
    );
  }
}
