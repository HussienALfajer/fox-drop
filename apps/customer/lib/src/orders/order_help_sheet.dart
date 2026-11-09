import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import 'cancel_order.dart';
import 'order_live.dart';

/// What the customer chose in «مساعدة» that leaves the sheet.
enum HelpChoice { faq, cancel }

/// «مساعدة» on an active order (CU §11.5): support by call or WhatsApp
/// (the numbers from Content; a missing one hides its button), the FAQ,
/// and «إلغاء الطلب» while placed or the explanation after acceptance
/// (§11.4). Answers the choice that leaves it, which the order screen
/// follows. Unstyled until the design.
Future<HelpChoice?> showOrderHelp(BuildContext context, CustomerOrder order) =>
    showModalBottomSheet<HelpChoice>(
      context: context,
      isScrollControlled: true,
      builder: (_) => OrderHelpSheet(order: order),
    );

class OrderHelpSheet extends ConsumerWidget {
  const OrderHelpSheet({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contact = ref.watch(customerAuth.contact).value;
    final launch = ref.read(customerAuth.launch);
    final phone = contact?.phone;
    final whatsapp = contact?.whatsapp;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (phone != null)
            ListTile(
              key: const Key('help-call'),
              title: Text(l10n.customerCallSupport),
              onTap: () => launch(Uri(scheme: 'tel', path: phone)),
            ),
          if (whatsapp != null)
            ListTile(
              key: const Key('help-whatsapp'),
              title: Text(l10n.customerWhatsappSupport),
              onTap: () => launch(
                Uri.https('wa.me', '/${whatsapp.substring(1)}', {
                  'text': l10n.customerWhatsappOrderMessage(order.number),
                }),
              ),
            ),
          ListTile(
            key: const Key('help-faq'),
            title: Text(l10n.faqTitle),
            onTap: () => Navigator.of(context).pop(HelpChoice.faq),
          ),
          ...switch (cancelHelpAt(order.status.name)) {
            CancelHelp.cancel => [
              ListTile(
                key: const Key('help-cancel'),
                title: Text(l10n.customerCancelOrder),
                onTap: () => Navigator.of(context).pop(HelpChoice.cancel),
              ),
            ],
            CancelHelp.viaSupport => [
              ListTile(
                key: const Key('help-cancel-via-support'),
                title: Text(l10n.customerCancelViaSupport),
                subtitle: Text(l10n.customerLateCancelWarning),
              ),
            ],
            CancelHelp.none => const <Widget>[],
          },
        ],
      ),
    );
  }
}
