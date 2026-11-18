import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search.dart';

/// CU §8.3 «لم تجده؟ أخبرنا»: the restaurant's name (required) and a note
/// (optional), then «شكراً، سنحاول إضافته». The search it followed goes
/// with it. Unstyled until the design.
class SuggestScreen extends ConsumerStatefulWidget {
  const SuggestScreen({super.key, required this.query});

  final String? query;

  @override
  ConsumerState<SuggestScreen> createState() => _SuggestScreenState();
}

class _SuggestScreenState extends ConsumerState<SuggestScreen> {
  final _name = TextEditingController();
  final _note = TextEditingController();
  bool _sending = false;
  bool _sent = false;
  bool _failed = false;

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() {
      _sending = true;
      _failed = false;
    });
    final note = _note.text.trim();
    final query = widget.query?.trim();
    final sent = await ref
        .read(restaurantSuggestionProvider)
        .send(
          restaurantName: _name.text.trim(),
          note: note.isEmpty ? null : note,
          query: query == null || query.isEmpty ? null : query,
        );
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = sent;
      _failed = !sent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerSuggestOpen)),
      body: _sent
          ? Center(
              child: Text(
                l10n.customerSuggestThanks,
                key: const Key('suggest-thanks'),
              ),
            )
          : ListView(
              padding: const EdgeInsetsDirectional.all(16),
              children: [
                TextField(
                  key: const Key('suggest-name'),
                  controller: _name,
                  maxLength: 60,
                  decoration: InputDecoration(
                    labelText: l10n.customerSuggestName,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                TextField(
                  key: const Key('suggest-note'),
                  controller: _note,
                  maxLength: 200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.customerSuggestNote,
                  ),
                ),
                if (_failed) Text(l10n.statusError),
                FilledButton(
                  key: const Key('suggest-send'),
                  onPressed: _sending || _name.text.trim().isEmpty
                      ? null
                      : _send,
                  child: Text(l10n.customerSuggestSend),
                ),
              ],
            ),
    );
  }
}
