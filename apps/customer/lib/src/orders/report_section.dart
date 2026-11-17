import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import '../auth.dart';
import 'order_live.dart';
import 'report_problem.dart';

/// The order's report (CU §12.2, §12.3): «بلاغك T-{رقم}: {الحالة}» with the
/// resolution message once sent; «الإبلاغ عن مشكلة» within its window; else,
/// once the order ended, «تواصل مع الدعم» by call and WhatsApp; and the
/// links to the free re-deliveries placed for it. Unstyled until the design.
class ReportSection extends ConsumerWidget {
  const ReportSection({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(serverClockProvider).now();
    final report = order.report;
    final offer = reportOfferOf(order, now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final redelivery in order.redeliveries)
          ListTile(
            key: Key('redelivery-${redelivery.orderId}'),
            title: Text(l10n.customerRedeliveryOrder(redelivery.number)),
            onTap: () => context.push('/orders/${redelivery.orderId}'),
          ),
        if (offer == ReportOffer.status && report != null)
          ListTile(
            key: const Key('order-report'),
            title: Text(
              l10n.customerReportStatus(
                report.number,
                ticketStatusText(l10n, report.status),
              ),
            ),
            subtitle: report.message == null ? null : Text(report.message!),
          ),
        if (offer == ReportOffer.report)
          TextButton(
            key: const Key('order-report-problem'),
            onPressed: () => context.push('/orders/${order.id}/report'),
            child: Text(l10n.customerReportProblem),
          ),
        if (offer == ReportOffer.contactSupport) ...[
          ListTile(
            key: const Key('order-contact-support'),
            title: Text(l10n.customerContactSupport),
          ),
          ..._contact(context, ref, l10n),
        ],
      ],
    );
  }

  List<Widget> _contact(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final contact = ref.watch(customerAuth.contact).value;
    final launch = ref.read(customerAuth.launch);
    return [
      if (contact?.phone case final phone?)
        TextButton(
          key: const Key('order-support-call'),
          onPressed: () => launch(Uri(scheme: 'tel', path: phone)),
          child: Text(l10n.customerCallSupport),
        ),
      if (contact?.whatsapp case final whatsapp?)
        TextButton(
          key: const Key('order-support-whatsapp'),
          onPressed: () => launch(
            Uri.https('wa.me', '/${whatsapp.substring(1)}', {
              'text': l10n.customerWhatsappOrderMessage(order.number),
            }),
          ),
          child: Text(l10n.customerWhatsappSupport),
        ),
    ];
  }
}

/// AP Appendix C: a ticket's status as the customer reads it.
String ticketStatusText(
  AppLocalizations l10n,
  CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum status,
) => switch (status.name) {
  'new_' || 'new' => l10n.ticketNew,
  'inProgress' => l10n.ticketInProgress,
  'waiting' => l10n.ticketWaiting,
  'resolved' => l10n.ticketResolved,
  _ => l10n.ticketClosed,
};
