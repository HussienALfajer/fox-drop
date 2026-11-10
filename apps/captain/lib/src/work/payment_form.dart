import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content.dart';
import 'commands.dart';
import 'door_payment.dart';
import 'location.dart';
import 'order_view.dart';
import 'texts.dart';
import 'work.dart';

/// The door payment (CA §9.7): the amount due and its equivalents, what the
/// captain received in one or more currencies, the change, a shortfall's
/// reason (K16), then «تم التسليم» (CA §9.8). The server checks the lines
/// with the order's rates; the app computes the change only for one
/// currency, which needs no rate. Unstyled until the design.
class PaymentForm extends ConsumerStatefulWidget {
  const PaymentForm({
    super.key,
    required this.order,
    this.outcomeAmount,
    this.outcomeEquivalents = const [],
  });

  final ActiveOrder order;

  /// CA §9.10 (K9): the amount operations set to collect with an outcome,
  /// in the base currency; the form records it instead of a delivery,
  /// with no radius.
  final Money? outcomeAmount;

  /// That amount in the other accepted currencies (CA §9.7 items 1-2).
  final List<Money> outcomeEquivalents;

  @override
  ConsumerState<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<PaymentForm> {
  final _received = <String, TextEditingController>{};
  final _change = <String, TextEditingController>{};
  ReasonChoice? _shortReason;
  final _shortNote = TextEditingController();

  /// The server's answer to the last «تم التسليم», when it refused.
  Notice? _refused;
  bool _invalid = false;
  bool _reasonMissing = false;

  ActiveOrder get _order => widget.order;

  Money _collect(ActiveOrder order) =>
      widget.outcomeAmount ??
      Money(order.collect.amount, order.collect.currency);

  /// The amount due the screen shows, which the command carries (CA §9.7
  /// item 4): a change by operations shows «تغيّر المبلغ المطلوب إلى …».
  late Money _amountDue = _collect(widget.order);

  @override
  void didUpdateWidget(PaymentForm old) {
    super.didUpdateWidget(old);
    final now = _collect(widget.order);
    if (now != _amountDue) {
      _amountDue = now;
      _refused = AmountDueChanged(now);
    }
  }

  List<Money> get _due => dueIn(
    _amountDue,
    widget.outcomeAmount != null
        ? widget.outcomeEquivalents
        : [
            for (final e in _order.customer.collectEquivalents.nonNulls)
              Money(e.amount, e.currency),
          ],
    _order.customer.payIn,
  );

  TextEditingController _field(
    Map<String, TextEditingController> fields,
    String currency,
  ) => fields.putIfAbsent(currency, TextEditingController.new);

  @override
  void dispose() {
    for (final c in [..._received.values, ..._change.values, _shortNote]) {
      c.dispose();
    }
    super.dispose();
  }

  /// The typed lines, or null when one is not an amount.
  List<Money>? _lines(Map<String, TextEditingController> fields) {
    final lines = <Money>[];
    for (final MapEntry(key: currency, value: field) in fields.entries) {
      final text = field.text.trim();
      // Nothing, or a zero the captain typed in a change field.
      if (text.isEmpty || RegExp(r'^0+(?:[.,]0+)?$').hasMatch(text)) continue;
      final minor = minorOf(field.text);
      if (minor == null) return null;
      lines.add(Money(minor, currency));
    }
    return lines;
  }

  /// A one-tap exact amount in a currency (CA §9.7 item 2).
  void _fillExact(Money due) {
    setState(() {
      for (final field in _received.values) {
        field.clear();
      }
      _field(_received, due.currency).text = majorOf(due.amount);
      _onReceived();
    });
  }

  /// CA §9.7 item 3: the change in the base currency, when the money came
  /// in it.
  void _onReceived() {
    _refused = null;
    final received = _lines(_received);
    final change = received == null ? null : changeDue(received, _amountDue);
    for (final field in _change.values) {
      field.clear();
    }
    if (change != null && change.minor > BigInt.zero) {
      _field(_change, change.currency).text = majorOf(change.amount);
    }
  }

  // A shortfall is the server's to find: a gap within half the largest
  // rounding unit of the lines' currencies is rounding (AP §8.6), and only
  // the server has the rounding units and rates.
  Future<void> _deliver() async {
    final received = _lines(_received);
    final change = _lines(_change);
    if (received == null || change == null || received.isEmpty) {
      setState(() => _invalid = true);
      return;
    }
    setState(() => _invalid = false);
    final needsReason = _refused is ShortfallReasonRequired;
    final reason = needsReason && _shortReason != null
        ? Reason(
            _shortReason!.code,
            _shortReason!.takesNote && _shortNote.text.trim().isNotEmpty
                ? _shortNote.text.trim()
                : null,
          )
        : null;
    if (needsReason &&
        (reason == null || (_shortReason!.needsNote && reason.note == null))) {
      setState(() => _reasonMissing = true);
      return;
    }
    setState(() => _reasonMissing = false);
    final commands = ref.read(commandsProvider.notifier);
    if (widget.outcomeAmount != null) {
      final notice = await commands.collectOutcome(
        _order.id,
        DoorPayment(
          received: received,
          change: change,
          amountDue: _amountDue,
          shortfall: reason,
        ),
      );
      if (!mounted) return;
      if (notice is ReasonChanged) {
        setState(() => _shortReason = null);
        showNotice(context, notice);
        return;
      }
      setState(() => _refused = notice);
      return;
    }
    final pin = _order.customer.location;
    final fix = ref.read(locationTrackerProvider).latest;
    final distance = fix?.metresTo(
      pin.latitude.toDouble(),
      pin.longitude.toDouble(),
    );
    // K4: a reason given at the arrival covers the delivery.
    final covered = _order.customer.arrival?.awayReason != null;
    Reason? away;
    if (!covered &&
        distance != null &&
        distance > _order.radii.customerMetres) {
      away = await pickAway(context, ref);
      if (away == null) return;
    }
    DoorPayment payment() => DoorPayment(
      received: received,
      change: change,
      amountDue: _amountDue,
      shortfall: reason,
    );
    var notice = await commands.deliver(_order.id, payment(), away);
    if (notice is TooFar && away == null && mounted) {
      away = await pickAway(context, ref);
      if (away == null) return;
      notice = await commands.deliver(_order.id, payment(), away);
    }
    if (!mounted) return;
    if (notice is ReasonChanged) {
      // The list was read again: the captain chooses from it, and the
      // shortfall the server asked a reason for still stands.
      setState(() => _shortReason = null);
      showNotice(context, notice);
      return;
    }
    setState(() => _refused = notice);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final due = _due;
    final received = _lines(_received) ?? const <Money>[];
    final computed = changeDue(received, _amountDue);
    final refused = _refused;
    final shortfall = refused is ShortfallReasonRequired
        ? refused.shortfall
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.captainAmountDue),
        Text(
          l10n.moneyOf(_amountDue),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          due
              .where((m) => m.currency != _amountDue.currency)
              .map(l10n.moneyOf)
              .join(' · '),
        ),
        const SizedBox(height: 8),
        Text(l10n.captainAmountReceived),
        Wrap(
          spacing: 8,
          children: [
            for (final each in due)
              OutlinedButton(
                key: Key('exact-${each.currency}'),
                onPressed: () => _fillExact(each),
                child: Text(l10n.moneyOf(each)),
              ),
          ],
        ),
        for (final each in due)
          TextField(
            key: Key('received-${each.currency}'),
            controller: _field(_received, each.currency),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.currencySymbol(each.currency),
            ),
            onChanged: (_) => setState(_onReceived),
          ),
        if (computed != null && computed.minor > BigInt.zero)
          Text(l10n.captainChangeDue(l10n.moneyOf(computed))),
        Text(l10n.captainChange),
        for (final each in due)
          TextField(
            key: Key('change-${each.currency}'),
            controller: _field(_change, each.currency),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.currencySymbol(each.currency),
            ),
            onChanged: (_) => setState(() => _refused = null),
          ),
        Text(l10n.captainTip),
        if (_invalid) Text(l10n.captainInvalidAmount),
        if (shortfall != null) ...[
          Text(l10n.captainShortBy(l10n.moneyOf(shortfall))),
          // K16, from Content's shortfall list.
          switch (ref.watch(contentProvider)) {
            AsyncData(value: final content) => RadioGroup<String>(
              groupValue: _shortReason?.code,
              onChanged: (code) => setState(
                () => _shortReason = content.shortfall.firstWhere(
                  (reason) => reason.code == code,
                ),
              ),
              child: Column(
                children: [
                  for (final reason in content.shortfall)
                    RadioListTile<String>(
                      value: reason.code,
                      title: Text(reason.label),
                    ),
                ],
              ),
            ),
            AsyncError() => TextButton(
              onPressed: () => ref.invalidate(contentProvider),
              child: Text(l10n.contentFailed),
            ),
            _ => const LinearProgressIndicator(),
          },
          if (_shortReason?.takesNote == true)
            TextField(
              key: const Key('shortfall-note'),
              controller: _shortNote,
              maxLength: 200,
              decoration: InputDecoration(labelText: l10n.captainOtherHint),
            ),
        ],
        if (_reasonMissing) Text(l10n.captainChooseReason),
        if (refused != null && refused is! ShortfallReasonRequired)
          Text(l10n.noticeText(refused)),
        _DeliverButton(order: _order, onPressed: _deliver),
      ],
    );
  }
}

class _DeliverButton extends ConsumerWidget {
  const _DeliverButton({required this.order, required this.onPressed});

  final ActiveOrder order;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sending = ref.watch(commandsProvider).contains(order.id);
    return FilledButton(
      onPressed: sending ? null : onPressed,
      child: Text(sending ? l10n.captainSending : l10n.captainDelivered),
    );
  }
}
