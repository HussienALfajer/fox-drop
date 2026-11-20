import 'core_alerts.dart';

/// Records every call, for the apps' tests; [deviceReadings] is what
/// [readings] answers.
class FakeAlerts implements Alerts {
  FakeAlerts({this.deviceReadings});

  DeviceReadings? deviceReadings;
  bool receiving = false;
  RingSound? ringing;
  String? ringBody;
  int chimes = 0;
  final List<DeviceSetting> opened = [];

  /// Every call by its method's name, in order.
  final List<String> calls = [];

  @override
  Future<void> startReceiving() async {
    calls.add('startReceiving');
    receiving = true;
  }

  @override
  Future<void> stopReceiving() async {
    calls.add('stopReceiving');
    receiving = false;
  }

  @override
  Future<void> ring(
    RingSound sound, {
    required String title,
    required String body,
  }) async {
    calls.add('ring');
    ringing = sound;
    ringBody = body;
  }

  @override
  Future<void> stopRing() async {
    calls.add('stopRing');
    ringing = null;
    ringBody = null;
  }

  @override
  Future<void> chime() async => chimes += 1;

  @override
  Future<DeviceReadings?> readings() async => deviceReadings;

  @override
  Future<void> openSettings(DeviceSetting setting) async => opened.add(setting);
}
