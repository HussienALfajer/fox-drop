import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

/// CA §5.1: the entry screen of a person not signed in. Unstyled until the
/// design. Its «انضم ككابتن» and «تسجيل الدخول» left with the sign-in screen
/// in D.R1 (2026-11-27) and return with its approved drawing.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(appBar: AppBar(title: Text(l10n.captainAppName)));
  }
}
