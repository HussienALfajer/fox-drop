// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_new_address_dto_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerNewAddressDtoLocation extends CustomerNewAddressDtoLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CustomerNewAddressDtoLocation([
    void Function(CustomerNewAddressDtoLocationBuilder)? updates,
  ]) => (CustomerNewAddressDtoLocationBuilder()..update(updates))._build();

  _$CustomerNewAddressDtoLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CustomerNewAddressDtoLocation rebuild(
    void Function(CustomerNewAddressDtoLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerNewAddressDtoLocationBuilder toBuilder() =>
      CustomerNewAddressDtoLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerNewAddressDtoLocation &&
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
    return (newBuiltValueToStringHelper(r'CustomerNewAddressDtoLocation')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CustomerNewAddressDtoLocationBuilder
    implements
        Builder<
          CustomerNewAddressDtoLocation,
          CustomerNewAddressDtoLocationBuilder
        > {
  _$CustomerNewAddressDtoLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CustomerNewAddressDtoLocationBuilder() {
    CustomerNewAddressDtoLocation._defaults(this);
  }

  CustomerNewAddressDtoLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerNewAddressDtoLocation other) {
    _$v = other as _$CustomerNewAddressDtoLocation;
  }

  @override
  void update(void Function(CustomerNewAddressDtoLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerNewAddressDtoLocation build() => _build();

  _$CustomerNewAddressDtoLocation _build() {
    final _$result =
        _$v ??
        _$CustomerNewAddressDtoLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerNewAddressDtoLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerNewAddressDtoLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
