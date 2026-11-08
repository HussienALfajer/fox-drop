import 'dart:async';
import 'dart:math';

import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// The app's terms and privacy as the server answered them (AP §9.13): the
/// version in force and whether the signed-in account still has to accept
/// it. A guest, and a restaurant's cashier, never has to (RA S13).
class Terms {
  const Terms({
    required this.version,
    required this.body,
    required this.pending,
  });

  final int version;
  final String body;
  final bool pending;

  @override
  bool operator ==(Object other) =>
      other is Terms &&
      other.version == version &&
      other.body == body &&
      other.pending == pending;

  @override
  int get hashCode => Object.hash(version, body, pending);
}

/// `GET /v1/{party}/terms` as the app keeps it.
Terms termsOf(TermsDtoOutput answer) =>
    Terms(version: answer.version, body: answer.body, pending: answer.pending);

/// What accepting a version came to.
enum TermsAcceptance { accepted, outdated }

/// The app's terms kept current: read at [start] and each time the app comes
/// back to the foreground, so a version published meanwhile is asked for on
/// the next open (AP §9.13), and after a failed read again, 5 s doubling to
/// 5 minutes. Null until the first answer: nothing waits on terms the app
/// could not read, and the server refuses what they block.
class TermsCheck extends ChangeNotifier {
  TermsCheck({
    required Future<Terms> Function() read,
    required Future<void> Function(int version) accept,
    this.firstRetry = const Duration(seconds: 5),
    this.lastRetry = const Duration(minutes: 5),
  }) : _read = read,
       _accept = accept;

  final Future<Terms> Function() _read;
  final Future<void> Function(int version) _accept;
  final Duration firstRetry;
  final Duration lastRetry;

  Terms? _terms;
  AppLifecycleListener? _lifecycle;
  Timer? _retry;
  // Each read, sign-out and acceptance starts a new generation; an answer
  // of an older one is dropped, so a read sent before them never overwrites
  // what they changed (another account's answer, an acceptance).
  int _generation = 0;
  bool _disposed = false;

  Terms? get terms => _terms;

  /// The signed-in account has a version to accept.
  bool get pending => _terms?.pending ?? false;

  /// Reads now, and again whenever the app resumes.
  void start() {
    _lifecycle ??= AppLifecycleListener(onResume: () => unawaited(check()));
    unawaited(check());
  }

  /// Forgets the account's answer, such as at sign-out: nothing is pending
  /// until the next read, and a read still on its way is dropped.
  void clear() {
    _generation++;
    _retry?.cancel();
    _set(null);
  }

  /// Reads the terms now; completes once this read is answered or failed.
  Future<void> check() => _check(++_generation, firstRetry);

  /// «أوافق» on [version], the one the screen showed (CU §15, CA §15). A
  /// newer one published meanwhile is read and answered [outdated], so the
  /// screen shows it; any other failure throws.
  Future<TermsAcceptance> accept(int version) async {
    try {
      await _accept(version);
    } on DioException catch (error) {
      if (error.response?.statusCode != 409) rethrow;
      await check();
      return TermsAcceptance.outdated;
    }
    _generation++;
    _set(Terms(version: version, body: _terms?.body ?? '', pending: false));
    unawaited(check());
    return TermsAcceptance.accepted;
  }

  void _set(Terms? terms) {
    if (_disposed || terms == _terms) return;
    _terms = terms;
    notifyListeners();
  }

  Future<void> _check(int generation, Duration wait) async {
    if (_disposed) return;
    _retry?.cancel();
    _retry = null;
    try {
      final terms = await _read();
      if (generation == _generation) _set(terms);
    } on Object catch (error) {
      if (_disposed || generation != _generation) return;
      debugPrint('Terms check failed: $error');
      final next = Duration(
        microseconds: min(wait.inMicroseconds * 2, lastRetry.inMicroseconds),
      );
      _retry = Timer(wait, () => unawaited(_check(generation, next)));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _retry?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }
}

/// «الشروط والخصوصية» (AP §9.13): the version in force, with «أوافق» while
/// it is pending. [onAccepted] runs once it is accepted, such as closing the
/// screen. Unstyled until the design.
class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key, required this.check, this.onAccepted});

  final TermsCheck check;
  final VoidCallback? onAccepted;

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _busy = false;
  String? _message;

  // Read on every opening: a version published while the app stayed open is
  // shown, with «أوافق» (CU Appendix C «Terms pending»).
  @override
  void initState() {
    super.initState();
    unawaited(widget.check.check());
  }

  Future<void> _accept(Terms terms, AppLocalizations l10n) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await widget.check.accept(terms.version);
      if (!mounted) return;
      if (result == TermsAcceptance.outdated) {
        setState(() => _message = l10n.termsOutdated);
      } else {
        widget.onAccepted?.call();
      }
    } on Object {
      if (mounted) setState(() => _message = l10n.termsFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.check,
          builder: (context, _) {
            final terms = widget.check.terms;
            if (terms == null) {
              return Center(
                child: TextButton(
                  onPressed: widget.check.check,
                  child: Text(l10n.contentFailed),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsetsDirectional.all(16),
              children: [
                if (terms.pending) ...[
                  Text(
                    l10n.termsNewVersion,
                    key: const Key('terms-new-version'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                ],
                Text(terms.body, key: const Key('terms-body')),
                if (_message case final message?) ...[
                  const SizedBox(height: 16),
                  Text(message, key: const Key('terms-message')),
                ],
                if (terms.pending) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('terms-accept'),
                    onPressed: _busy ? null : () => _accept(terms, l10n),
                    child: Text(l10n.termsAccept),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
