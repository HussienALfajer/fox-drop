import 'dart:async';

import 'package:core_alerts/core_alerts.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../profile/profile.dart';
import '../work/alerts.dart';
import '../work/location.dart';
import 'device_check.dart';

/// «فحص الجهاز» (CA §4.5, slice 2.43): each check with what to do and the
/// system's page to fix it, read again on coming back; the test offer on the
/// alarm stream over the lock screen with «سمعت الصوت»; the server's delay
/// and the GPS accuracy; then the result is sent, which the panel shows (AP
/// §9.7.4). It never blocks going online. Unstyled until the design; the
/// brands' screenshots come with it.
class DeviceCheckScreen extends ConsumerStatefulWidget {
  const DeviceCheckScreen({super.key});

  @override
  ConsumerState<DeviceCheckScreen> createState() => _DeviceCheckScreenState();
}

class _DeviceCheckScreenState extends ConsumerState<DeviceCheckScreen> {
  bool? _heard;
  // The brand's auto-start, confirmed again on each run (CA §4.5).
  bool _autostartConfirmed = false;
  bool _playing = false;
  int? _delayMs;
  int? _gpsMetres;
  bool _measuring = false;
  bool _saving = false;
  late final Alerts _alerts = ref.read(alertsProvider);
  late final Ringer _ringer = ref.read(ringerProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_measure());
    unawaited(
      ref.read(deviceStoreProvider).write(deviceCheckOpenedKey, 'true'),
    );
  }

  @override
  void dispose() {
    if (_playing) _ringer.stopTest();
    super.dispose();
  }

  /// Check 7: one request to the server, timed, and one fresh position.
  Future<void> _measure() async {
    setState(() => _measuring = true);
    final watch = Stopwatch()..start();
    int? delay;
    try {
      await ref.read(coreApiProvider).getCaptainApi().captainAuthCurrent();
      delay = watch.elapsedMilliseconds;
    } on Object {
      delay = null;
    }
    final fix = await ref.read(locationSourceProvider).current();
    if (!mounted) return;
    setState(() {
      _measuring = false;
      _delayMs = delay;
      _gpsMetres = fix?.accuracyMetres.round();
    });
  }

  /// Check 6: the offer's ring for 30 seconds, time to lock the phone.
  void _play(AppLocalizations l10n) {
    setState(() => _playing = true);
    _ringer.test(l10n.captainCheckTestOfferRing, testOfferRings);
  }

  void _answer(bool heard) {
    _ringer.stopTest();
    setState(() {
      _playing = false;
      _heard = heard;
    });
  }

  Future<void> _save(List<CheckItem> failed, AppLocalizations l10n) async {
    setState(() => _saving = true);
    final saved = await ref
        .read(thisDeviceCheckProvider.notifier)
        .record(failed);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? l10n.captainCheckSaved : l10n.captainCheckSaveFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final readings = ref.watch(phoneReadingsProvider);
    final confirmed = _autostartConfirmed;
    final access = ref.read(phoneAccessReaderProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainDeviceCheck)),
      body: switch (readings) {
        AsyncData(value: null) => Center(
          child: Text(l10n.captainCheckUnavailable),
        ),
        AsyncData(value: final PhoneReadings read) => () {
          final answers = CheckAnswers(
            autostartConfirmed: confirmed,
            heard: _heard,
            delayMs: _delayMs,
            gpsMetres: _gpsMetres,
          );
          final failed = failedItems(read, answers);
          Widget item(
            List<CheckItem> checks,
            String title,
            String how, {
            VoidCallback? fix,
            String? fixLabel,
            List<Widget> more = const [],
          }) {
            final ok = !checks.any(failed.contains);
            return Card(
              key: Key('check-${checks.first.name}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(title),
                    trailing: Text(
                      ok ? l10n.captainCheckDone : l10n.captainCheckNotDone,
                    ),
                    subtitle: ok ? null : Text(how),
                  ),
                  ...more,
                  if (!ok && fix != null)
                    TextButton(
                      key: Key('fix-${checks.first.name}'),
                      onPressed: fix,
                      child: Text(fixLabel ?? l10n.captainCheckOpenSettings),
                    ),
                ],
              ),
            );
          }

          VoidCallback open(DeviceSetting setting) =>
              () => unawaited(_alerts.openSettings(setting));
          final device = read.device;
          return ListView(
            padding: const EdgeInsetsDirectional.all(16),
            children: [
              Text(l10n.captainDeviceCheckIntro),
              item(
                [CheckItem.notifications],
                l10n.captainCheckNotifications,
                l10n.captainCheckNotificationsHow,
                fix: open(DeviceSetting.notifications),
              ),
              item(
                [CheckItem.location],
                l10n.captainCheckLocation,
                l10n.captainCheckLocationHow,
                fix: () => unawaited(access.openLocationSettings()),
              ),
              item(
                [CheckItem.battery],
                l10n.captainCheckBattery,
                l10n.captainCheckBatteryHow,
                fix: open(DeviceSetting.battery),
              ),
              if (device.autostartPage)
                item(
                  [CheckItem.autostart],
                  l10n.captainCheckAutostart,
                  l10n.captainCheckAutostartHow,
                  fix: open(DeviceSetting.autostart),
                  more: [
                    if (!confirmed)
                      TextButton(
                        key: const Key('autostart-done'),
                        onPressed: () =>
                            setState(() => _autostartConfirmed = true),
                        child: Text(l10n.captainCheckAutostartDone),
                      ),
                  ],
                ),
              item(
                [CheckItem.fullScreen],
                l10n.captainCheckFullScreen,
                l10n.captainCheckFullScreenHow,
                fix: open(DeviceSetting.fullScreen),
              ),
              item(
                [CheckItem.alarmVolume, CheckItem.doNotDisturb],
                l10n.captainCheckAlarm,
                l10n.captainCheckAlarmHow,
                fix: open(
                  device.doNotDisturbBlocks
                      ? DeviceSetting.doNotDisturb
                      : DeviceSetting.alarmVolume,
                ),
                more: [
                  Text(l10n.captainCheckAlarmVolume(device.alarmVolumePercent)),
                  if (device.doNotDisturbBlocks)
                    Text(l10n.captainCheckDoNotDisturb),
                ],
              ),
              item(
                [CheckItem.testOffer],
                l10n.captainCheckTestOffer,
                l10n.captainCheckTestOfferHow,
                more: [
                  if (!_playing)
                    TextButton(
                      key: const Key('test-offer'),
                      onPressed: () => _play(l10n),
                      child: Text(l10n.captainCheckTestOfferPlay),
                    )
                  else ...[
                    FilledButton(
                      key: const Key('test-offer-heard'),
                      onPressed: () => _answer(true),
                      child: Text(l10n.captainCheckTestOfferHeard),
                    ),
                    TextButton(
                      key: const Key('test-offer-not-heard'),
                      onPressed: () => _answer(false),
                      child: Text(l10n.captainCheckTestOfferNotHeard),
                    ),
                  ],
                ],
              ),
              item(
                [CheckItem.connection, CheckItem.gpsAccuracy],
                l10n.captainCheckConnection,
                l10n.captainCheckConnectionFailed,
                fix: _measuring ? null : () => unawaited(_measure()),
                fixLabel: l10n.captainRetry,
                more: [
                  if ((_delayMs, _gpsMetres) case (final ms?, final metres?))
                    Text(l10n.captainCheckConnectionResult(ms, metres)),
                ],
              ),
              item(
                [CheckItem.call],
                l10n.captainCheckCall,
                l10n.captainCheckCallHow,
                fix: () => unawaited(
                  access.requestCall().then(
                    (_) => ref.invalidate(phoneReadingsProvider),
                  ),
                ),
                fixLabel: l10n.captainCheckAllow,
              ),
              const SizedBox(height: 16),
              Text(
                key: const Key('check-verdict'),
                failed.isEmpty
                    ? l10n.captainCheckPassedAll
                    : l10n.captainCheckNotPassed,
              ),
              FilledButton(
                key: const Key('save-check'),
                // Check 7's measure is needed before a result.
                onPressed: _saving || _measuring
                    ? null
                    : () => unawaited(_save(failed, l10n)),
                child: Text(l10n.captainCheckSave),
              ),
            ],
          );
        }(),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(phoneReadingsProvider),
            child: Text(l10n.captainCheckReadFailed),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
