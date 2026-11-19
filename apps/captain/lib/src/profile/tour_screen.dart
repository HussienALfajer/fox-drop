import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import '../settings/settings_screen.dart';
import 'profile.dart';

/// CA §5.5 (slice 2.35a): after the activation, a short tour (going online,
/// an offer, an order, custody, earnings), then «أقصى مبلغ أحمله» and
/// «العملات التي أحملها» (the settings' own forms). Shown once on this
/// device. Unstyled until the design.
class TourScreen extends ConsumerStatefulWidget {
  const TourScreen({super.key});

  @override
  ConsumerState<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends ConsumerState<TourScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      l10n.captainTourOnline,
      l10n.captainTourOffer,
      l10n.captainTourOrder,
      l10n.captainTourCustody,
      l10n.captainTourEarnings,
    ];
    if (_page >= pages.length) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.captainTourTitle)),
        body: Column(
          children: [
            Expanded(child: SettingsBody(header: l10n.captainTourSettings)),
            FilledButton(
              key: const Key('tour-done'),
              onPressed: () async {
                final captainId = ref
                    .read(captainSessionProvider)
                    .value
                    ?.captainId;
                if (captainId != null) {
                  await markTourSeen(ref.read(deviceStoreProvider), captainId);
                  ref.invalidate(tourSeenProvider(captainId));
                }
                if (context.mounted) context.go('/');
              },
              child: Text(l10n.captainTourDone),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainTourTitle)),
      body: Column(
        children: [
          Expanded(child: Center(child: Text(pages[_page]))),
          FilledButton(
            key: const Key('tour-next'),
            onPressed: () => setState(() => _page += 1),
            child: Text(l10n.captainTourNext),
          ),
        ],
      ),
    );
  }
}
