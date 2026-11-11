import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../content.dart';
import 'commands.dart';
import 'door.dart';
import 'door_payment.dart';
import 'location.dart';
import 'payment_form.dart';
import 'reason_sheet.dart';
import 'texts.dart';
import 'work.dart';

/// The active order (CA §9.1): the progress through the four steps and the
/// step's own screen, each with one main button. Unstyled until the design;
/// the map and the route wait for Phase 2; «مشكلة» is `ProblemBar` above it
/// (slice 2.13b) and «طوارئ» waits for slice 2.13c.
class OrderView extends ConsumerWidget {
  const OrderView({super.key, required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final step = stepOf(order);
    final refused = refusedRequest(order);
    // CA §9.10 (K9): operations ended the order with an amount to collect;
    // the payment screen for it replaces the step.
    final collect = order.outcomeToCollect;
    if (collect != null) {
      return ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(l10n.captainAwaitingCollection),
          Text(l10n.captainOrderItems(order.number, order.itemCount)),
          Text(
            l10n.captainOutcomeCollect(
              collectOutcomeText(l10n, collect.outcome),
              l10n.formatMoney(collect.amount.amount, collect.amount.currency),
            ),
          ),
          PaymentForm(
            key: ValueKey('outcome-${order.id}'),
            order: order,
            outcomeAmount: Money(
              collect.amount.amount,
              collect.amount.currency,
            ),
            outcomeEquivalents: [
              for (final e in collect.equivalents.nonNulls)
                Money(e.amount, e.currency),
            ],
          ),
        ],
      );
    }
    // CA §9.10.1 (slice 2.12b): the order's handover replaces the steps:
    // the first captain waits, the second goes to them.
    if (giving(order) case final handover?) {
      return _HandingOver(order: order, handover: handover);
    }
    if (receiving(order) case final handover?) {
      return _Receiving(order: order, handover: handover);
    }
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(l10n.captainStep(step, l10n.stepName(step))),
        LinearProgressIndicator(value: step / 4),
        const SizedBox(height: 8),
        Text(l10n.captainOrderItems(order.number, order.itemCount)),
        switch (step) {
          1 => _ToRestaurant(order: order),
          // A refusal for missing items, or other lines, starts the item
          // check again (C7).
          2 => _AtRestaurant(
            key: ValueKey(
              [
                order.id,
                if (refused?.outcome == RequestOutcome.incomplete) refused!.id,
                for (final line in order.lines)
                  '${line.quantity} ${line.name} ${line.options.map((o) => o.name).join(',')} ${line.note}',
              ].join('|'),
            ),
            order: order,
          ),
          3 => _ToCustomer(order: order),
          _ => _AtCustomer(order: order),
        },
      ],
    );
  }
}

/// Shows a refusal's text.
void showNotice(BuildContext context, Notice? notice) {
  if (notice == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context).noticeText(notice))),
  );
}

Future<void> _open(WidgetRef ref, Uri uri) async {
  await ref.read(captainAuth.launch)(uri);
}

/// «ابدأ الملاحة» opens Google Maps to the point (CA §4.6).
Uri navigationTo(num latitude, num longitude) => Uri.https(
  'www.google.com',
  '/maps/dir/',
  {'api': '1', 'destination': '$latitude,$longitude'},
);

/// The latest fix's distance to a point, or null without one.
int? _distanceTo(WidgetRef ref, num latitude, num longitude) => ref
    .watch(latestFixProvider)
    .value
    ?.metresTo(latitude.toDouble(), longitude.toDouble());

class _MainButton extends ConsumerWidget {
  const _MainButton({
    required this.order,
    required this.label,
    required this.onPressed,
  });

  final ActiveOrder order;
  final String label;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sending = ref.watch(commandsProvider).contains(order.id);
    final l10n = AppLocalizations.of(context);
    final press = onPressed;
    return FilledButton(
      onPressed: sending || press == null ? null : () => press(),
      child: Text(sending ? l10n.captainSending : label),
    );
  }
}

