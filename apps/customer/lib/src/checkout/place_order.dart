import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../cart/cart.dart';
import '../device.dart';
import '../location/delivery_point.dart';
import '../location/position.dart';
import 'checkout.dart';
import 'quote.dart';

/// The far-pin check (CU §7.5): `customer.far_pin_warn_m`'s default. The
/// apps read no settings yet, so the default is fixed here.
const farPinWarnMetres = 1000.0;

/// The far-pin check waits this long for a fresh position (CU §7.5, fixed).
const farPinTimeLimit = Duration(seconds: 5);

/// The far-pin check (CU §7.5), on the device only: the distance in metres
/// from the phone to [pin] when it is farther than [farPinWarnMetres], or
/// null. Without the permission, or without a position accurate to 100 m
/// within 5 seconds, there is no check.
Future<double?> farPinMetres(PositionSource source, GeoPoint pin) async {
  final result = await source.current(timeLimit: farPinTimeLimit, ask: false);
  final fix = result.fix;
  if (fix == null || fix.accuracyMetres > accurateMetres) return null;
  final metres = fix.point.metresTo(pin);
  return metres > farPinWarnMetres ? metres : null;
}

sealed class PlaceState {
  const PlaceState();
}

class PlaceIdle extends PlaceState {
  const PlaceIdle();
}

/// «جارٍ إرسال طلبك…»: the button cannot be pressed again.
class PlaceSending extends PlaceState {
  const PlaceSending();
}

enum PlaceFailure {
  /// `409 quote_changed`: the new quote is shown, the customer confirms
  /// again (Q10).
  quoteChanged,

  /// `409 order_blocked`: the new quote shows the problem; the cart stays.
  blocked,

  /// The address is outside every zone or no longer saved.
  address,

  /// «احفظ هذا العنوان» failed: the order was not sent.
  saveAddress,

  /// `400`: a field the server refuses; the next command takes a new key.
  invalid,

  /// The cart expired before it was sent (CU §10.1).
  expired,

  /// No answer or another error: the same command may be sent again with
  /// the same key.
  unknown,
}

class PlaceFailed extends PlaceState {
  const PlaceFailed(this.failure);

  final PlaceFailure failure;
}

class PlacePlaced extends PlaceState {
  const PlacePlaced(this.orderId);

  final String orderId;
}

/// What «تأكيد الطلب» sends (CU §10.7 item 5).
class PlaceCommand {
  const PlaceCommand({
    required this.cart,
    required this.quoteVersion,
    required this.point,
    required this.addressId,
    required this.form,
    required this.payIn,
  });

  final Cart cart;
  final String quoteVersion;
  final GeoPoint point;

  /// A saved address, or null for [form]'s unsaved one at [point].
  final String? addressId;
  final CheckoutForm form;
  final String? payIn;
}

/// Places the order (CU §10.7). It lives while the app runs, so leaving
/// checkout never cancels a command in flight. Its idempotency key belongs
/// to one command: the same command sent again after a lost answer reuses
/// it, another command takes a new one.
class PlaceOrderController extends Notifier<PlaceState> {
  String? _key;
  String? _keyFor;

  @override
  PlaceState build() => const PlaceIdle();

  CustomerApi get _api => ref.read(coreApiProvider).getCustomerApi();

  Future<void> place(PlaceCommand command) async {
    if (state is PlaceSending) return;
    state = const PlaceSending();
    if (await ref.read(cartProvider.notifier).current() == null) {
      state = const PlaceFailed(PlaceFailure.expired);
      return;
    }
    var addressId = command.addressId;
    final form = command.form;
    if (addressId == null && form.save) {
      try {
        addressId = await _saveAddress(command);
        ref.invalidate(savedAddressesProvider);
        ref.read(deliveryPointProvider.notifier).adoptAddress(addressId);
      } on Object {
        state = const PlaceFailed(PlaceFailure.saveAddress);
        return;
      }
    }
    final body = _body(command, addressId);
    final fingerprint = body.toString();
    if (_keyFor != fingerprint) {
      _key = uuidV4();
      _keyFor = fingerprint;
    }
    try {
      final response = await _api.customerOrdersPlace(
        idempotencyKey: _key!,
        customerPlaceOrderDto: body,
      );
      _key = null;
      _keyFor = null;
      await ref.read(cartProvider.notifier).clear();
      ref.read(checkoutFormProvider.notifier).reset();
      state = PlacePlaced(response.data!.order.id);
    } on DioException catch (error) {
      final refusal = AuthRefusal.of(error);
      final status = error.response?.statusCode;
      final failure = switch ((status, refusal.error)) {
        (409, 'quote_changed') => PlaceFailure.quoteChanged,
        (409, 'order_blocked') => PlaceFailure.blocked,
        (409, 'outside_zones') ||
        (404, 'unknown_address') => PlaceFailure.address,
        (400, _) => PlaceFailure.invalid,
        _ => PlaceFailure.unknown,
      };
      if (failure != PlaceFailure.unknown) {
        // A refused command is done with: the next one takes a new key.
        _key = null;
        _keyFor = null;
        ref.invalidate(quoteProvider);
      }
      state = PlaceFailed(failure);
    } on Object {
      state = const PlaceFailed(PlaceFailure.unknown);
    }
  }

  /// The order screen was opened, or checkout was opened again after a
  /// failure.
  void done() {
    if (state is! PlaceSending) state = const PlaceIdle();
  }

  Future<String> _saveAddress(PlaceCommand command) async {
    final form = command.form;
    final response = await _api.customerProfileAddAddress(
      customerNewAddressDto: CustomerNewAddressDto(
        (b) => b
          ..location.latitude = command.point.latitude
          ..location.longitude = command.point.longitude
          ..label = switch (form.label) {
            AddressLabel.home => CustomerNewAddressDtoLabelEnum.home,
            AddressLabel.work => CustomerNewAddressDtoLabelEnum.work,
            AddressLabel.other => CustomerNewAddressDtoLabelEnum.other,
          }
          ..customLabel = form.label == AddressLabel.other
              ? _t(form.customLabel)
              : null
          ..street = _t(form.street)
          ..floor = _optional(form.floor)
          ..landmark = _t(form.landmark)
          ..contactPhone = form.contactE164
          ..recipientName = form.contactE164 == null
              ? null
              : _t(form.recipientName)
          ..directions = _optional(form.directions)
          ..isDefault = false,
      ),
    );
    return response.data!.id;
  }

  CustomerPlaceOrderDto _body(PlaceCommand command, String? addressId) {
    final form = command.form;
    return CustomerPlaceOrderDto(
      (b) => b
        ..restaurantId = command.cart.restaurantId
        ..lines.replace(requestLines(command.cart))
        ..payIn = command.payIn
        ..appVersion = appVersion
        ..quoteVersion = command.quoteVersion
        ..addressId = addressId
        ..unsavedAddress = addressId != null
            ? null
            : (CustomerPlaceOrderDtoUnsavedAddressBuilder()
                ..location.latitude = command.point.latitude
                ..location.longitude = command.point.longitude
                ..street = _t(form.street)
                ..floor = _optional(form.floor)
                ..landmark = _t(form.landmark)
                ..contactPhone = form.contactE164
                ..recipientName = form.contactE164 == null
                    ? null
                    : _t(form.recipientName)
                ..directions = _optional(form.directions))
        ..note = _optional(form.note),
    );
  }
}

String _t(String value) => value.trim();

String? _optional(String value) => _t(value).isEmpty ? null : _t(value);

final placeOrderProvider = NotifierProvider<PlaceOrderController, PlaceState>(
  PlaceOrderController.new,
);
