// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_zone_vote_dto_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerZoneVoteDtoLocation extends CustomerZoneVoteDtoLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CustomerZoneVoteDtoLocation([
    void Function(CustomerZoneVoteDtoLocationBuilder)? updates,
  ]) => (CustomerZoneVoteDtoLocationBuilder()..update(updates))._build();

  _$CustomerZoneVoteDtoLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CustomerZoneVoteDtoLocation rebuild(
    void Function(CustomerZoneVoteDtoLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerZoneVoteDtoLocationBuilder toBuilder() =>
      CustomerZoneVoteDtoLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerZoneVoteDtoLocation &&
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
    return (newBuiltValueToStringHelper(r'CustomerZoneVoteDtoLocation')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CustomerZoneVoteDtoLocationBuilder
    implements
        Builder<
          CustomerZoneVoteDtoLocation,
          CustomerZoneVoteDtoLocationBuilder
        > {
  _$CustomerZoneVoteDtoLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CustomerZoneVoteDtoLocationBuilder() {
    CustomerZoneVoteDtoLocation._defaults(this);
  }

  CustomerZoneVoteDtoLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerZoneVoteDtoLocation other) {
    _$v = other as _$CustomerZoneVoteDtoLocation;
  }

  @override
  void update(void Function(CustomerZoneVoteDtoLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerZoneVoteDtoLocation build() => _build();

  _$CustomerZoneVoteDtoLocation _build() {
    final _$result =
        _$v ??
        _$CustomerZoneVoteDtoLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerZoneVoteDtoLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerZoneVoteDtoLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
