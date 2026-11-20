import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_alerts/core_alerts.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' hide Hash;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth.dart';
import '../board/alerts.dart';
import '../board/board.dart';

/// Velopack's feed of the Windows installer (architecture §12.3; owner
/// decision 2026-11-20: on the Contabo server, `/downloads/windows/` on the
/// API's host): `--dart-define=WINDOWS_UPDATE_FEED=https://…/downloads/windows/`.
/// Without it (development) the app never updates itself.
const _feed = String.fromEnvironment('WINDOWS_UPDATE_FEED');

/// The raw Ed25519 public key (base64) whose signature of the feed
/// (`releases.win.json.sig`) the app checks before it trusts the feed, so a
/// file put on the server by anyone but CI's signing step is never installed
/// (slice 2.44). Without it the app never updates itself.
const _feedPublicKey = String.fromEnvironment('WINDOWS_FEED_PUBLIC_KEY');

/// Whether [signature] (base64) is [publicKey]'s Ed25519 signature of [feed]'s
/// bytes.
Future<bool> feedSigned(String feed, String signature, String publicKey) async {
  try {
    return await Ed25519().verify(
      utf8.encode(feed),
      signature: Signature(
        base64.decode(signature.trim()),
        publicKey: SimplePublicKey(
          base64.decode(publicKey),
          type: KeyPairType.ed25519,
        ),
      ),
    );
  } on Object {
    return false;
  }
}

/// How often the feed is read after the start.
const updateCheckEvery = Duration(hours: 1);

/// A version as Velopack orders them (SemVer 2): `0.1.0-staging.12`.
class AppVersion implements Comparable<AppVersion> {
  AppVersion._(this.core, this.prerelease, this.text);

  final List<int> core;
  final List<String> prerelease;
  final String text;

  /// Null for text that is not SemVer.
  static AppVersion? parse(String text) {
    final match = RegExp(
      r'^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z.-]+))?(?:\+.*)?$',
    ).firstMatch(text.trim());
    if (match == null) return null;
    return AppVersion._(
      [for (var i = 1; i <= 3; i++) int.parse(match[i]!)],
      match[4]?.split('.') ?? const [],
      text.trim(),
    );
  }

  @override
  int compareTo(AppVersion other) {
    for (var i = 0; i < 3; i++) {
      final order = core[i].compareTo(other.core[i]);
      if (order != 0) return order;
    }
    // A release orders after its pre-releases.
    if (prerelease.isEmpty || other.prerelease.isEmpty) {
      if (prerelease.isEmpty == other.prerelease.isEmpty) return 0;
      return prerelease.isEmpty ? 1 : -1;
    }
    for (var i = 0; i < prerelease.length && i < other.prerelease.length; i++) {
      final a = prerelease[i];
      final b = other.prerelease[i];
      final na = int.tryParse(a);
      final nb = int.tryParse(b);
      final order = na != null && nb != null
          ? na.compareTo(nb)
          : na != null
          ? -1
          : nb != null
          ? 1
          : a.compareTo(b);
      if (order != 0) return order;
    }
    return prerelease.length.compareTo(other.prerelease.length);
  }

  bool operator >(AppVersion other) => compareTo(other) > 0;
}

/// A full package of the feed (`releases.win.json`'s `Assets`).
class UpdatePackage {
  const UpdatePackage({
    required this.version,
    required this.fileName,
    required this.sha256,
  });

  final AppVersion version;
  final String fileName;
  final String sha256;
}

/// The newest full package of a feed, null without one.
UpdatePackage? newestFull(String feedJson) {
  final assets = (jsonDecode(feedJson) as Map<String, Object?>)['Assets'];
  if (assets is! List) return null;
  UpdatePackage? newest;
  for (final asset in assets.whereType<Map<String, Object?>>()) {
    if (asset['Type'] != 'Full') continue;
    final version = AppVersion.parse('${asset['Version']}');
    final fileName = asset['FileName'];
    final sha256 = asset['SHA256'];
    // A name with a path would leave the packages folder.
    if (version == null ||
        fileName is! String ||
        sha256 is! String ||
        fileName.contains(RegExp(r'[\\/]'))) {
      continue;
    }
    if (newest == null || version > newest.version) {
      newest = UpdatePackage(
        version: version,
        fileName: fileName,
        sha256: sha256.toLowerCase(),
      );
    }
  }
  return newest;
}

/// The version Velopack installed, from the manifest beside the executable
/// (`current/sq.version`, a nuspec).
AppVersion? installedVersion(String nuspec) {
  final match = RegExp(r'<version>([^<]+)</version>').firstMatch(nuspec);
  return match == null ? null : AppVersion.parse(match[1]!);
}

/// RA §4.2: the app never restarts while a ring or a pickup prompt is open,
/// or while the restaurant has active orders; signed out, nothing waits. A
/// board not read yet (or failed) counts as busy.
bool mayRestartForUpdate({required bool signedIn, required Board? board}) {
  if (!signedIn) return true;
  if (board == null) return false;
  return board.orders.isEmpty && ringing(board).isEmpty;
}

