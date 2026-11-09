import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../device.dart';
import 'hours.dart';
import 'status.dart';
import 'status_sheet.dart';
import 'texts.dart';

/// «الحالة والأوقات» (RA §6.1 #4, §10): the status for everyone; the weekly
/// schedule, the holiday close, the default prep time, the maximum active
/// orders and the fields an admin sets for owners only. It only shows the
/// state of `hours.dart` and calls its commands (the design stop).
class HoursScreen extends ConsumerWidget {
  const HoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final owner = ref.watch(
      merchantSessionProvider.select(
        (s) => s.value?.role == MerchantSessionDtoOutputRoleEnum.owner,
      ),
    );
    final status = ref.watch(statusProvider).value?.value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.merchantStatusAndHours)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          if (status != null)
            ListTile(
              key: const Key('hours-status'),
              title: Text(pillText(l10n, status)),
              subtitle: switch (nextScheduleText(
                l10n,
                status,
                ref.read(serverClockProvider).now(),
              )) {
                final next? => Text(next),
                null => null,
              },
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => const StatusSheet(),
              ),
            ),
          if (owner)
            // A read again after a save keeps the sections and their answer.
            switch (ref.watch(hoursProvider)) {
              AsyncValue(:final value?) => _OwnerSections(hours: value),
              AsyncError() => ListTile(
                title: Text(l10n.contentFailed),
                onTap: () => ref.invalidate(hoursProvider),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
        ],
      ),
    );
  }
}

class _OwnerSections extends StatelessWidget {
  const _OwnerSections({required this.hours});

  final Hours hours;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ScheduleEditor(key: ValueKey(hours.periods), hours: hours),
      const Divider(),
      HolidayEditor(hours: hours),
      const Divider(),
      OrderSettingsEditor(key: ValueKey(hours.defaultPrepMin), hours: hours),
      const Divider(),
      _ReadOnly(hours: hours),
    ],
  );
}

/// What a save answered, under its section.
String? refusalOf(AppLocalizations l10n, HoursRefusal? refusal) =>
    switch (refusal) {
      null => null,
      HoursRefusal.invalidSchedule => l10n.merchantHoursInvalidSchedule,
      HoursRefusal.invalidHoliday => l10n.merchantHoursInvalidHoliday,
      HoursRefusal.invalidSettings => l10n.merchantHoursInvalidSettings,
      HoursRefusal.other => l10n.merchantStatusRefusedOther,
    };

/// RA §10 «Weekly schedule»: each weekday's periods, several and overnight,
/// or «مغلق طوال اليوم».
class ScheduleEditor extends ConsumerStatefulWidget {
  const ScheduleEditor({super.key, required this.hours});

  final Hours hours;

