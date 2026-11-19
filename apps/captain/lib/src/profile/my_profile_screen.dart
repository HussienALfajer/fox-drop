import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'my_profile.dart';

/// CA §12 «ملفي» (slice 2.36c): the data and vehicle read-only with «طلب
/// تعديل» through «الدعم» (§12.1), the links to «المستندات» and «العقد
/// والعدة» (§12.2–12.4), the pay table for the captain's vehicle with the
/// ones announced, «احسب أجري» and the peak windows (§12.5). Unstyled until
/// the design.
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captainMyProfile)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.captainProfileData)),
          ...switch (ref.watch(captainProfileProvider)) {
            AsyncData(:final value) => [
              ListTile(
                key: const Key('profile-id'),
                title: Text(l10n.captainProfileId(value.foxDropId)),
              ),
              ListTile(title: Text(l10n.captainProfileName(value.name))),
              if (value.phone case final phone?)
                ListTile(
                  title: Text(l10n.captainProfilePhone),
                  // A number reads left to right (AP §4.7).
                  subtitle: Text(
                    phone,
                    key: const Key('profile-phone'),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              if (value.neighbourhood case final neighbourhood?)
                ListTile(
                  title: Text(l10n.captainProfileNeighbourhood(neighbourhood)),
                ),
              ListTile(
                key: const Key('profile-vehicle'),
                title: Text(
                  l10n.captainProfileVehicle(
                    profileVehicleText(l10n, value.vehicle),
                  ),
                ),
              ),
              if (value.plateNumber case final plate?)
                ListTile(title: Text(l10n.captainProfilePlate(plate))),
            ],
            AsyncError() => [
              _Retry(() => ref.invalidate(captainProfileProvider)),
            ],
            _ => [const LinearProgressIndicator()],
          },
          ListTile(title: Text(l10n.captainProfileChangeViaSupport)),
          ListTile(
            key: const Key('profile-request-change'),
            title: Text(l10n.captainProfileRequestChange),
            onTap: () => context.push('/support/report?type=data_change'),
          ),
          ListTile(
            key: const Key('profile-documents'),
            title: Text(l10n.captainProfileDocuments),
            onTap: () => context.push('/documents'),
          ),
          ListTile(
            key: const Key('profile-contract'),
            title: Text(l10n.captainProfileContract),
            onTap: () => context.push('/contract'),
          ),
          const _PayTableSection(),
          ListTile(
            key: const Key('profile-peak-bonus'),
            title: Text(l10n.captainPeakWindows),
            onTap: () => context.push('/peak-bonus'),
          ),
        ],
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry(this.retry);

  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      title: Text(l10n.signInError),
      trailing: TextButton(onPressed: retry, child: Text(l10n.captainRetry)),
    );
  }
}

String _money(AppLocalizations l10n, CaptainPayMoneyOutput money) =>
    l10n.formatMoney(money.amount, money.currency);

class _PayTableSection extends ConsumerWidget {
  const _PayTableSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(title: Text(l10n.captainPayTable)),
        ...switch (ref.watch(payTableProvider)) {
          AsyncData(:final value) => [
            if (value.current case final current?)
              ..._rateLines(l10n, 'pay-current', current, value)
            else
              ListTile(
                key: const Key('pay-none'),
                title: Text(l10n.captainPayTableNone),
              ),
            for (final (index, announced) in value.announced.indexed) ...[
              ListTile(
                key: Key('pay-announced-$index'),
                title: Text(
                  l10n.captainPayTableAnnounced(
                    l10n.formatDate(announced.effectiveFrom),
                    l10n.formatTime(announced.effectiveFrom),
                  ),
                ),
              ),
              ..._announcedLines(
                l10n,
                'pay-announced-$index',
                announced,
                value,
              ),
            ],
            if (value.current != null || value.announced.isNotEmpty)
              const _Calculator(),
          ],
          AsyncError() => [_Retry(() => ref.invalidate(payTableProvider))],
          _ => [const LinearProgressIndicator()],
        },
      ],
    );
  }

  List<Widget> _rateLines(
    AppLocalizations l10n,
    String key,
    CaptainPayTableDtoOutputCurrent rate,
    PayTable table,
  ) => _lines(
    l10n,
    key,
    base: rate.basePay,
    includedMetres: rate.includedMetres,
    perExtraKm: rate.perExtraKm,
    waiting: rate.waitingPerMinute,
    minimum: rate.minimumPay,
    thresholdMin: table.waitingThresholdMin,
  );

  List<Widget> _announcedLines(
    AppLocalizations l10n,
    String key,
    CaptainPayTableDtoOutputAnnouncedInner rate,
    PayTable table,
  ) => _lines(
    l10n,
    key,
    base: rate.basePay,
    includedMetres: rate.includedMetres,
    perExtraKm: rate.perExtraKm,
    waiting: rate.waitingPerMinute,
    minimum: rate.minimumPay,
    thresholdMin: table.waitingThresholdMin,
  );

  List<Widget> _lines(
    AppLocalizations l10n,
    String key, {
    required CaptainPayMoneyOutput base,
    required int includedMetres,
    required CaptainPayMoneyOutput perExtraKm,
    required CaptainPayMoneyOutput waiting,
    required CaptainPayMoneyOutput minimum,
    required int thresholdMin,
  }) => [
    ListTile(
      key: Key('$key-base'),
      title: Text(
        l10n.captainPayTableBase(
          _money(l10n, base),
          includedText(l10n, includedMetres),
        ),
      ),
    ),
    ListTile(
      key: Key('$key-per-km'),
      title: Text(l10n.captainPayTablePerKm(_money(l10n, perExtraKm))),
    ),
    ListTile(
      key: Key('$key-waiting'),
      title: Text(
        l10n.captainPayTableWaiting(
          _money(l10n, waiting),
          l10n.durationMinutes(thresholdMin),
        ),
      ),
    ),
    ListTile(
      key: Key('$key-minimum'),
      title: Text(l10n.captainPayTableMinimum(_money(l10n, minimum))),
    ),
  ];
}

