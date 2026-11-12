// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_city_office_dto_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetCityOfficeDtoLocation extends AdminSetCityOfficeDtoLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminSetCityOfficeDtoLocation([
    void Function(AdminSetCityOfficeDtoLocationBuilder)? updates,
  ]) => (AdminSetCityOfficeDtoLocationBuilder()..update(updates))._build();

  _$AdminSetCityOfficeDtoLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminSetCityOfficeDtoLocation rebuild(
    void Function(AdminSetCityOfficeDtoLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetCityOfficeDtoLocationBuilder toBuilder() =>
      AdminSetCityOfficeDtoLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetCityOfficeDtoLocation &&
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
    return (newBuiltValueToStringHelper(r'AdminSetCityOfficeDtoLocation')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminSetCityOfficeDtoLocationBuilder
    implements
        Builder<
          AdminSetCityOfficeDtoLocation,
          AdminSetCityOfficeDtoLocationBuilder
        > {
  _$AdminSetCityOfficeDtoLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminSetCityOfficeDtoLocationBuilder() {
    AdminSetCityOfficeDtoLocation._defaults(this);
  }

  AdminSetCityOfficeDtoLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetCityOfficeDtoLocation other) {
    _$v = other as _$AdminSetCityOfficeDtoLocation;
  }

  @override
  void update(void Function(AdminSetCityOfficeDtoLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetCityOfficeDtoLocation build() => _build();

  _$AdminSetCityOfficeDtoLocation _build() {
    final _$result =
        _$v ??
        _$AdminSetCityOfficeDtoLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminSetCityOfficeDtoLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminSetCityOfficeDtoLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
