import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(AppLocalizations.of(context).notFound)),
    );
  }
}
