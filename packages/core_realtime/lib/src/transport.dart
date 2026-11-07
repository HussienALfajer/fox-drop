/// What a channel tells a live feed.
sealed class RealtimeSignal {
  const RealtimeSignal();
}

/// Subscribed. [recovered] is true when the server sent every publication
/// missed since the last offset; false on the first subscription and when
/// recovery was not possible, and the feed fetches the full state then
/// (architecture §6.1).
class RealtimeUp extends RealtimeSignal {
  const RealtimeUp({required this.recovered});

  final bool recovered;
}

/// The connection or the subscription is down; the client tries again on
/// its own.
class RealtimeDown extends RealtimeSignal {
  const RealtimeDown();
}

/// One publication on the channel: the outbox relay's JSON object
/// (`apps/server/src/modules/ordering/outbox-relay.ts`).
class RealtimePublication extends RealtimeSignal {
  const RealtimePublication(this.data);

  final Map<String, Object?> data;
}

/// The app's real-time connection: a stream of signals per channel. The
/// subscription lasts while the stream is listened to.
abstract interface class RealtimeTransport {
  Stream<RealtimeSignal> channel(String name);
}
