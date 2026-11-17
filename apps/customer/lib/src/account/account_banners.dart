import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import 'account_state.dart';

/// CU §5.5 (slice 2.25a): home's banners of the account's state, the block
/// first, then the dues with the office's sheet, then the review stop; the
/// block and the review stop with call and WhatsApp. Read again when the app
/// returns to the foreground. Unstyled until the design.
class AccountStateBanners extends ConsumerStatefulWidget {
  const AccountStateBanners({super.key});

  @override
  ConsumerState<AccountStateBanners> createState() =>
      _AccountStateBannersState();
}

class _AccountStateBannersState extends ConsumerState<AccountStateBanners> {
  late final _lifecycle = AppLifecycleListener(
    onResume: () => ref.invalidate(accountStateProvider),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountStateProvider).value;
    if (state == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.block case final block?) ...[
          ListTile(
            key: const Key('account-blocked'),
            title: Text(blockText(l10n, block.until, block.reason)),
          ),
          const _ContactSupport(),
        ],
        if (state.dues case final dues?) ...[
          ListTile(
            key: const Key('account-dues'),
            title: Text(
              l10n.customerDuesUnpaid(
                l10n.formatMoney(dues.amount, dues.currency),
              ),
            ),
          ),
          TextButton(
            key: const Key('account-office'),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              builder: (_) => OfficeSheet(office: state.office),
            ),
            child: Text(l10n.customerOfficeShow),
          ),
        ],
        if (state.reviewStop) ...[
          ListTile(
            key: const Key('account-review-stop'),
            title: Text(l10n.customerReviewStop),
          ),
          const _ContactSupport(),
        ],
      ],
    );
  }
}

class _ContactSupport extends ConsumerWidget {
  const _ContactSupport();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contact = ref.watch(customerAuth.contact).value;
    final launch = ref.read(customerAuth.launch);
    return Wrap(
      children: [
        if (contact?.phone case final phone?)
          TextButton(
            onPressed: () => launch(Uri(scheme: 'tel', path: phone)),
            child: Text(l10n.customerCallSupport),
          ),
        if (contact?.whatsapp case final whatsapp?)
          TextButton(
            onPressed: () =>
                launch(Uri.https('wa.me', '/${whatsapp.substring(1)}')),
            child: Text(l10n.customerWhatsappSupport),
          ),
      ],
    );
  }
}

/// CU §5.5, AP §9.12.1: where the office is and its hours, from the dues
/// banner.
class OfficeSheet extends ConsumerWidget {
  const OfficeSheet({super.key, required this.office});

  final Office? office;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final office = this.office;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(l10n.customerOfficeTitle),
          if (office == null)
            Text(l10n.customerOfficeUnset)
          else ...[
            Text(l10n.officeNowText(office), key: const Key('office-now')),
            for (final weekday in officeWeek)
              Text(l10n.officeDayText(office, weekday)),
            TextButton(
              key: const Key('office-map'),
              onPressed: () => ref.read(customerAuth.launch)(
                officeMapUri(office.latitude, office.longitude),
              ),
              child: Text(l10n.customerOfficeMap),
            ),
          ],
        ],
      ),
    );
  }
}