/// «احسب أجري» (CA §12.5): a distance in km and the minutes waited, priced
/// by the server with each table.
class _Calculator extends ConsumerStatefulWidget {
  const _Calculator();

  @override
  ConsumerState<_Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends ConsumerState<_Calculator> {
  final _distance = TextEditingController();
  final _waited = TextEditingController();
  bool _badDistance = false;
  bool _badWaited = false;
  bool _sending = false;
  PayCalculation? _result;

  @override
  void dispose() {
    _distance.dispose();
    _waited.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final metres = metresOf(_distance.text);
    final waited = waitedOf(_waited.text);
    setState(() {
      _badDistance = metres == null;
      _badWaited = waited == null;
    });
    if (metres == null || waited == null) return;
    setState(() => _sending = true);
    try {
      final result = await ref.read(payCalculatorProvider)(metres, waited);
      if (mounted) setState(() => _result = result);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).captainPayCalculateFailed),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _result;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.captainPayCalculator),
          TextField(
            key: const Key('pay-distance'),
            controller: _distance,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.captainPayDistanceField,
              errorText: _badDistance ? l10n.captainPayInvalidDistance : null,
            ),
          ),
          TextField(
            key: const Key('pay-waited'),
            controller: _waited,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.captainPayWaitedField,
              errorText: _badWaited ? l10n.captainPayInvalidWaited : null,
            ),
          ),
          FilledButton(
            key: const Key('pay-calculate'),
            onPressed: _sending ? null : _calculate,
            child: Text(l10n.captainPayCalculate),
          ),
          if (result != null) ...[
            if (result.current case final current?)
              ..._parts(
                l10n,
                'pay-result',
                base: current.base_,
                distance: current.distance,
                topUp: current.topUp,
                waiting: current.waiting,
                total: current.total,
              ),
            for (final (index, announced) in result.announced.indexed) ...[
              Text(
                l10n.captainPayByAnnounced(
                  l10n.formatDate(announced.effectiveFrom),
                  l10n.formatTime(announced.effectiveFrom),
                ),
              ),
              ..._parts(
                l10n,
                'pay-result-announced-$index',
                base: announced.base_,
                distance: announced.distance,
                topUp: announced.topUp,
                waiting: announced.waiting,
                total: announced.total,
              ),
            ],
          ],
        ],
      ),
    );
  }

  List<Widget> _parts(
    AppLocalizations l10n,
    String key, {
    required CaptainPayMoneyOutput base,
    required CaptainPayMoneyOutput distance,
    required CaptainPayMoneyOutput topUp,
    required CaptainPayMoneyOutput waiting,
    required CaptainPayMoneyOutput total,
  }) => [
    Text(l10n.captainPayBase(_money(l10n, base))),
    Text(l10n.captainPayDistance(_money(l10n, distance))),
    if (topUp.amount != '0') Text(l10n.captainPayTopUp(_money(l10n, topUp))),
    if (waiting.amount != '0')
      Text(l10n.captainPayWaiting(_money(l10n, waiting))),
    Text(key: Key('$key-total'), l10n.captainPayTotal(_money(l10n, total))),
  ];
}