/// Step 1 (CA §9.2): the restaurant, the preparation, «تدفع للمطعم», and
/// «وصلت إلى المطعم» within the radius (C6).
class _ToRestaurant extends ConsumerWidget {
  const _ToRestaurant({required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(tickProvider);
    final clock = ref.watch(serverClockProvider);
    final restaurant = order.restaurant;
    final location = restaurant.location;
    final fix = ref.watch(latestFixProvider).value;
    final distance = _distanceTo(ref, location.latitude, location.longitude);
    final within = distance != null && distance <= order.radii.restaurantMetres;
    final weak = fix != null && fix.accuracyMetres > weakGpsMetres;
    final preparation = order.preparation;
    final phone = restaurant.phone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(restaurant.name),
        if (restaurant.address case final address?) Text(address),
        if (distance != null)
          Text(l10n.captainDistanceAway(l10n.formatDistance(distance))),
        Text(
          preparation.ready
              ? l10n.captainReady
              : l10n.captainPreparing(
                  (clock.until(preparation.prepDueAt).inSeconds / 60).ceil(),
                ),
        ),
        Text(
          l10n.captainPayToRestaurant(
            l10n.formatMoney(
              order.pickupPayment.amount,
              order.pickupPayment.currency,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () =>
              _open(ref, navigationTo(location.latitude, location.longitude)),
          child: Text(l10n.captainStartNavigation),
        ),
        if (phone != null)
          OutlinedButton(
            onPressed: () => _open(ref, Uri(scheme: 'tel', path: phone)),
            child: Text(l10n.captainCallRestaurant),
          ),
        if (weak) Text(l10n.captainWeakGps),
        if (within && !weak) Text(l10n.captainArrivedQuestion),
        if (!within) Text(l10n.captainGetCloser),
        _MainButton(
          order: order,
          label: l10n.captainArrivedAtRestaurant,
          onPressed: within && !weak
              ? () async {
                  final notice = await ref
                      .read(commandsProvider.notifier)
                      .arrive(order.id);
                  if (context.mounted) showNotice(context, notice);
                }
              : null,
        ),
      ],
    );
  }
}

/// Step 2 (CA §9.3–9.4): the waiting timer, the item check, the payment and
/// the pickup request with its answer.
class _AtRestaurant extends ConsumerStatefulWidget {
  const _AtRestaurant({super.key, required this.order});

  final ActiveOrder order;

  @override
  ConsumerState<_AtRestaurant> createState() => _AtRestaurantState();
}

class _AtRestaurantState extends ConsumerState<_AtRestaurant> {
  final _ticked = <int>{};

  /// C8: the captain splits or edits the proposed line, one field per
  /// currency the restaurant accepts; null while the proposal stands.
  Map<String, TextEditingController>? _split;
  bool _invalid = false;

  @override
  void dispose() {
    for (final field in _split?.values ?? const <TextEditingController>[]) {
      field.dispose();
    }
    super.dispose();
  }

  /// The restaurant's currencies changed while the split was open: a field
  /// per currency it accepts now, keeping what was typed in the others.
  @override
  void didUpdateWidget(_AtRestaurant old) {
    super.didUpdateWidget(old);
    final split = _split;
    if (split == null) return;
    final now = {
      for (final line in widget.order.pickup.currencies.nonNulls) line.currency,
    };
    for (final gone in split.keys.where((c) => !now.contains(c)).toList()) {
      split.remove(gone)!.dispose();
    }
    for (final added in now) {
      split.putIfAbsent(added, TextEditingController.new);
    }
  }

  void _startSplit(List<Money> proposed) {
    setState(() {
      _split = {
        for (final line in widget.order.pickup.currencies.nonNulls)
          line.currency: TextEditingController(
            text: [
              for (final p in proposed)
                if (p.currency == line.currency) majorOf(p.amount),
            ].firstOrNull,
          ),
      };
    });
  }