/// Velopack's install: `<root>/Update.exe`, the app in `<root>/current/`,
/// the downloads in `<root>/packages/`.
class VelopackInstall {
  VelopackInstall._(this.root, this.version);

  final Directory root;
  final AppVersion version;

  /// Null when the app was not installed by Velopack (a development run).
  static VelopackInstall? find() {
    final current = File(Platform.resolvedExecutable).parent;
    final manifest = File('${current.path}${Platform.pathSeparator}sq.version');
    final root = current.parent;
    if (!manifest.existsSync() ||
        !File(_join(root, 'Update.exe')).existsSync()) {
      return null;
    }
    final version = installedVersion(manifest.readAsStringSync());
    return version == null ? null : VelopackInstall._(root, version);
  }

  String get updateExe => _join(root, 'Update.exe');
  Directory get packages => Directory(_join(root, 'packages'));
}

String _join(Directory directory, String name) =>
    '${directory.path}${Platform.pathSeparator}$name';

/// RA §4.2 on Windows (slice 2.44): reads the feed at the start and every
/// [updateCheckEvery], trusts it only with its signature, downloads a newer full package in the background
/// (checked against its SHA-256), and restarts into it through Velopack's
/// `Update.exe apply` as soon as [mayRestart] allows.
class WindowsUpdater {
  WindowsUpdater({
    required this.install,
    required this.feed,
    required this.publicKey,
    required this.http,
    required this.mayRestart,
    required this.restart,
  });

  final VelopackInstall install;
  final Uri feed;
  final String publicKey;
  final Dio http;
  final bool Function() mayRestart;

  /// Quits the app, running the given step last.
  final Future<void> Function(Future<void> Function() apply) restart;

  File? _ready;
  Timer? _timer;
  bool _checking = false;

  void start() {
    unawaited(check());
    _timer = Timer.periodic(updateCheckEvery, (_) => unawaited(check()));
  }

  void dispose() => _timer?.cancel();

  Future<void> check() async {
    if (_checking || _ready != null) return;
    _checking = true;
    try {
      final answer = await http.getUri<String>(
        feed.resolve('releases.win.json'),
        options: Options(responseType: ResponseType.plain),
      );
      final signature = await http.getUri<String>(
        feed.resolve('releases.win.json.sig'),
        options: Options(responseType: ResponseType.plain),
      );
      final text = answer.data ?? '';
      if (!await feedSigned(text, signature.data ?? '', publicKey)) {
        throw StateError('the update feed is not signed by FOX DROP');
      }
      final newest = newestFull(text);
      if (newest == null || !(newest.version > install.version)) return;
      _ready = await _download(newest);
      await idle();
    } on Object catch (error) {
      debugPrint('No update: $error');
    } finally {
      _checking = false;
    }
  }

  /// Called whenever the board changes: restarts once a downloaded update
  /// waits and nothing is open.
  Future<void> idle() async {
    final package = _ready;
    if (package == null || !mayRestart()) return;
    _ready = null;
    await restart(
      () => Process.start(install.updateExe, [
        'apply',
        '--waitPid',
        '$pid',
        '--package',
        package.path,
      ], mode: ProcessStartMode.detached),
    );
  }

  Future<File> _download(UpdatePackage package) async {
    await install.packages.create(recursive: true);
    final file = File(_join(install.packages, package.fileName));
    if (await file.exists() && await _sha256(file) == package.sha256) {
      return file;
    }
    final partial = File('${file.path}.partial');
    await http.downloadUri(feed.resolve(package.fileName), partial.path);
    if (await _sha256(partial) != package.sha256) {
      await partial.delete();
      throw StateError(
        'the update ${package.fileName} does not match its SHA-256',
      );
    }
    return partial.rename(file.path);
  }

  static Future<String> _sha256(File file) async =>
      (await sha256.bind(file.openRead()).first).toString();
}

/// Watched by `MerchantApp`: on a Velopack install with a feed, the updater
/// runs and the board's changes let it restart. Nothing elsewhere.
final windowsUpdateProvider = Provider<void>((ref) {
  final alerts = ref.watch(alertsProvider);
  if (_feed.isEmpty || _feedPublicKey.isEmpty || alerts is! WindowsAlerts) {
    return;
  }
  final install = VelopackInstall.find();
  if (install == null) return;
  bool allowed() => mayRestartForUpdate(
    signedIn: ref.read(merchantAuth.session).value is SignedIn,
    board: ref.read(boardProvider).value?.value,
  );
  final updater = WindowsUpdater(
    install: install,
    feed: Uri.parse(_feed.endsWith('/') ? _feed : '$_feed/'),
    publicKey: _feedPublicKey,
    http: Dio(),
    mayRestart: allowed,
    restart: (apply) => alerts.quitNow(beforeQuit: apply),
  );
  ref.listen<AsyncValue<LiveState<Board>>>(
    boardProvider,
    (previous, next) => unawaited(updater.idle()),
  );
  ref.listen(
    merchantAuth.session,
    (previous, next) => unawaited(updater.idle()),
  );
  ref.onDispose(updater.dispose);
  updater.start();
});
