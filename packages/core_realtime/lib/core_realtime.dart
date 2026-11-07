/// Real time in the apps (architecture §6, §11.2): one Centrifugo connection
/// per app, and live feeds that keep a full state current over it, with
/// polling while it is down (RA §4.3, CU §4.3).
library;

export 'src/centrifuge_transport.dart';
export 'src/live_feed.dart';
export 'src/transport.dart';