  /// The typed lines, or null when one is not an amount.
  List<Money>? _typed() {
    final lines = <Money>[];
    for (final MapEntry(key: currency, value: field) in _split!.entries) {
      final text = field.text.trim();
      if (text.isEmpty || RegExp(r'^0+(?:[.,]0+)?$').hasMatch(text)) continue;
      final minor = minorOf(text);
      if (minor == null) return null;
      lines.add(Money(minor, currency));
    }
    return lines.isEmpty ? null : lines;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.watch(tickProvider);
    final clock = ref.watch(serverClockProvider);
    final order = widget.order;
    final open = openRequest(order);
    final refused = refusedRequest(order);
    final arrival = order.arrival;
    final lines = order.lines.toList();
    final allTicked = _ticked.length == lines.length;
    final proposed = [
      for (final line in order.pickup.proposedLines.nonNulls)
        Money(line.amount, line.currency),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(order.restaurant.name),
        if (arrival != null)
          Text(
            l10n.captainWaitingSince(
              l10n.durationMinutes(clock.since(arrival.at).inMinutes),
            ),
          ),
        if (order.preparation.ready) Text(l10n.captainOrderReadyNow),
        if (open != null) ...[
          Text(l10n.captainAwaitingRestaurant),
          Text(l10n.formatCountdown(clock.until(open.confirmBy))),
        ] else ...[
          if (refused != null) Text(l10n.refusalText(refused)),
          Text(l10n.captainItemsResponsibility),
          for (final (index, line) in lines.indexed)
            CheckboxListTile(
              value: _ticked.contains(index),
              onChanged: (on) => setState(
                () => on == true ? _ticked.add(index) : _ticked.remove(index),
              ),
              title: Text(l10n.captainLine(line.quantity, line.name)),
              subtitle: Text(
                [...line.options.map((o) => o.name), ?line.note].join(' · '),
              ),
            ),
          if (order.note case final note?) Text(l10n.captainNote(note)),
          // CA §9 step 2: an item-unavailable report holds the pickup until
          // operations edit, cancel or close it; an edit that added items,
          // until the restaurant acknowledges it.
          if (pickupBlocked(order))
            order.itemReportOpen
                ? Text(
                    l10n.captainWaitingForOrderEdit,
                    key: const Key('waiting-for-order-edit'),
                  )
                : Text(
                    l10n.captainWaitingForEditAcknowledgement,
                    key: const Key('waiting-for-edit-acknowledgement'),
                  )
          // The payment shows once every item is ticked (C7).
          else if (allTicked) ...[
            Text(
              l10n.captainPayRestaurant(proposed.map(l10n.moneyOf).join(' + ')),
            ),
            if (_split case final split?) ...[
              for (final line in order.pickup.currencies.nonNulls)
                TextField(
                  controller: split[line.currency],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.captainPickupIn(
                      l10n.currencySymbol(line.currency),
                      l10n.formatMoney(line.amount, line.currency),
                    ),
                  ),
                  onChanged: (_) => setState(() => _invalid = false),
                ),
              if (_invalid) Text(l10n.captainInvalidAmount),
            ] else if (order.pickup.currencies.length > 1)
              TextButton(
                onPressed: () => _startSplit(proposed),
                child: Text(l10n.captainSplitPickup),
              ),
            _MainButton(
              order: order,
              label: l10n.captainPaidAndPickedUp,
              onPressed: () async {
                final lines = _split == null ? proposed : _typed();
                if (lines == null) {
                  setState(() => _invalid = true);
                  return;
                }
                final notice = await ref
                    .read(commandsProvider.notifier)
                    .requestPickup(order.id, lines);
                if (context.mounted) showNotice(context, notice);
              },
            ),
          ],
        ],
      ],
    );
  }
}

