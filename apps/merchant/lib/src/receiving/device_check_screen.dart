import 'dart:async';

import 'package:core_alerts/core_alerts.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../board/alerts.dart';
import '../push.dart';
import 'receiving.dart';

/// «فحص الجهاز» (RA §4.5): each check with what to do and the system's page
/// to fix it, read again on coming back; the test ring on the alarm stream
/// with «سمعت الصوت»; the server connection's delay; then the result is
/// sent, which the panel shows (AP §9.6.4) and the activation needs (AP
/// §9.6.3). Unstyled until the design; the brands' screenshots come with it.
class DeviceCheckScreen extends ConsumerStatefulWidget {
  const DeviceCheckScreen({super.key});

  @override
  ConsumerState<DeviceCheckScreen> createState() => _DeviceCheckScreenState();
}

class _DeviceCheckScreenState extends ConsumerState<DeviceCheckScreen> {
  bool? _heard;
  bool _playing = false;
  int? _delayMs;
  bool _connectionFailed = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_measure());
    // RA §4.5: «at the first sign-in on each device»: once opened, the app
    // no longer asks by itself.
    unawaited(ref.read(deviceStoreProvider).write(deviceCheckDoneKey, 'true'));
  }

  late final Ringer _ringer = ref.read(ringerProvider);

  @override
  void dispose() {
    if (_playing) _ringer.stop();
    super.dispose();
  }

  /// RA §4.5 check 8: one request to the server, timed.
  Future<void> _measure() async {
    final watch = Stopwatch()..start();
    try {
      await ref.read(coreApiProvider).getMerchantApi().merchantAuthCurrent();
      if (!mounted) return;
      setState(() {
        _delayMs = watch.elapsedMilliseconds;
        _connectionFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _delayMs = null;
        _connectionFailed = true;
      });
    }
  }

  Future<void> _ring(AppLocalizations l10n) async {
    setState(() => _playing = true);
    _ringer.test(l10n.merchantCheckTestRing);
  }

  Future<void> _answer(bool heard) async {
    _ringer.stop();
    setState(() {
      _playing = false;
      _heard = heard;
    });
  }

  Future<void> _confirmAutostart() async {
    await ref.read(deviceStoreProvider).write(autostartConfirmedKey, 'true');
    ref.invalidate(autostartConfirmedProvider);
  }

  Future<void> _save(List<CheckItem> failed, AppLocalizations l10n) async {
    setState(() => _saving = true);
    final saved = await ref
        .read(thisDeviceProvider.notifier)
        .recordCheck(failed, _delayMs);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? l10n.merchantCheckSaved : l10n.merchantCheckSaveFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final readings = ref.watch(deviceReadingsProvider);
    final confirmed = ref.watch(autostartConfirmedProvider).value ?? false;
    final alerts = ref.read(alertsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantDeviceCheck)),
      body: switch (readings) {
        AsyncData(value: null) => Center(
          child: Text(l10n.merchantCheckWindowsLater),
        ),
        AsyncData(value: final DeviceReadings read) => () {
          final answers = CheckAnswers(
            autostartConfirmed: confirmed,
            heard: _heard,
            delayMs: _delayMs,
            connectionFailed: _connectionFailed,
          );
          final failed = failedItems(read, answers);
          Widget item(
            CheckItem check,
            String title,
            String how, {
            DeviceSetting? setting,
            List<Widget> more = const [],
          }) {
            final ok = !failed.contains(check);
            return Card(
              key: Key('check-${check.name}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(title),
                    trailing: Text(
                      ok ? l10n.merchantCheckDone : l10n.merchantCheckNotDone,
                    ),
                    subtitle: ok ? null : Text(how),
                  ),
                  ...more,
                  if (!ok && setting != null)
                    TextButton(
                      key: Key('open-${check.name}'),
                      onPressed: () => unawaited(alerts.openSettings(setting)),
                      child: Text(l10n.merchantCheckOpenSettings),
                    ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsetsDirectional.all(16),
            children: [
              Text(l10n.merchantDeviceCheckIntro),
              item(
                CheckItem.notifications,
                l10n.merchantCheckNotifications,
                l10n.merchantCheckNotificationsHow,
                setting: DeviceSetting.notifications,
              ),
              item(
                CheckItem.battery,
                l10n.merchantCheckBattery,
                l10n.merchantCheckBatteryHow,
                setting: DeviceSetting.battery,
              ),
              if (read.autostartPage)
                item(
                  CheckItem.autostart,
                  l10n.merchantCheckAutostart,
                  l10n.merchantCheckAutostartHow,
                  setting: DeviceSetting.autostart,
                  more: [
                    if (!confirmed)
                      TextButton(
                        key: const Key('autostart-done'),
                        onPressed: () => unawaited(_confirmAutostart()),
                        child: Text(l10n.merchantCheckAutostartDone),
                      ),
                  ],
                ),
              item(
                CheckItem.fullScreen,
                l10n.merchantCheckFullScreen,
                l10n.merchantCheckFullScreenHow,
                setting: DeviceSetting.fullScreen,
              ),
              item(
                CheckItem.alarmVolume,
                l10n.merchantCheckAlarm,
                l10n.merchantCheckAlarmHow,
                setting: read.doNotDisturbBlocks
                    ? DeviceSetting.doNotDisturb
                    : DeviceSetting.alarmVolume,
                more: [
                  Text(l10n.merchantCheckAlarmVolume(read.alarmVolumePercent)),
                  if (read.doNotDisturbBlocks)
                    Text(l10n.merchantCheckDoNotDisturb),
                ],
              ),
              item(
                CheckItem.testRing,
                l10n.merchantCheckTestRing,
                l10n.merchantCheckTestRingHow,
                more: [
                  if (!_playing)
                    TextButton(
                      key: const Key('test-ring'),
                      onPressed: () => unawaited(_ring(l10n)),
                      child: Text(l10n.merchantCheckTestRingPlay),
                    )
                  else ...[
                    FilledButton(
                      key: const Key('test-ring-heard'),
                      onPressed: () => unawaited(_answer(true)),
                      child: Text(l10n.merchantCheckTestRingHeard),
                    ),
                    TextButton(
                      key: const Key('test-ring-not-heard'),
                      onPressed: () => unawaited(_answer(false)),
                      child: Text(l10n.merchantCheckTestRingNotHeard),
                    ),
                  ],
                ],
              ),
              item(
                CheckItem.connection,
                l10n.merchantCheckConnection,
                l10n.merchantCheckConnectionFailed,
                more: [
                  if (_delayMs case final ms?)
                    Text(l10n.merchantCheckConnectionDelay(ms))
                  else if (_connectionFailed)
                    TextButton(
                      onPressed: () => unawaited(_measure()),
                      child: Text(l10n.merchantRetry),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                key: const Key('check-verdict'),
                failed.isEmpty
                    ? l10n.merchantCheckPassedAll
                    : l10n.merchantCheckNotPassed,
              ),
              FilledButton(
                key: const Key('save-check'),
                // The connection's measure is needed before a result.
                onPressed: _saving || (_delayMs == null && !_connectionFailed)
                    ? null
                    : () => unawaited(_save(failed, l10n)),
                child: Text(l10n.merchantCheckSave),
              ),
            ],
          );
        }(),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(deviceReadingsProvider),
            child: Text(l10n.merchantCheckReadFailed),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
