import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import 'favourites.dart';

/// The heart on a restaurant card and page (CU §9.6). A guest is sent to
/// sign in, then back where they were.
class HeartButton extends ConsumerWidget {
  const HeartButton({
    super.key,
    required this.restaurantId,
    required this.favourite,
  });

  final String restaurantId;

  /// What the server answered with the card or the page.
  final bool favourite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(heartsProvider);
    final shown = ref
        .read(heartsProvider.notifier)
        .shown(restaurantId, favourite);
    return IconButton(
      key: Key('heart-$restaurantId'),
      tooltip: shown ? l10n.customerRemoveFavourite : l10n.customerAddFavourite,
      icon: Icon(shown ? Icons.favorite : Icons.favorite_border),
      onPressed: () async {
        // A guest's heart does nothing until the sign-in screen is built;
        // the guest stays where they are.
        if (ref.read(customerAuth.session).value is! SignedIn) return;
        final messenger = ScaffoldMessenger.of(context);
        final done = await ref
            .read(heartsProvider.notifier)
            .toggle(restaurantId, favourite: shown);
        if (!done) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.statusError)));
        }
      },
    );
  }
}
