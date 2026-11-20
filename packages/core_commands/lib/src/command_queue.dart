import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:core_storage/core_storage.dart';

/// A command sent to the server and not answered yet (RA §4.7): its
/// idempotency key, what it is (`kind`) and on what (`subject`, such as an
/// order), its arguments as JSON values, the account that sent it, and when.
class QueuedCommand {
  const QueuedCommand({
    required this.key,
    required this.kind,
    required this.subject,
    required this.accountId,
    required this.args,
    required this.queuedAt,
  });

  final String key;
  final String kind;
  final String subject;
  final String accountId;
  final Map<String, Object?> args;
  final DateTime queuedAt;

  /// The command as a whole, for finding its key again: the same command
  /// sent again keeps its key until the server answers (RA §4.7).
  String get identity => '$subject $kind ${jsonEncode(args)}';

  Map<String, Object?> toJson() => {
    'key': key,
    'kind': kind,
    'subject': subject,
    'accountId': accountId,
    'args': args,
    'queuedAt': queuedAt.toUtc().toIso8601String(),
  };

  static QueuedCommand fromJson(Map<String, Object?> json) => QueuedCommand(
    key: json['key']! as String,
    kind: json['kind']! as String,
    subject: json['subject']! as String,
    accountId: json['accountId']! as String,
    args: (json['args']! as Map).cast<String, Object?>(),
    queuedAt: DateTime.parse(json['queuedAt']! as String),
  );
}

/// The commands not answered yet, kept on the device (architecture §11.2),
/// so a restart, a crash or the system ending the app sends them again with
/// the same key, and the server applies each once (RA §4.7). One JSON value
/// under one key of the device store, so it is never half written; the
/// writes take turns.
class CommandQueue {
  CommandQueue(this._store);

  final DeviceStore _store;
  Future<void> _turn = Future.value();

  static const storeKey = 'command_queue';

  /// The server answers a repeated key for 24 hours (architecture §5.3): an
  /// older command would run again as a new one, so it is dropped.
  static const keyLifetime = Duration(hours: 24);

  Future<List<QueuedCommand>> _read() async {
    final stored = await _store.read(storeKey);
    if (stored == null) return [];
    try {
      return [
        for (final each in jsonDecode(stored) as List)
          QueuedCommand.fromJson((each as Map).cast<String, Object?>()),
      ];
    } on Object {
      // A value no version wrote: nothing to send.
      return [];
    }
  }

  Future<T> _locked<T>(Future<T> Function() run) {
    final done = _turn.then((_) => run());
    _turn = done.then<void>((_) {}, onError: (_) {});
    return done;
  }

  Future<void> _write(List<QueuedCommand> commands) => commands.isEmpty
      ? _store.delete(storeKey)
      : _store.write(
          storeKey,
          jsonEncode([for (final each in commands) each.toJson()]),
        );

  /// The commands still waiting, oldest first, those past [keyLifetime]
  /// dropped.
  Future<List<QueuedCommand>> pending(DateTime now) => _locked(() async {
    final commands = await _read();
    final alive = [
      for (final each in commands)
        if (now.difference(each.queuedAt) < keyLifetime) each,
    ];
    if (alive.length != commands.length) await _write(alive);
    return alive;
  });

  /// Keeps [command] until [remove]; the same key again replaces it.
  Future<void> put(QueuedCommand command) => _locked(() async {
    final commands = await _read();
    await _write([
      for (final each in commands)
        if (each.key != command.key) each,
      command,
    ]);
  });

  Future<void> remove(String key) => _locked(() async {
    final commands = await _read();
    final left = [
      for (final each in commands)
        if (each.key != key) each,
    ];
    if (left.length != commands.length) await _write(left);
  });
}

/// RA §4.7: a call with no answer (none, a 5xx, a 408 or a 429) is sent
/// again; any other answer is the server's.
bool unanswered(int? status) =>
    status == null || status >= 500 || status == 408 || status == 429;

/// The wait before each retry: exponential from 1 s to 15 s, with jitter
/// over its upper half, so devices that lost the network together do not
/// retry together.
Duration retryDelay(int attempt, [Random? random]) {
  final base = min(15000, 1000 * pow(2, attempt).toInt());
  return Duration(
    milliseconds: base ~/ 2 + (random ?? Random()).nextInt(base ~/ 2 + 1),
  );
}
