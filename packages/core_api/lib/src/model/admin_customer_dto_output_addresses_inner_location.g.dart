// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_addresses_inner_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputAddressesInnerLocation
    extends AdminCustomerDtoOutputAddressesInnerLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminCustomerDtoOutputAddressesInnerLocation([
    void Function(AdminCustomerDtoOutputAddressesInnerLocationBuilder)? updates,
  ]) => (AdminCustomerDtoOutputAddressesInnerLocationBuilder()..update(updates))
      ._build();

  _$AdminCustomerDtoOutputAddressesInnerLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminCustomerDtoOutputAddressesInnerLocation rebuild(
    void Function(AdminCustomerDtoOutputAddressesInnerLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputAddressesInnerLocationBuilder toBuilder() =>
      AdminCustomerDtoOutputAddressesInnerLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputAddressesInnerLocation &&
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
            r'AdminCustomerDtoOutputAddressesInnerLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminCustomerDtoOutputAddressesInnerLocationBuilder
    implements
        Builder<
          AdminCustomerDtoOutputAddressesInnerLocation,
          AdminCustomerDtoOutputAddressesInnerLocationBuilder
        > {
  _$AdminCustomerDtoOutputAddressesInnerLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminCustomerDtoOutputAddressesInnerLocationBuilder() {
    AdminCustomerDtoOutputAddressesInnerLocation._defaults(this);
  }

  AdminCustomerDtoOutputAddressesInnerLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputAddressesInnerLocation other) {
    _$v = other as _$AdminCustomerDtoOutputAddressesInnerLocation;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputAddressesInnerLocationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputAddressesInnerLocation build() => _build();

  _$AdminCustomerDtoOutputAddressesInnerLocation _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputAddressesInnerLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminCustomerDtoOutputAddressesInnerLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminCustomerDtoOutputAddressesInnerLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
