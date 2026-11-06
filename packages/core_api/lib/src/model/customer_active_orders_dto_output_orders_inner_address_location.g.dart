// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_address_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation
    extends CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation,
          CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerAddressLocationBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
