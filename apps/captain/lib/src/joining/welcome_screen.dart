import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// CA §5.1: the entry screen of a person not signed in. Unstyled until the
/// design.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainAppName)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          FilledButton(
            key: const Key('welcome-join'),
            onPressed: () => context.push('/join'),
            child: Text(l10n.captainJoin),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            key: const Key('welcome-sign-in'),
            onPressed: () => context.push('/sign-in'),
            child: Text(l10n.signInTitle),
          ),
        ],
      ),
    );
  }
}
