import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'platform_check.dart';
import 'platform_status.dart';

/// Where the update button leads: the build's `--dart-define=UPDATE_URL`, the
/// store page or the FOX DROP website's download for the platform (RA §4.2).
/// Null without one, and the button is hidden.
Uri? updateUrl() {
  const value = String.fromEnvironment('UPDATE_URL');
  return value.isEmpty ? null : Uri.tryParse(value);
}

Future<void> _openUpdate(Uri url) =>
    launchUrl(url, mode: LaunchMode.externalApplication);

/// The blocking maintenance or update screen (CU §4.2, §4.7, RA §4.2, §4.10,
/// CA §4.2, §4.8), maintenance first: an update does not end it. [extra] is
/// what the app keeps reachable, such as the customer's active order.
/// Unstyled until the design.
class PlatformBlockScreen extends StatelessWidget {
  const PlatformBlockScreen({
    super.key,
    required this.status,
    this.url,
    this.extra,
  });

  final PlatformStatus status;
  final Uri? url;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maintenance = status.maintenance;
    final url = this.url;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  maintenance
                      ? l10n.platformMaintenanceTitle
                      : l10n.platformUpdateRequiredTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  maintenance
                      ? status.maintenanceMessage ??
                            l10n.platformMaintenanceMessage
                      : status.updateMessage ??
                            l10n.platformUpdateRequiredMessage,
                  textAlign: TextAlign.center,
                ),
                if (!maintenance && url != null) ...[
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _openUpdate(url),
                    child: Text(l10n.platformUpdate),
                  ),
                ],
                if (extra case final extra?) ...[
                  const SizedBox(height: 16),
                  extra,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The dismissible banner of a suggested update (CU §4.2, RA §4.2, CA §4.2).
class UpdateBanner extends StatelessWidget {
  const UpdateBanner({
    super.key,
    required this.status,
    required this.onDismiss,
    this.url,
  });

  final PlatformStatus status;
  final VoidCallback onDismiss;
  final Uri? url;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final url = this.url;
    return MaterialBanner(
      content: Text(status.updateMessage ?? l10n.platformUpdateSuggested),
      actions: [
        if (url != null)
          TextButton(
            onPressed: () => _openUpdate(url),
            child: Text(l10n.platformUpdate),
          ),
        TextButton(onPressed: onDismiss, child: Text(l10n.platformLater)),
      ],
    );
  }
}

/// The app's screens under the suggested update's banner, while it shows
/// (CU §4.2, RA §4.2, CA §4.2). Wraps `MaterialApp.router`'s child.
class UpdateBannerFrame extends StatelessWidget {
  const UpdateBannerFrame({
    super.key,
    required this.check,
    required this.child,
    this.url,
  });

  final PlatformCheck check;
  final Widget child;
  final Uri? url;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: check,
    builder: (context, child) => !check.showsBanner
        ? child!
        : Column(
            children: [
              Material(
                child: SafeArea(
                  bottom: false,
                  child: UpdateBanner(
                    status: check.status,
                    url: url,
                    onDismiss: check.dismissBanner,
                  ),
                ),
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: child!,
                ),
              ),
            ],
          ),
    child: child,
  );
}
