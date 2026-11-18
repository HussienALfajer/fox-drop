import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../checkout/checkout.dart';
import '../location/delivery_point.dart';
import '../location/position.dart';

/// Up to this many saved addresses (CU §7.3, fixed); the server refuses
/// more with `409 address_limit`.
const maxAddresses = 10;

/// A saved address's pin.
GeoPoint pinOf(SavedAddress address) => GeoPoint(
  address.location.latitude.toDouble(),
  address.location.longitude.toDouble(),
);

/// The fields of [address] as the form edits them (CU §7.3, U5): its own
/// contact number as typed, empty for the account's.
CheckoutForm formOf(SavedAddress address) => CheckoutForm(
  street: address.street,
  floor: address.floor ?? '',
  landmark: address.landmark,
  contactPhone: address.contactPhone ?? '',
  recipientName: address.recipientName ?? '',
  directions: address.directions ?? '',
  save: true,
  label: switch (address.label) {
    CustomerAddressListDtoOutputAddressesInnerLabelEnum.work =>
      AddressLabel.work,
    CustomerAddressListDtoOutputAddressesInnerLabelEnum.other =>
      AddressLabel.other,
    _ => AddressLabel.home,
  },
  customLabel: address.customLabel ?? '',
);

/// What the form still lacks: the pin, then the fields of CU §7.3 (the
/// checks checkout makes for an address it saves).
({bool pin, Set<FormProblem> fields}) addressProblems(
  GeoPoint? pin,
  CheckoutForm form,
) => (
  pin: pin == null,
  fields: formProblems(form.copyWith(save: true, note: ''), unsaved: true),
);

/// The body of `POST /v1/customer/addresses`, from checkout's «احفظ هذا
/// العنوان» too.
CustomerNewAddressDto newAddressDto(GeoPoint pin, CheckoutForm form) =>
    CustomerNewAddressDto(
      (b) => b
        ..location.latitude = pin.latitude
        ..location.longitude = pin.longitude
        ..label = switch (form.label) {
          AddressLabel.home => CustomerNewAddressDtoLabelEnum.home,
          AddressLabel.work => CustomerNewAddressDtoLabelEnum.work,
          AddressLabel.other => CustomerNewAddressDtoLabelEnum.other,
        }
        ..customLabel = form.label == AddressLabel.other
            ? form.customLabel.trim()
            : null
        ..street = form.street.trim()
        ..floor = _optional(form.floor)
        ..landmark = form.landmark.trim()
        ..contactPhone = form.contactE164
        ..recipientName = form.contactE164 == null
            ? null
            : form.recipientName.trim()
        ..directions = _optional(form.directions)
        ..isDefault = false,
    );

CustomerAddressFieldsDto _fieldsDto(GeoPoint pin, CheckoutForm form) {
  final fields = newAddressDto(pin, form);
  return CustomerAddressFieldsDto(
    (b) => b
      ..location.replace(fields.location)
      ..label = CustomerAddressFieldsDtoLabelEnum.valueOf(fields.label.name)
      ..customLabel = fields.customLabel
      ..street = fields.street
      ..floor = fields.floor
      ..landmark = fields.landmark
      ..contactPhone = fields.contactPhone
      ..recipientName = fields.recipientName
      ..directions = fields.directions,
  );
}

String? _optional(String value) => value.trim().isEmpty ? null : value.trim();

/// How an address command ended.
enum AddressOutcome {
  done,

  /// The pin is outside every active zone (`409 outside_zones`).
  outsideZones,

  /// [maxAddresses] are saved already (`409 address_limit`).
  limit,

  /// The address is gone, deleted on another phone (`404`).
  gone,
  failed,
}

/// «عناويني»'s commands (CU §7.3) over the existing routes. Each success
/// reads the list again and keeps the delivery point in step: a deleted
/// address (here or, `404`, on another phone) stops naming the point, an
/// edited one moves it to its new pin.
class AddressBook {
  AddressBook(this._ref);

  final Ref _ref;

  CustomerApi get _api => _ref.read(coreApiProvider).getCustomerApi();

  Future<AddressOutcome> add(GeoPoint pin, CheckoutForm form) => _run(
    () => _api.customerProfileAddAddress(
      customerNewAddressDto: newAddressDto(pin, form),
    ),
  );

  Future<AddressOutcome> update(
    String id,
    GeoPoint pin,
    CheckoutForm form,
  ) async {
    final outcome = await _run(
      () => _api.customerProfileUpdateAddress(
        addressId: id,
        customerAddressFieldsDto: _fieldsDto(pin, form),
      ),
    );
    if (_pointAddress == id) {
      final point = _ref.read(deliveryPointProvider.notifier);
      if (outcome == AddressOutcome.done) await point.useAddress(id, pin);
      // Deleted on another phone: the point stays, unsaved.
      if (outcome == AddressOutcome.gone) point.forgetAddress();
    }
    return outcome;
  }

  Future<AddressOutcome> makeDefault(String id) =>
      _run(() => _api.customerProfileSetDefaultAddress(addressId: id));

  Future<AddressOutcome> delete(String id) async {
    final outcome = await _run(
      () => _api.customerProfileDeleteAddress(addressId: id),
    );
    // Gone already (deleted on another phone) ends the same way.
    if ((outcome == AddressOutcome.done || outcome == AddressOutcome.gone) &&
        _pointAddress == id) {
      _ref.read(deliveryPointProvider.notifier).forgetAddress();
    }
    return outcome;
  }

  String? get _pointAddress => switch (_ref.read(deliveryPointProvider)) {
    PointChecked(:final addressId) => addressId,
    _ => null,
  };

  Future<AddressOutcome> _run(Future<Object?> Function() call) async {
    try {
      await call();
      _ref.invalidate(savedAddressesProvider);
      return AddressOutcome.done;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404) {
        _ref.invalidate(savedAddressesProvider);
        return AddressOutcome.gone;
      }
      return switch (AuthRefusal.of(error).error) {
        'outside_zones' => AddressOutcome.outsideZones,
        'address_limit' => AddressOutcome.limit,
        _ => AddressOutcome.failed,
      };
    }
  }
}

/// Kept for the app's life: it holds nothing, and a command outlives the
/// screen that started it.
final addressBookProvider = Provider<AddressBook>(AddressBook.new);

/// The zone at a pin chosen in the form, for «الحي» (CU §7.3: filled from
/// the zone, read-only): its name, or null outside every active zone. The
/// server checks it again when saving.
final pinZoneProvider = FutureProvider.autoDispose.family<String?, GeoPoint>((
  ref,
  pin,
) async {
  final answer = await ref
      .read(coreApiProvider)
      .getCustomerApi()
      .customerProfileLocation(
        latitude: '${pin.latitude}',
        longitude: '${pin.longitude}',
      );
  return answer.data!.zone?.name;
});
