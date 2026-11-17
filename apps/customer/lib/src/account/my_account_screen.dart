import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import '../auth.dart';
import '../device.dart';

/// The captain app's store page, which «انضم ككابتن» opens (CU §13).
final captainStorePage = Uri.https('play.google.com', '/store/apps/details', {
  'id': 'com.foxdrop.captain',
});

/// «تسجيل الخروج من كل الأجهزة» (CU §13, §5.4): every session of the account
/// ends on the server, this one included, then this device signs out. A
/// failed call leaves the customer signed in, to try again.
class SignOutEverywhere extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> run() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(coreApiProvider)
          .getCustomerApi()
          .customerAuthSignOutEverywhere();
      await ref
          .read(customerAuth.session.notifier)
          .end(SessionEndReason.signedOut);
    });
  }
}

final signOutEverywhereProvider =
    AsyncNotifierProvider.autoDispose<SignOutEverywhere, void>(
      SignOutEverywhere.new,
    );

/// «حسابي» (CU §13): the details, «أكوادي», «الإشعارات», the help, joining
/// us, the terms, the version and signing out. «عناويني» and «المفضلة» join
/// with their slices (2.29, 2.28), «حذف الحساب» with 2.25c (owner decision
/// 2026-11-17). Unstyled until the design.
class MyAccountScreen extends ConsumerWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contact = ref.watch(customerAuth.contact).value;
    final launch = ref.read(customerAuth.launch);
    final signingOut = ref.watch(signOutEverywhereProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerMyAccountTitle)),
      body: ListView(
        children: [
          ListTile(
            key: const Key('open-profile'),
            title: Text(l10n.customerAccountProfile),
            onTap: () => context.push('/account/profile'),
          ),
          ListTile(
            key: const Key('open-codes'),
            title: Text(l10n.customerMyCodesTitle),
            onTap: () => context.push('/codes'),
          ),
          ListTile(
            key: const Key('open-notifications'),
            title: Text(l10n.customerNotificationsTitle),
            onTap: () => context.push('/notifications'),
          ),
          ListTile(title: Text(l10n.customerAccountHelp)),
          ListTile(
            title: Text(l10n.faqTitle),
            onTap: () => context.push('/faq'),
          ),
          if (contact?.whatsapp case final whatsapp?)
            ListTile(
              title: Text(l10n.customerWhatsappSupport),
              onTap: () =>
                  launch(Uri.https('wa.me', '/${whatsapp.substring(1)}')),
            ),
          if (contact?.phone case final phone?)
            ListTile(
              title: Text(l10n.customerCallSupport),
              onTap: () => launch(Uri(scheme: 'tel', path: phone)),
            ),
          ListTile(title: Text(l10n.customerJoinUs)),
          ListTile(
            key: const Key('join-as-captain'),
            title: Text(l10n.customerJoinAsCaptain),
            onTap: () => launch(captainStorePage),
          ),
          if (contact?.whatsapp case final whatsapp?)
            ListTile(
              key: const Key('add-restaurant'),
              title: Text(l10n.customerAddRestaurant),
              onTap: () => launch(
                Uri.https('wa.me', '/${whatsapp.substring(1)}', {
                  'text': l10n.customerAddRestaurantMessage,
                }),
              ),
            ),
          ListTile(
            title: Text(l10n.customerTermsAndPrivacy),
            onTap: () => context.push('/terms'),
          ),
          ListTile(
            title: Text(l10n.customerAbout),
            subtitle: Text(l10n.customerAppVersion(appVersion)),
          ),
          ListTile(
            key: const Key('sign-out'),
            title: Text(l10n.signOut),
            onTap: () async {
              await ref.read(customerAuth.session.notifier).signOut();
              if (context.mounted) context.go('/');
            },
          ),
          ListTile(
            key: const Key('sign-out-everywhere'),
            title: Text(l10n.customerSignOutEverywhere),
            enabled: !signingOut.isLoading,
            onTap: () => _confirmSignOutEverywhere(context, ref),
          ),
          if (signingOut.hasError) Text(l10n.customerSignOutEverywhereFailed),
        ],
      ),
    );
  }

  Future<void> _confirmSignOutEverywhere(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.customerSignOutEverywhereConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.customerCancel),
          ),
          TextButton(
            key: const Key('confirm-sign-out-everywhere'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.customerSignOutEverywhere),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(signOutEverywhereProvider.notifier).run();
    // Home as a guest; a failed call stays here with its message.
    if (context.mounted && !ref.read(signOutEverywhereProvider).hasError) {
      context.go('/');
    }
  }
}
