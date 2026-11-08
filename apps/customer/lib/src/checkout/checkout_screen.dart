import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth.dart';
import '../content.dart';
import '../cart/cart.dart';
import '../device.dart';
import '../location/delivery_point.dart';
import '../location/position.dart';
import '../notifications/permission.dart';
import '../profile/profile.dart';
import '../router.dart';
import 'checkout.dart';
import 'place_order.dart';
import 'problems.dart';
import 'quote.dart';
import 'quote_widgets.dart';

/// Checkout (CU §10.3–10.7), top to bottom: the problems, the address, the
/// note, «سأدفع بـ», the payment, the estimate, the money and «تأكيد الطلب».
/// Codes wait for Phase 2 (owner decision 2026-11-06). Unstyled until the
/// design.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  Set<FormProblem> _problems = const {};
  bool _preselected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // An earlier attempt's failure is not shown again, and an old cart
      // empties (CU §10.1).
      ref.read(placeOrderProvider.notifier).done();
      ref.read(cartProvider.notifier).current();
      _preselect();
    });
  }

  /// CU §10.3 item 1: the saved address the point came from, or one within
  /// 200 m, or else the point as an unsaved address.
  Future<void> _preselect() async {
    final saved = await ref.read(savedAddressesProvider.future);
    if (!mounted || _preselected) return;
    _preselected = true;
    final point = ref.read(deliveryPointProvider);
    if (point is! PointChecked) return;
    final address = preselectedAddress(point, saved);
    if (address == null) return;
    _chooseSaved(address);
  }

  void _chooseSaved(SavedAddress address) {
    final point = ref.read(deliveryPointProvider);
    if (point is PointChecked && point.addressId == address.id) return;
    ref
        .read(deliveryPointProvider.notifier)
        .useAddress(
          address.id,
          GeoPoint(
            address.location.latitude.toDouble(),
            address.location.longitude.toDouble(),
          ),
        );
  }

  void _useCurrentLocation() =>
      ref.read(deliveryPointProvider.notifier).useCurrentLocation();

  Future<void> _confirm(Quote quote, Cart cart, PointChecked point) async {
    final session = ref.read(customerAuth.session).value;
    if (session is! SignedIn) {
      // CU §10.7 item 2: a guest signs in here and comes back.
      context.go(signInFrom('/checkout'));
      return;
    }
    // «أكمل بياناتك» comes before the first order (CU §5.3): the terms are
    // accepted there, and the server does not check them yet.
    final bool completed;
    try {
      completed = (await ref.read(profileProvider.future))?.completed ?? false;
    } on Object {
      ref.invalidate(profileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).statusError)),
        );
      }
      return;
    }
    if (!completed) {
      if (mounted) {
        context.go(
          Uri(
            path: '/complete-profile',
            queryParameters: {'from': '/checkout'},
          ).toString(),
        );
      }
      return;
    }
    final addressId = point.addressId;
    final form = ref.read(checkoutFormProvider);
    final problems = formProblems(form, unsaved: addressId == null);
    setState(() => _problems = problems);
    if (problems.isNotEmpty) return;
    final far = await farPinMetres(
      ref.read(positionSourceProvider),
      point.point,
    );
    if (far != null) {
      if (!mounted) return;
      final send = await showDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(l10n.customerFarPinTitle),
            content: Text(
              l10n.customerFarPinBody(l10n.formatDistance(far.round())),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.customerChangeAddress),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.customerFarPinSend),
              ),
            ],
          );
        },
      );
      if (send != true) return;
    }
    // CU §10.7 item 4 (Q11): the first order asks for notifications; the
    // order goes whatever the answer.
    final ask = ref.read(notificationAskProvider);
    if (await ask.due()) {
      if (!mounted) return;
      final allow = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            content: Text(l10n.customerNotificationsAsk),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.customerNotificationsNotNow),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.customerNotificationsAllow),
              ),
            ],
          );
        },
      );
      await ask.answer(allow: allow ?? false);
      if (!mounted) return;
    }
    await ref
        .read(placeOrderProvider.notifier)
        .place(
          PlaceCommand(
            cart: cart,
            quoteVersion: quote.version,
            point: point.point,
            addressId: addressId,
            form: form,
            payIn: ref.read(payInProvider).value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(cartProvider).value?.cart;
    final point = ref.watch(deliveryPointProvider);
    final quote = ref.watch(quoteProvider);
    final place = ref.watch(placeOrderProvider);
    final now = ref.watch(clockProvider)();
    final q = quote.value;
    final problems = q == null || cart == null
        ? const <ProblemView>[]
        : problemViews(l10n, q, cart, now);
    final sending = place is PlaceSending;
    return Scaffold(
      appBar: AppBar(title: Text(cart?.restaurantName ?? l10n.customerCart)),
      body: cart == null
          ? Center(child: Text(l10n.customerCartEmpty))
          : ListView(
              padding: const EdgeInsetsDirectional.all(16),
              children: [
                for (final problem in problems)
                  ProblemTile(
                    problem: problem,
                    onChangeAddress: _useCurrentLocation,
                    enabled: !quote.isLoading,
                  ),
                if (place is PlaceFailed)
                  ListTile(
                    key: const Key('place-failure'),
                    title: Text(_failureText(l10n, place.failure)),
                  ),
                ..._address(l10n, point),
                const Divider(),
                ..._note(l10n),
                const Divider(),
                if (q != null) ..._payIn(l10n, q),
                ListTile(title: Text(l10n.customerCashOnDelivery)),
                if (q != null) ..._money(l10n, q),
                if (quote.isLoading) const LinearProgressIndicator(),
                if (quote.hasError)
                  TextButton(
                    onPressed: () => ref.invalidate(quoteProvider),
                    child: Text(l10n.customerTryAgain),
                  ),
                FilledButton(
                  key: const Key('confirm-order'),
                  onPressed:
                      q == null ||
                          problems.isNotEmpty ||
                          sending ||
                          quote.isLoading ||
                          quote.hasError ||
                          point is! PointChecked
                      ? null
                      : () => _confirm(q, cart, point),
                  child: Text(
                    sending
                        ? l10n.customerSending
                        : q == null
                        ? l10n.customerConfirm
                        : l10n.customerConfirmFor(
                            l10n.formatMoney(q.money.total, q.currency),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _address(AppLocalizations l10n, DeliveryPointState point) {
    final saved = ref.watch(savedAddressesProvider).value ?? const [];
    // The address is the point's: a saved one, or the point itself unsaved.
    final chosen = point is PointChecked ? point.addressId : null;
    final form = ref.watch(checkoutFormProvider);
    final edit = ref.read(checkoutFormProvider.notifier).update;
    String? error(FormProblem problem, String text) =>
        _problems.contains(problem) ? text : null;
    return [
      ListTile(title: Text(l10n.customerDeliveryAddress)),
      RadioGroup<String?>(
        groupValue: chosen,
        onChanged: (value) {
          if (value == null) return _useCurrentLocation();
          _chooseSaved(saved.firstWhere((a) => a.id == value));
        },
        child: Column(
          children: [
            for (final address in saved)
              RadioListTile<String?>(
                key: Key('address-${address.id}'),
                value: address.id,
                enabled: address.neighbourhood != null,
                title: Text(switch (address.label.name) {
                  'home' => l10n.customerLabelHome,
                  'work' => l10n.customerLabelWork,
                  _ => address.customLabel ?? l10n.customerLabelOther,
                }),
                subtitle: Text(
                  [
                    address.street,
                    address.neighbourhood ?? l10n.customerOutsideZoneNow,
                  ].join(' · '),
                ),
              ),
            RadioListTile<String?>(
              key: const Key('address-current'),
              value: null,
              title: Text(l10n.customerDeliverToCurrentLocation),
            ),
          ],
        ),
      ),
      if (point is PointLocating) const LinearProgressIndicator(),
      if (point is PointUnavailable)
        ListTile(
          title: Text(l10n.customerLocationFailed),
          trailing: TextButton(
            onPressed: _useCurrentLocation,
            child: Text(l10n.customerTryAgain),
          ),
        ),
      if (chosen == null && point is PointChecked) ...[
        if ((point.accuracyMetres ?? 0) > accurateMetres)
          ListTile(
            title: Text(
              l10n.customerLowAccuracy(
                l10n.formatDistance(point.accuracyMetres!.round()),
              ),
            ),
            trailing: TextButton(
              onPressed: _useCurrentLocation,
              child: Text(l10n.customerUpdateLocation),
            ),
          ),
        ListTile(
          title: Text(l10n.customerNeighbourhood),
          subtitle: Text(point.zoneName ?? ''),
        ),
        _field(
          'address-street',
          l10n.customerStreet,
          form.street,
          (v) => edit((f) => f.copyWith(street: v)),
          error(FormProblem.street, l10n.customerLengthBetween(3, 100)),
        ),
        _field(
          'address-floor',
          l10n.customerFloor,
          form.floor,
          (v) => edit((f) => f.copyWith(floor: v)),
          error(FormProblem.floor, l10n.customerLengthUpTo(100)),
        ),
        _field(
          'address-landmark',
          l10n.customerLandmark,
          form.landmark,
          (v) => edit((f) => f.copyWith(landmark: v)),
          error(FormProblem.landmark, l10n.customerLengthBetween(3, 100)),
          hint: l10n.customerLandmarkHint,
        ),
        _field(
          'address-phone',
          l10n.customerContactPhone,
          form.contactPhone,
          (v) => edit((f) => f.copyWith(contactPhone: v)),
          error(FormProblem.contactPhone, l10n.signInInvalidPhone),
          hint: l10n.customerContactPhoneHint,
          keyboard: TextInputType.phone,
        ),
        if (form.contactPhone.trim().isNotEmpty)
          _field(
            'address-recipient',
            l10n.customerRecipientName,
            form.recipientName,
            (v) => edit((f) => f.copyWith(recipientName: v)),
            error(FormProblem.recipientName, l10n.customerLengthBetween(2, 60)),
          ),
        _field(
          'address-directions',
          l10n.customerDirections,
          form.directions,
          (v) => edit((f) => f.copyWith(directions: v)),
          error(FormProblem.directions, l10n.customerLengthUpTo(200)),
          hint: l10n.customerDirectionsHint,
        ),
        ...[
          CheckboxListTile(
            key: const Key('address-save'),
            value: form.save,
            onChanged: (v) => edit((f) => f.copyWith(save: v ?? false)),
            title: Text(l10n.customerSaveAddress),
          ),
          if (form.save) ...[
            Wrap(
              children: [
                for (final label in AddressLabel.values)
                  ChoiceChip(
                    label: Text(switch (label) {
                      AddressLabel.home => l10n.customerLabelHome,
                      AddressLabel.work => l10n.customerLabelWork,
                      AddressLabel.other => l10n.customerLabelOther,
                    }),
                    selected: form.label == label,
                    onSelected: (_) => edit((f) => f.copyWith(label: label)),
                  ),
              ],
            ),
            if (form.label == AddressLabel.other)
              _field(
                'address-custom-label',
                l10n.customerCustomLabel,
                form.customLabel,
                (v) => edit((f) => f.copyWith(customLabel: v)),
                error(
                  FormProblem.customLabel,
                  l10n.customerLengthBetween(1, 30),
                ),
              ),
          ],
        ],
      ],
    ];
  }

  List<Widget> _note(AppLocalizations l10n) {
    final form = ref.watch(checkoutFormProvider);
    final controller = ref.read(checkoutFormProvider.notifier);
    return [
      // «الملاحظات الجاهزة» from Content (AP §9.13); none while not read.
      Wrap(
        children: [
          for (final preset
              in ref.watch(contentProvider).value?.orderNotes ??
                  const <String>[])
            ActionChip(
              label: Text(preset),
              onPressed: () => controller.addPreset(preset),
            ),
        ],
      ),
      _field(
        'order-note',
        l10n.customerOrderNote,
        form.note,
        (v) => controller.update((f) => f.copyWith(note: v)),
        _problems.contains(FormProblem.notePhone)
            ? l10n.customerNoPhoneInNote
            : _problems.contains(FormProblem.noteTooLong)
            ? l10n.customerNoteTooLong(maxOrderNote)
            : null,
      ),
    ];
  }

  List<Widget> _payIn(AppLocalizations l10n, Quote q) {
    final chosen = ref.watch(payInProvider).value;
    final currencies = {
      q.currency,
      for (final e in q.equivalents.nonNulls) e.currency,
    };
    final payIn = q.payIn;
    return [
      ListTile(title: Text(l10n.customerPayIn)),
      Wrap(
        children: [
          ChoiceChip(
            key: const Key('pay-in-none'),
            label: Text(l10n.customerPayInUnset),
            selected: chosen == null,
            onSelected: (_) => ref.read(payInProvider.notifier).choose(null),
          ),
          for (final currency in currencies)
            ChoiceChip(
              key: Key('pay-in-$currency'),
              label: Text(l10n.currencySymbol(currency)),
              selected: chosen == currency,
              onSelected: (_) =>
                  ref.read(payInProvider.notifier).choose(currency),
            ),
        ],
      ),
      if (chosen != null && payIn != null)
        ListTile(
          title: Text(
            l10n.customerPayAbout(
              l10n.formatMoney(payIn.amount, payIn.currency),
            ),
          ),
        ),
    ];
  }

  List<Widget> _money(AppLocalizations l10n, Quote q) {
    String money(String minor) => l10n.formatMoney(minor, q.currency);
    final m = q.money;
    return [
      ListTile(
        title: Text(
          l10n.customerArrivesWithin(q.estimate.fromMin, q.estimate.toMin),
        ),
      ),
      Thresholds(quote: q),
      _moneyLine(l10n.customerItemsValue, money(m.itemsValue)),
      _moneyLine(
        l10n.customerDeliveryFee,
        m.deliveryFree ? l10n.customerFree : money(m.deliveryFee),
      ),
      if (BigInt.parse(m.discount) != BigInt.zero)
        _moneyLine(l10n.customerDiscount, money(m.discount)),
      if (BigInt.parse(m.rounding) != BigInt.zero)
        _moneyLine(l10n.customerRounding, money(m.rounding)),
      _moneyLine(l10n.customerTotal, money(m.total)),
      if (q.equivalents.isNotEmpty)
        ListTile(
          key: const Key('equivalents'),
          title: Text(
            l10n.customerOrEquivalents(
              [
                for (final e in q.equivalents.nonNulls)
                  l10n.formatMoney(e.amount, e.currency),
              ].join(' · '),
            ),
          ),
        ),
    ];
  }

  Widget _moneyLine(String label, String value) =>
      ListTile(title: Text(label), trailing: Text(value));

  Widget _field(
    String key,
    String label,
    String value,
    ValueChanged<String> onChanged,
    String? error, {
    String? hint,
    TextInputType? keyboard,
  }) => TextFormField(
    key: Key(key),
    initialValue: value,
    keyboardType: keyboard,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error,
    ),
    onChanged: onChanged,
  );

  String _failureText(AppLocalizations l10n, PlaceFailure failure) =>
      switch (failure) {
        PlaceFailure.quoteChanged => l10n.customerQuoteChanged,
        PlaceFailure.blocked => l10n.customerOrderBlocked,
        PlaceFailure.address => l10n.customerAddressOutside,
        PlaceFailure.saveAddress => l10n.customerSaveAddressFailed,
        PlaceFailure.invalid => l10n.customerOrderInvalid,
        PlaceFailure.expired => l10n.customerCartExpired,
        PlaceFailure.unknown => l10n.customerSendFailed,
      };
}