  @override
  ConsumerState<ScheduleEditor> createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends ConsumerState<ScheduleEditor> {
  late WeekDraft _draft = WeekDraft.of(widget.hours);
  bool _saving = false;
  String? _message;

  Future<void> _pick(int weekday, int index, {required bool opening}) async {
    final period = _draft.days[weekday]![index];
    final minutes = opening ? period.opensAt : period.closesAt % 1440;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked == null) return;
    final chosen = picked.hour * 60 + picked.minute;
    setState(() {
      _draft = _draft.change(
        weekday,
        index,
        opening
            ? Period(chosen, period.closesAt)
            : Period(period.opensAt, chosen),
      );
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final refused = await ref.read(hoursCommandsProvider).saveSchedule(_draft);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _message = refusalOf(l10n, refused) ?? l10n.merchantHoursSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.merchantHoursSchedule,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        for (final day in weekdayOrder) ...[
          ListTile(
            key: Key('day-$day'),
            title: Text(l10n.weekdayName(day)),
            subtitle: _draft.days[day]!.isEmpty
                ? Text(l10n.merchantHoursClosedAllDay)
                : null,
            trailing: TextButton(
              key: Key('add-period-$day'),
              onPressed: () => setState(() => _draft = _draft.add(day)),
              child: Text(l10n.merchantHoursAddPeriod),
            ),
          ),
          for (final (index, period) in _draft.days[day]!.indexed)
            Row(
              key: Key('period-$day-$index'),
              children: [
                TextButton(
                  onPressed: () => _pick(day, index, opening: true),
                  child: Text(l10n.formatMinuteOfDay(period.opensAt)),
                ),
                Text(l10n.merchantHoursTo),
                TextButton(
                  onPressed: () => _pick(day, index, opening: false),
                  child: Text(l10n.formatMinuteOfDay(period.closesAt)),
                ),
                IconButton(
                  key: Key('remove-period-$day-$index'),
                  tooltip: l10n.merchantHoursRemovePeriod,
                  onPressed: () =>
                      setState(() => _draft = _draft.remove(day, index)),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
        ],
        FilledButton(
          key: const Key('save-schedule'),
          onPressed: _saving ? null : _save,
          child: Text(l10n.save),
        ),
        if (_message case final message?)
          Text(message, key: const Key('schedule-message')),
      ],
    );
  }
}

/// RA §10 «إغلاق لعدة أيام»: the close in force or set with «إنهاء الإغلاق»,
/// or a new one from now or a chosen moment until a moment, with a message.
class HolidayEditor extends ConsumerStatefulWidget {
  const HolidayEditor({super.key, required this.hours});

  final Hours hours;

  @override
  ConsumerState<HolidayEditor> createState() => _HolidayEditorState();
}

class _HolidayEditorState extends ConsumerState<HolidayEditor> {
  DateTime? _startsAt;
  DateTime? _endsAt;
  final _message = TextEditingController();
  bool _saving = false;
  String? _answer;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  // The pickers show the city's clock (`cityUtcOffset`), never the phone's
  // zone; the moment chosen goes back to UTC.
  Future<DateTime?> _pickMoment(DateTime from) async {
    final city = from.toUtc().add(cityUtcOffset);
    final day = DateTime(city.year, city.month, city.day);
    final date = await showDatePicker(
      context: context,
      initialDate: day,
      firstDate: day,
      lastDate: day.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: city.hour, minute: city.minute),
    );
    if (time == null) return null;
    return DateTime.utc(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).subtract(cityUtcOffset);
  }

  Future<void> _run(Future<HoursRefusal?> Function(HoursCommands) call) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final refused = await call(ref.read(hoursCommandsProvider));
    if (!mounted) return;
    setState(() {
      _saving = false;
      _answer = refusalOf(l10n, refused) ?? l10n.merchantHoursSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final holiday = widget.hours.holiday;
    final now = ref.read(serverClockProvider).now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.merchantHoursHoliday,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (holiday != null) ...[
          ListTile(
            key: const Key('holiday-current'),
            title: Text(
              l10n.merchantHoursHolidayFromTo(
                '${l10n.formatDate(holiday.startsAt)} ${l10n.formatTime(holiday.startsAt)}',
                '${l10n.formatDate(holiday.endsAt)} ${l10n.formatTime(holiday.endsAt)}',
              ),
            ),
            subtitle: holiday.message == null ? null : Text(holiday.message!),
          ),
          OutlinedButton(
            key: const Key('end-holiday'),
            onPressed: _saving ? null : () => _run((c) => c.endHoliday()),
            child: Text(l10n.merchantHoursEndHoliday),
          ),
        ] else ...[
          ListTile(
            key: const Key('holiday-from'),
            title: Text(
              _startsAt == null
                  ? l10n.merchantHoursFromNow
                  : l10n.merchantHoursFrom(
                      '${l10n.formatDate(_startsAt!)} ${l10n.formatTime(_startsAt!)}',
                    ),
            ),
            onTap: () async {
              final picked = await _pickMoment(now);
              if (picked != null) setState(() => _startsAt = picked);
            },
          ),
          ListTile(
            key: const Key('holiday-until'),
            title: Text(
              _endsAt == null
                  ? l10n.merchantHoursUntilPick
                  : l10n.merchantHoursUntil(
                      '${l10n.formatDate(_endsAt!)} ${l10n.formatTime(_endsAt!)}',
                    ),
            ),
            onTap: () async {
              final picked = await _pickMoment(_startsAt ?? now);
              if (picked != null) setState(() => _endsAt = picked);
            },
          ),
          TextField(
            key: const Key('holiday-message'),
            controller: _message,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: l10n.merchantHoursHolidayMessage,
            ),
          ),
          FilledButton(
            key: const Key('close-holiday'),
            onPressed: _saving || _endsAt == null
                ? null
                : () => _run(
                    (c) => c.closeForHoliday(
                      startsAt: _startsAt,
                      endsAt: _endsAt!,
                      message: _message.text,
                    ),
                  ),
            child: Text(l10n.merchantHoursCloseHoliday),
          ),
        ],
        if (_answer case final answer?)
          Text(answer, key: const Key('holiday-answer')),
      ],
    );
  }
}

