// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_customer_address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCustomerAddress
    extends AdminOrderDtoOutputOrderCustomerAddress {
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation location;
  @override
  final String neighbourhood;
  @override
  final String street;
  @override
  final String? floor;
  @override
  final String landmark;
  @override
  final String? directions;

  factory _$AdminOrderDtoOutputOrderCustomerAddress([
    void Function(AdminOrderDtoOutputOrderCustomerAddressBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCustomerAddressBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCustomerAddress._({
    required this.location,
    required this.neighbourhood,
    required this.street,
    this.floor,
    required this.landmark,
    this.directions,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCustomerAddress rebuild(
    void Function(AdminOrderDtoOutputOrderCustomerAddressBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCustomerAddressBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCustomerAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCustomerAddress &&
        location == other.location &&
        neighbourhood == other.neighbourhood &&
        street == other.street &&
        floor == other.floor &&
        landmark == other.landmark &&
        directions == other.directions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, landmark.hashCode);
    _$hash = $jc(_$hash, directions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderCustomerAddress',
          )
          ..add('location', location)
          ..add('neighbourhood', neighbourhood)
          ..add('street', street)
          ..add('floor', floor)
          ..add('landmark', landmark)
          ..add('directions', directions))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCustomerAddressBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCustomerAddress,
          AdminOrderDtoOutputOrderCustomerAddressBuilder
        > {
  _$AdminOrderDtoOutputOrderCustomerAddress? _$v;

  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder? _location;
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder get location =>
      _$this._location ??=
          CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder();
  set location(
    CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder? location,
  ) => _$this._location = location;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _floor;
  String? get floor => _$this._floor;
  set floor(String? floor) => _$this._floor = floor;

  String? _landmark;
  String? get landmark => _$this._landmark;
  set landmark(String? landmark) => _$this._landmark = landmark;

  String? _directions;
  String? get directions => _$this._directions;
  set directions(String? directions) => _$this._directions = directions;

  AdminOrderDtoOutputOrderCustomerAddressBuilder() {
    AdminOrderDtoOutputOrderCustomerAddress._defaults(this);
  }

  AdminOrderDtoOutputOrderCustomerAddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _neighbourhood = $v.neighbourhood;
      _street = $v.street;
      _floor = $v.floor;
      _landmark = $v.landmark;
      _directions = $v.directions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCustomerAddress other) {
    _$v = other as _$AdminOrderDtoOutputOrderCustomerAddress;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCustomerAddressBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCustomerAddress build() => _build();

  _$AdminOrderDtoOutputOrderCustomerAddress _build() {
    _$AdminOrderDtoOutputOrderCustomerAddress _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderCustomerAddress._(
            location: location.build(),
            neighbourhood: BuiltValueNullFieldError.checkNotNull(
              neighbourhood,
              r'AdminOrderDtoOutputOrderCustomerAddress',
              'neighbourhood',
            ),
            street: BuiltValueNullFieldError.checkNotNull(
              street,
              r'AdminOrderDtoOutputOrderCustomerAddress',
              'street',
            ),
            floor: floor,
            landmark: BuiltValueNullFieldError.checkNotNull(
              landmark,
              r'AdminOrderDtoOutputOrderCustomerAddress',
              'landmark',
            ),
            directions: directions,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderCustomerAddress',
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
