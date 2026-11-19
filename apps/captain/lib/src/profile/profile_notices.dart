import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import 'profile.dart';

/// On home (slice 2.35a): the amber banner of a document expiring or expired
/// (CA §12.2), which opens «المستندات», and, the first time after the
/// activation, the welcome tour (CA §5.5). A failed read shows nothing.
class ProfileNotices extends ConsumerStatefulWidget {
  const ProfileNotices({super.key});

  @override
  ConsumerState<ProfileNotices> createState() => _ProfileNoticesState();
}

class _ProfileNoticesState extends ConsumerState<ProfileNotices> {
  bool _toured = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final captainId = ref.watch(captainSessionProvider).value?.captainId;
    if (captainId != null && !_toured) {
      final contract = ref.watch(contractProvider).value;
      final seen = ref.watch(tourSeenProvider(captainId)).value;
      if (contract?.contract != null && seen == false) {
        _toured = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.push('/tour');
        });
      }
    }
    final documents = ref.watch(captainDocumentsProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final banner in documentBanners(l10n, documents))
          TextButton(
            key: const Key('home-document-banner'),
            onPressed: () => context.push('/documents'),
            child: Text(banner),
          ),
      ],
    );
  }
}
