import 'package:core_l10n/core_l10n.dart';
import 'package:core_maps/core_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../checkout/checkout.dart';
import '../location/delivery_point.dart';
import '../location/pin.dart';
import 'addresses.dart';
import 'addresses_screen.dart';

/// A saved address's form (CU §7.3): «إضافة عنوان» with [addressId] null,
/// else «تعديل العنوان» with every field, the pin included (U5). The pin is
/// set on the map at street level; «الحي» is the zone at it, read-only.
/// Unstyled until the design.
class AddressFormScreen extends ConsumerStatefulWidget {
  const AddressFormScreen({super.key, this.addressId});

  final String? addressId;

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  CheckoutForm _form = const CheckoutForm(save: true);
  GeoPoint? _pin;
  bool _filled = false;
  bool _saving = false;
  ({bool pin, Set<FormProblem> fields})? _problems;
  String? _failure;

  /// An edit starts from the saved address, once the list is read.
  void _fill(List<SavedAddress> saved) {
    if (_filled) return;
    _filled = true;
    final id = widget.addressId;
    if (id == null) return;
    for (final address in saved) {
      if (address.id != id) continue;
      _form = formOf(address);
      _pin = pinOf(address);
    }
  }

  Future<void> _choosePin() async {
    final point = ref.read(deliveryPointProvider);
    final camera = switch ((_pin, point)) {
      (final GeoPoint pin, _) => MapCamera(pin, streetZoom),
      (_, PointChecked(:final point)) => MapCamera(point, streetZoom),
      _ => const MapCamera(cityCentre, cityZoom),
    };
    final chosen = await context.push<GeoPoint>(pinPath(camera));
    if (chosen != null && mounted) setState(() => _pin = chosen);
  }

  Future<void> _save() async {
    final problems = addressProblems(_pin, _form);
    setState(() {
      _problems = problems;
      _failure = null;
    });
    final pin = _pin;
    if (pin == null || problems.fields.isNotEmpty || _saving) return;
    setState(() => _saving = true);
    final book = ref.read(addressBookProvider);
    final id = widget.addressId;
    final outcome = id == null
        ? await book.add(pin, _form)
        : await book.update(id, pin, _form);
    if (!mounted) return;
    setState(() => _saving = false);
    if (outcome == AddressOutcome.done || outcome == AddressOutcome.gone) {
      context.pop();
      return;
    }
    setState(
      () =>
          _failure = addressOutcomeText(AppLocalizations.of(context), outcome),
    );
  }

  void _edit(CheckoutForm Function(CheckoutForm form) change) =>
      setState(() => _form = change(_form));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final saved = ref.watch(savedAddressesProvider);
    final editing = widget.addressId != null;
    if (saved case AsyncData(:final value)) _fill(value);
    if (editing && !_filled) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.customerEditAddress)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final pin = _pin;
    final zone = pin == null ? null : ref.watch(pinZoneProvider(pin));
    String? error(FormProblem problem, String text) =>
        _problems?.fields.contains(problem) ?? false ? text : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? l10n.customerEditAddress : l10n.customerAddAddress,
        ),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          ListTile(
            title: Text(l10n.customerPinOnMap),
            subtitle: _problems?.pin ?? false
                ? Text(l10n.customerPinRequired)
                : null,
            trailing: TextButton(
              key: const Key('address-pin'),
              onPressed: _choosePin,
              child: Text(
                pin == null ? l10n.customerChooseOnMap : l10n.customerEdit,
              ),
            ),
          ),
          if (zone != null)
            ListTile(
              title: Text(l10n.customerNeighbourhood),
              subtitle: switch (zone) {
                AsyncData(value: final String name) => Text(name),
                AsyncData() => Text(l10n.customerAddressOutside),
                AsyncError() => Text(l10n.statusError),
                _ => const LinearProgressIndicator(),
              },
            ),
          Wrap(
            children: [
              for (final label in AddressLabel.values)
                ChoiceChip(
                  key: Key('label-${label.name}'),
                  label: Text(switch (label) {
                    AddressLabel.home => l10n.customerLabelHome,
                    AddressLabel.work => l10n.customerLabelWork,
                    AddressLabel.other => l10n.customerLabelOther,
                  }),
                  selected: _form.label == label,
                  onSelected: (_) => _edit((f) => f.copyWith(label: label)),
                ),
            ],
          ),
          if (_form.label == AddressLabel.other)
            _field(
              'address-custom-label',
              l10n.customerCustomLabel,
              _form.customLabel,
              (v) => _edit((f) => f.copyWith(customLabel: v)),
              error(FormProblem.customLabel, l10n.customerLengthBetween(1, 30)),
            ),
          _field(
            'address-street',
            l10n.customerStreet,
            _form.street,
            (v) => _edit((f) => f.copyWith(street: v)),
            error(FormProblem.street, l10n.customerLengthBetween(3, 100)),
          ),
          _field(
            'address-floor',
            l10n.customerFloor,
            _form.floor,
            (v) => _edit((f) => f.copyWith(floor: v)),
            error(FormProblem.floor, l10n.customerLengthUpTo(100)),
          ),
          _field(
            'address-landmark',
            l10n.customerLandmark,
            _form.landmark,
            (v) => _edit((f) => f.copyWith(landmark: v)),
            error(FormProblem.landmark, l10n.customerLengthBetween(3, 100)),
            hint: l10n.customerLandmarkHint,
          ),
          _field(
            'address-phone',
            l10n.customerContactPhone,
            _form.contactPhone,
            (v) => _edit((f) => f.copyWith(contactPhone: v)),
            error(FormProblem.contactPhone, l10n.signInInvalidPhone),
            hint: l10n.customerContactPhoneHint,
            keyboard: TextInputType.phone,
          ),
          if (_form.contactPhone.trim().isNotEmpty)
            _field(
              'address-recipient',
              l10n.customerRecipientName,
              _form.recipientName,
              (v) => _edit((f) => f.copyWith(recipientName: v)),
              error(
                FormProblem.recipientName,
                l10n.customerLengthBetween(2, 60),
              ),
            ),
          _field(
            'address-directions',
            l10n.customerDirections,
            _form.directions,
            (v) => _edit((f) => f.copyWith(directions: v)),
            error(FormProblem.directions, l10n.customerLengthUpTo(200)),
            hint: l10n.customerDirectionsHint,
          ),
          if (_failure case final failure?)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 16),
              child: Text(failure),
            ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('save-address'),
            onPressed: _saving ? null : _save,
            child: Text(l10n.customerSave),
          ),
        ],
      ),
    );
  }

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
}
