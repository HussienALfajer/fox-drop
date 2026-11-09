import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import 'status.dart';
import 'texts.dart';

/// The status pill of the top bar (RA §6.2): the state, tapped to open the
/// status sheet (owners and cashiers). Nothing until the first read answers.
class StatusPillButton extends ConsumerWidget {
  const StatusPillButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(statusProvider).value?.value;
    if (status == null) return const SizedBox.shrink();
    return TextButton(
      key: const Key('status-pill'),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => const StatusSheet(),
      ),
      child: Text(pillText(l10n, status)),
    );
  }
}

/// The status sheet (RA §7.2): the state with its end and the next schedule
/// change, the pause choices, busy mode and resume. Operations' pause and the
/// auto-pause disable every button and say why.
class StatusSheet extends ConsumerStatefulWidget {
  const StatusSheet({super.key});

  @override
  ConsumerState<StatusSheet> createState() => _StatusSheetState();
}

class _StatusSheetState extends ConsumerState<StatusSheet> {
  bool _sending = false;
  StatusRefusal? _refused;

  Future<void> _send(
    Future<StatusRefusal?> Function(StatusCommands) run,
  ) async {
    setState(() {
      _sending = true;
      _refused = null;
    });
    final refused = await run(ref.read(statusCommandsProvider));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _refused = refused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(statusProvider).value?.value;
    if (status == null) return const SizedBox.shrink();
    final now = ref.read(serverClockProvider).now();
    final actions = sheetActions(status);
    final enabled = !_sending;
    final next = nextScheduleText(l10n, status, now);
    final until = stateUntilText(l10n, status, now);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              pillText(l10n, status),
              key: const Key('status-current'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (until != null) Text(until),
            if (next != null) Text(next, key: const Key('status-next')),
            if (actions.lockedByOperations)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8),
                child: Text(
                  l10n.merchantStatusLockedByOperations,
                  key: const Key('status-locked'),
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (index, minutes) in status.pauseChoicesMin.indexed)
                  OutlinedButton(
                    key: Key('pause-$minutes'),
                    onPressed: enabled && actions.pause
                        ? () => _send((c) => c.pause(minutes))
                        : null,
                    child: Text(
                      index == 0
                          ? l10n.merchantStatusPauseFirst(minutes)
                          : l10n.merchantStatusMinutes(minutes),
                    ),
                  ),
                OutlinedButton(
                  key: const Key('pause-until-reopening'),
                  onPressed: enabled && actions.pause
                      ? () => _send((c) => c.pause(null))
                      : null,
                  child: Text(l10n.merchantStatusPauseUntilReopening),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (index, minutes)
                    in status.busyExtraOptionsMin.indexed)
                  OutlinedButton(
                    key: Key('busy-$minutes'),
                    onPressed:
                        enabled &&
                            actions.busyModeOn &&
                            status.busyMode?.extraMin != minutes
                        ? () => _send((c) => c.busyMode(minutes))
                        : null,
                    child: Text(
                      index == 0
                          ? l10n.merchantStatusBusyMode(minutes)
                          : l10n.merchantStatusBusyExtra(minutes),
                    ),
                  ),
                if (actions.busyModeOff)
                  OutlinedButton(
                    key: const Key('busy-off'),
                    onPressed: enabled
                        ? () => _send((c) => c.busyMode(null))
                        : null,
                    child: Text(l10n.merchantStatusBusyModeOff),
                  ),
              ],
            ),
            if (actions.resume) ...[
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('resume'),
                onPressed: enabled ? () => _send((c) => c.resume()) : null,
                child: Text(l10n.merchantStatusResume),
              ),
            ],
            if (_refused case final refused?)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8),
                child: Text(
                  refusalText(l10n, refused),
                  key: const Key('status-refused'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// RA §6.3 items 3 and 6, under the offline bar and the emergency stop.
class StatusBanners extends ConsumerWidget {
  const StatusBanners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(statusProvider).value?.value;
    if (status == null) return const SizedBox.shrink();
    return Column(
      children: [
        for (final banner in statusBanners(status))
          MaterialBanner(
            key: Key('status-banner-${banner.name}'),
            content: Text(bannerText(l10n, banner, status)),
            actions: const [SizedBox.shrink()],
          ),
      ],
    );
  }
}