/// The customer block of steps 3 and 4 (CA §9.5): shown after acceptance
/// only (C2); the number goes to the dialer and WhatsApp, never on screen.
class _CustomerBlock extends ConsumerWidget {
  const _CustomerBlock({required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customer = order.customer;
    final address = customer.address;
    final phone = customer.phone;
    final collect = order.collect;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (customer.name case final name?) Text(name),
        Text('${address.neighbourhood} · ${address.street}'),
        if (address.floor case final floor?) Text(l10n.captainFloor(floor)),
        Text(address.landmark),
        if (address.directions case final directions?) Text(directions),
        if (order.note case final note?) Text(l10n.captainNote(note)),
        Text(
          l10n.captainCollectFromCustomer(
            [
              l10n.formatMoney(collect.amount, collect.currency),
              for (final each in customer.collectEquivalents.nonNulls)
                l10n.formatMoney(each.amount, each.currency),
            ].join(' · '),
          ),
        ),
        if (customer.payIn case final payIn?)
          Text(l10n.captainPayIn(l10n.currencySymbol(payIn))),
        Text(l10n.captainPromisedBefore(l10n.formatTime(customer.promisedAt))),
        OutlinedButton(
          onPressed: () => _open(
            ref,
            navigationTo(
              customer.location.latitude,
              customer.location.longitude,
            ),
          ),
          child: Text(l10n.captainStartNavigation),
        ),
        if (phone != null) ...[
          OutlinedButton(
            onPressed: () => _open(ref, Uri(scheme: 'tel', path: phone)),
            child: Text(l10n.captainCallCustomer),
          ),
          OutlinedButton(
            onPressed: () => _open(
              ref,
              Uri.https('wa.me', '/${phone.replaceAll(RegExp(r'\D'), '')}'),
            ),
            child: Text(l10n.captainWhatsAppCustomer),
          ),
        ],
      ],
    );
  }
}

/// The reason for an arrival or a delivery away from the pin (K4, C9),
/// from Content's captain_away list; null when dismissed or not loaded.
Future<Reason?> pickAway(BuildContext context, WidgetRef ref) async {
  final title = AppLocalizations.of(context).captainAwayTitle;
  final content = await readContent(context, ref);
  if (content == null || !context.mounted) return null;
  return pickReason(context, title: title, reasons: content.away);
}

/// Step 3 (CA §9.5–9.6): to the customer, then «وصلت», with a reason first
/// beyond the radius (K4).
class _ToCustomer extends ConsumerWidget {
  const _ToCustomer({required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pin = order.customer.location;
    final distance = _distanceTo(ref, pin.latitude, pin.longitude);
    final request = order.pickup.request;
    Future<void> arrive() async {
      final commands = ref.read(commandsProvider.notifier);
      Reason? away;
      if (distance != null && distance > order.radii.customerMetres) {
        away = await pickAway(context, ref);
        if (away == null) return;
      }
      var notice = await commands.arriveAtCustomer(order.id, away);
      // The server measured farther than the phone did.
      if (notice is TooFar && away == null && context.mounted) {
        away = await pickAway(context, ref);
        if (away == null) return;
        notice = await commands.arriveAtCustomer(order.id, away);
      }
      if (context.mounted) showNotice(context, notice);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          request?.outcome == RequestOutcome.operations
              ? l10n.captainOpsConfirmedPickup
              : l10n.captainPickedUp,
        ),
        if (order.pickup.disputedAt != null) Text(l10n.captainPickupDisputed),
        if (distance != null)
          Text(l10n.captainDistanceAway(l10n.formatDistance(distance))),
        _CustomerBlock(order: order),
        _MainButton(
          order: order,
          label: l10n.captainArrivedAtCustomer,
          onPressed: arrive,
        ),
      ],
    );
  }
}

/// Step 4 (CA §9.6–9.8): at the customer, the door payment and «تم التسليم».
class _AtCustomer extends ConsumerWidget {
  const _AtCustomer({required this.order});

  final ActiveOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CustomerBlock(order: order),
        // CA §9.9: the customer not answering; the payment stays open.
        DoorPanel(order: order),
        const Divider(),
        PaymentForm(key: ValueKey('${order.id} payment'), order: order),
      ],
    );
  }
}

