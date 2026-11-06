// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_list_dto_output_addresses_inner_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerAddressListDtoOutputAddressesInnerLocation
    extends CustomerAddressListDtoOutputAddressesInnerLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CustomerAddressListDtoOutputAddressesInnerLocation([
    void Function(CustomerAddressListDtoOutputAddressesInnerLocationBuilder)?
    updates,
  ]) =>
      (CustomerAddressListDtoOutputAddressesInnerLocationBuilder()
            ..update(updates))
          ._build();

  _$CustomerAddressListDtoOutputAddressesInnerLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CustomerAddressListDtoOutputAddressesInnerLocation rebuild(
    void Function(CustomerAddressListDtoOutputAddressesInnerLocationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAddressListDtoOutputAddressesInnerLocationBuilder toBuilder() =>
      CustomerAddressListDtoOutputAddressesInnerLocationBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAddressListDtoOutputAddressesInnerLocation &&
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
            r'CustomerAddressListDtoOutputAddressesInnerLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CustomerAddressListDtoOutputAddressesInnerLocationBuilder
    implements
        Builder<
          CustomerAddressListDtoOutputAddressesInnerLocation,
          CustomerAddressListDtoOutputAddressesInnerLocationBuilder
        > {
  _$CustomerAddressListDtoOutputAddressesInnerLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CustomerAddressListDtoOutputAddressesInnerLocationBuilder() {
    CustomerAddressListDtoOutputAddressesInnerLocation._defaults(this);
  }

  CustomerAddressListDtoOutputAddressesInnerLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAddressListDtoOutputAddressesInnerLocation other) {
    _$v = other as _$CustomerAddressListDtoOutputAddressesInnerLocation;
  }

  @override
  void update(
    void Function(CustomerAddressListDtoOutputAddressesInnerLocationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAddressListDtoOutputAddressesInnerLocation build() => _build();

  _$CustomerAddressListDtoOutputAddressesInnerLocation _build() {
    final _$result =
        _$v ??
        _$CustomerAddressListDtoOutputAddressesInnerLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerAddressListDtoOutputAddressesInnerLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerAddressListDtoOutputAddressesInnerLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
