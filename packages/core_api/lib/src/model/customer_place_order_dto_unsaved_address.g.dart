// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_place_order_dto_unsaved_address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPlaceOrderDtoUnsavedAddress
    extends CustomerPlaceOrderDtoUnsavedAddress {
  @override
  final CustomerNewAddressDtoLocation location;
  @override
  final String street;
  @override
  final String? floor;
  @override
  final String landmark;
  @override
  final String? contactPhone;
  @override
  final String? recipientName;
  @override
  final String? directions;

  factory _$CustomerPlaceOrderDtoUnsavedAddress([
    void Function(CustomerPlaceOrderDtoUnsavedAddressBuilder)? updates,
  ]) =>
      (CustomerPlaceOrderDtoUnsavedAddressBuilder()..update(updates))._build();

  _$CustomerPlaceOrderDtoUnsavedAddress._({
    required this.location,
    required this.street,
    this.floor,
    required this.landmark,
    this.contactPhone,
    this.recipientName,
    this.directions,
  }) : super._();
  @override
  CustomerPlaceOrderDtoUnsavedAddress rebuild(
    void Function(CustomerPlaceOrderDtoUnsavedAddressBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlaceOrderDtoUnsavedAddressBuilder toBuilder() =>
      CustomerPlaceOrderDtoUnsavedAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlaceOrderDtoUnsavedAddress &&
        location == other.location &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        contactPhone == other.contactPhone &&
        recipientName == other.recipientName &&
        directions == other.directions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, landmark.hashCode);
    _$hash = $jc(_$hash, contactPhone.hashCode);
    _$hash = $jc(_$hash, recipientName.hashCode);
    _$hash = $jc(_$hash, directions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerPlaceOrderDtoUnsavedAddress')
          ..add('location', location)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('contactPhone', contactPhone)
          ..add('recipientName', recipientName)
          ..add('directions', directions))
        .toString();
  }
}

class CustomerPlaceOrderDtoUnsavedAddressBuilder
    implements
        Builder<
          CustomerPlaceOrderDtoUnsavedAddress,
          CustomerPlaceOrderDtoUnsavedAddressBuilder
        > {
  _$CustomerPlaceOrderDtoUnsavedAddress? _$v;

  CustomerNewAddressDtoLocationBuilder? _location;
  CustomerNewAddressDtoLocationBuilder get location =>
      _$this._location ??= CustomerNewAddressDtoLocationBuilder();
  set location(CustomerNewAddressDtoLocationBuilder? location) =>
      _$this._location = location;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _floor;
  String? get floor => _$this._floor;
  set floor(String? floor) => _$this._floor = floor;

  String? _landmark;
  String? get landmark => _$this._landmark;
  set landmark(String? landmark) => _$this._landmark = landmark;

  String? _contactPhone;
  String? get contactPhone => _$this._contactPhone;
  set contactPhone(String? contactPhone) => _$this._contactPhone = contactPhone;

  String? _recipientName;
  String? get recipientName => _$this._recipientName;
  set recipientName(String? recipientName) =>
      _$this._recipientName = recipientName;

  String? _directions;
  String? get directions => _$this._directions;
  set directions(String? directions) => _$this._directions = directions;

  CustomerPlaceOrderDtoUnsavedAddressBuilder() {
    CustomerPlaceOrderDtoUnsavedAddress._defaults(this);
  }

  CustomerPlaceOrderDtoUnsavedAddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _street = $v.street;
      _floor = $v.floor;
      _landmark = $v.landmark;
      _contactPhone = $v.contactPhone;
      _recipientName = $v.recipientName;
      _directions = $v.directions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlaceOrderDtoUnsavedAddress other) {
    _$v = other as _$CustomerPlaceOrderDtoUnsavedAddress;
  }

  @override
  void update(
    void Function(CustomerPlaceOrderDtoUnsavedAddressBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlaceOrderDtoUnsavedAddress build() => _build();

  _$CustomerPlaceOrderDtoUnsavedAddress _build() {
    _$CustomerPlaceOrderDtoUnsavedAddress _$result;
    try {
      _$result =
          _$v ??
          _$CustomerPlaceOrderDtoUnsavedAddress._(
            location: location.build(),
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'CustomerPlaceOrderDtoUnsavedAddress',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'CustomerPlaceOrderDtoUnsavedAddress',
              'landmark',
            ),
            contactPhone: contactPhone,
            recipientName: recipientName,
            directions: directions,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerPlaceOrderDtoUnsavedAddress',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