/// RA §10: the default prep time within the chooser's limits, and the
/// maximum active orders, off or 1 to 50 (RA §7.4).
class OrderSettingsEditor extends ConsumerStatefulWidget {
  const OrderSettingsEditor({super.key, required this.hours});

  final Hours hours;

  @override
  ConsumerState<OrderSettingsEditor> createState() =>
      _OrderSettingsEditorState();
}

class _OrderSettingsEditorState extends ConsumerState<OrderSettingsEditor> {
  late int _prep = widget.hours.defaultPrepMin;
  late int? _limit = widget.hours.maxActiveOrders;
  bool _saving = false;
  String? _answer;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final refused = await ref
        .read(hoursCommandsProvider)
        .saveOrderSettings(defaultPrepMin: _prep, maxActiveOrders: _limit);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _answer = refusalOf(l10n, refused) ?? l10n.merchantHoursSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hours = widget.hours;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          key: const Key('default-prep'),
          title: Text(l10n.merchantHoursDefaultPrep),
          trailing: DropdownButton<int>(
            value: _prep,
            items: [
              for (
                var minutes = hours.prepFloorMin;
                minutes <= hours.prepCeilingMin;
                minutes++
              )
                DropdownMenuItem(
                  value: minutes,
                  child: Text(l10n.merchantStatusMinutes(minutes)),
                ),
            ],
            onChanged: (value) => setState(() => _prep = value ?? _prep),
          ),
        ),
        ListTile(
          key: const Key('max-active'),
          title: Text(l10n.merchantHoursMaxActiveOrders),
          trailing: DropdownButton<int?>(
            value: _limit,
            items: [
              DropdownMenuItem(child: Text(l10n.merchantHoursNoLimit)),
              for (var count = 1; count <= 50; count++)
                DropdownMenuItem(value: count, child: Text('$count')),
            ],
            onChanged: (value) => setState(() => _limit = value),
          ),
        ),
        FilledButton(
          key: const Key('save-order-settings'),
          onPressed: _saving ? null : _save,
          child: Text(l10n.save),
        ),
        if (_answer case final answer?)
          Text(answer, key: const Key('order-settings-answer')),
      ],
    );
  }
}

/// RA §10, R13: set by admins; «طلب تعديل» comes with support tickets.
class _ReadOnly extends StatelessWidget {
  const _ReadOnly({required this.hours});

  final Hours hours;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final coverage = hours.coverage;
    final commission = hours.commissionBp;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.merchantHoursSetByFoxDrop,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ListTile(
          title: Text(l10n.merchantHoursMinimumOrder),
          trailing: Text(
            l10n.formatMoney(
              hours.minimumOrder.amount,
              hours.minimumOrder.currency,
            ),
          ),
        ),
        ListTile(
          title: Text(l10n.merchantHoursCoverage),
          trailing: Text(
            coverage.radiusMetres != null
                ? l10n.merchantHoursCoverageRadius(
                    l10n.formatDistance(coverage.radiusMetres!),
                  )
                : l10n.merchantHoursCoverageZones(coverage.zoneCount ?? 0),
          ),
        ),
        if (commission != null)
          ListTile(
            title: Text(l10n.merchantHoursCommission),
            trailing: Text(
              l10n.merchantHoursPercent(
                (commission / 100).toStringAsFixed(
                  commission % 100 == 0 ? 0 : 2,
                ),
              ),
            ),
          ),
        ListTile(
          title: Text(l10n.merchantHoursSettlementDay),
          trailing: Text(
            l10n.weekdayName(weekdayNumber(hours.settlementWeekday)),
          ),
        ),
      ],
    );
  }
}
