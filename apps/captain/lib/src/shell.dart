import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'work/work.dart';

/// The bottom navigation's tabs (CA §6.2), in order.
const captainTabs = ['/', '/earnings', '/custody', '/more'];

/// CA §6.2: the bottom navigation «الرئيسية» · «أرباحي» · «عهدتي» ·
/// «المزيد» around every tab, under `WorkLayer`, so an offer rings and
/// shows, and the cards and alerts come, whichever tab is open; while an
/// order is active, a bar on the other tabs returns to it.
class CaptainShell extends ConsumerWidget {
  const CaptainShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final live = ref.watch(workProvider).value;
    final index = captainTabs.indexOf(location);
    final ordering = live?.value?.order != null && location != '/';
    // The tabs other than home go back home, as «عهدتي» did when pushed.
    return PopScope(
      canPop: location == '/',
      onPopInvokedWithResult: (popped, _) {
        if (!popped) context.go('/');
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: WorkLayer(
            live: live,
            child: Column(
              children: [
                if (ordering)
                  ListTile(
                    key: const Key('active-order-bar'),
                    title: Text(l10n.captainActiveOrderBar),
                    onTap: () => context.go('/'),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index < 0 ? 0 : index,
          onDestinationSelected: (tab) => context.go(captainTabs[tab]),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              label: l10n.captainHomeTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.payments_outlined),
              label: l10n.captainEarningsTitle,
            ),
            NavigationDestination(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: l10n.captainCustodyTitle,
            ),
            NavigationDestination(
              icon: const Icon(Icons.more_horiz),
              label: l10n.captainMoreTab,
            ),
          ],
        ),
      ),
    );
  }
}

/// CA §6.2 «المزيد»: the other screens. For now the settings, the work
/// rules and the FAQ; the performance, profile, history and support screens
/// join with their slices.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainMoreTab)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.captainSettings),
            onTap: () => context.push('/settings'),
          ),
          // CA §11.4: the work rules always one tap away; CA §13: the FAQ.
          ListTile(
            title: Text(l10n.captainWorkRules),
            onTap: () => context.push('/work-rules'),
          ),
          ListTile(
            title: Text(l10n.faqTitle),
            onTap: () => context.push('/faq'),
          ),
        ],
      ),
    );
  }
}