/// While a handover is open, the active order is read again every 15
/// seconds, so the other captain's position stays live (CA §9.10.1).
void _followOtherCaptain(WidgetRef ref) {
  ref.listen(tickProvider, (_, tick) {
    if ((tick.value ?? 0) % 15 == 14) ref.read(workFeedProvider)?.refresh();
  });
}

/// The other captain of a handover: their distance and the call button.
List<Widget> _otherCaptain(
  BuildContext context,
  WidgetRef ref,
  Handover handover, {
  required bool navigate,
}) {
  final l10n = AppLocalizations.of(context);
  final other = handover.captain;
  final location = other.location;
  final phone = other.phone;
  final distance = location == null
      ? null
      : _distanceTo(ref, location.latitude, location.longitude);
  return [
    if (location == null)
      Text(l10n.captainCaptainLocationUnknown)
    else if (distance != null)
      Text(
        l10n.captainOtherCaptainAway(other.name, l10n.formatDistance(distance)),
      ),
    if (navigate && location != null)
      OutlinedButton(
        onPressed: () =>
            _open(ref, navigationTo(location.latitude, location.longitude)),
        child: Text(l10n.captainStartNavigation),
      ),
    if (phone != null)
      OutlinedButton(
        onPressed: () => _open(ref, Uri(scheme: 'tel', path: phone)),
        child: Text(l10n.captainCallCaptain),
      ),
  ];
}

/// CA §9.10.1: the first captain waits where they are for the second, whose
/// live position shows, with a call button; their own steps wait.
class _HandingOver extends ConsumerWidget {
  const _HandingOver({required this.order, required this.handover});

  final ActiveOrder order;
  final Handover handover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    _followOtherCaptain(ref);
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(l10n.captainOrderItems(order.number, order.itemCount)),
        Text(
          handover.assigned
              ? l10n.captainHandoverWait(handover.captain.name)
              : l10n.captainHandoverOffered,
          key: const Key('handover-wait'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (handover.assigned)
          ..._otherCaptain(context, ref, handover, navigate: false),
      ],
    );
  }
}

/// CA §9.10.1: the second captain's step 1, to the first captain's live
/// position; nothing to pay; «استلمت الطلب من الكابتن {الاسم}» within
/// captain.customer_radius_m of them.
class _Receiving extends ConsumerWidget {
  const _Receiving({required this.order, required this.handover});

  final ActiveOrder order;
  final Handover handover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    _followOtherCaptain(ref);
    final location = handover.captain.location;
    final distance = location == null
        ? null
        : _distanceTo(ref, location.latitude, location.longitude);
    final within = distance != null && distance <= order.radii.customerMetres;
    final collect = order.collect;
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(l10n.captainStep(1, l10n.captainHandoverOffer)),
        Text(l10n.captainOrderItems(order.number, order.itemCount)),
        Text(l10n.captainHandoverFromName(handover.captain.name)),
        ..._otherCaptain(context, ref, handover, navigate: true),
        Text(l10n.captainPayNothing),
        Text(
          l10n.captainCollectFromCustomer(
            l10n.formatMoney(collect.amount, collect.currency),
          ),
        ),
        Text(order.customer.address.neighbourhood),
        if (!within && location != null) Text(l10n.captainGetCloserToCaptain),
        _MainButton(
          order: order,
          label: l10n.captainReceivedFromCaptain(handover.captain.name),
          onPressed: within
              ? () async {
                  final notice = await ref
                      .read(commandsProvider.notifier)
                      .receiveHandover(order.id);
                  if (context.mounted) showNotice(context, notice);
                }
              : null,
        ),
      ],
    );
  }
}

/// The signed-in captain's sign-out, offered only while offline.
class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: () => ref.read(captainAuth.session.notifier).signOut(),
    child: Text(AppLocalizations.of(context).signOut),
  );
}
