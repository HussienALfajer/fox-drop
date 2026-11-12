// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_office_dto_output_office_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityOfficeDtoOutputOfficeLocation
    extends AdminCityOfficeDtoOutputOfficeLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminCityOfficeDtoOutputOfficeLocation([
    void Function(AdminCityOfficeDtoOutputOfficeLocationBuilder)? updates,
  ]) => (AdminCityOfficeDtoOutputOfficeLocationBuilder()..update(updates))
      ._build();

  _$AdminCityOfficeDtoOutputOfficeLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminCityOfficeDtoOutputOfficeLocation rebuild(
    void Function(AdminCityOfficeDtoOutputOfficeLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityOfficeDtoOutputOfficeLocationBuilder toBuilder() =>
      AdminCityOfficeDtoOutputOfficeLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityOfficeDtoOutputOfficeLocation &&
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
            r'AdminCityOfficeDtoOutputOfficeLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminCityOfficeDtoOutputOfficeLocationBuilder
    implements
        Builder<
          AdminCityOfficeDtoOutputOfficeLocation,
          AdminCityOfficeDtoOutputOfficeLocationBuilder
        > {
  _$AdminCityOfficeDtoOutputOfficeLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminCityOfficeDtoOutputOfficeLocationBuilder() {
    AdminCityOfficeDtoOutputOfficeLocation._defaults(this);
  }

  AdminCityOfficeDtoOutputOfficeLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityOfficeDtoOutputOfficeLocation other) {
    _$v = other as _$AdminCityOfficeDtoOutputOfficeLocation;
  }

  @override
  void update(
    void Function(AdminCityOfficeDtoOutputOfficeLocationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityOfficeDtoOutputOfficeLocation build() => _build();

  _$AdminCityOfficeDtoOutputOfficeLocation _build() {
    final _$result =
        _$v ??
        _$AdminCityOfficeDtoOutputOfficeLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminCityOfficeDtoOutputOfficeLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminCityOfficeDtoOutputOfficeLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
