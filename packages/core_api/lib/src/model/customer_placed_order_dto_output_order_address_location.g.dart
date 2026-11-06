// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_placed_order_dto_output_order_address_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPlacedOrderDtoOutputOrderAddressLocation
    extends CustomerPlacedOrderDtoOutputOrderAddressLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CustomerPlacedOrderDtoOutputOrderAddressLocation([
    void Function(CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder)?
    updates,
  ]) =>
      (CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder()
            ..update(updates))
          ._build();

  _$CustomerPlacedOrderDtoOutputOrderAddressLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CustomerPlacedOrderDtoOutputOrderAddressLocation rebuild(
    void Function(CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder toBuilder() =>
      CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlacedOrderDtoOutputOrderAddressLocation &&
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
            r'CustomerPlacedOrderDtoOutputOrderAddressLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder
    implements
        Builder<
          CustomerPlacedOrderDtoOutputOrderAddressLocation,
          CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder
        > {
  _$CustomerPlacedOrderDtoOutputOrderAddressLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder() {
    CustomerPlacedOrderDtoOutputOrderAddressLocation._defaults(this);
  }

  CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlacedOrderDtoOutputOrderAddressLocation other) {
    _$v = other as _$CustomerPlacedOrderDtoOutputOrderAddressLocation;
  }

  @override
  void update(
    void Function(CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlacedOrderDtoOutputOrderAddressLocation build() => _build();

  _$CustomerPlacedOrderDtoOutputOrderAddressLocation _build() {
    final _$result =
        _$v ??
        _$CustomerPlacedOrderDtoOutputOrderAddressLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerPlacedOrderDtoOutputOrderAddressLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerPlacedOrderDtoOutputOrderAddressLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
