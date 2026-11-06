// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_restaurant_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderRestaurantLocation
    extends CaptainActiveOrderDtoOutputOrderRestaurantLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CaptainActiveOrderDtoOutputOrderRestaurantLocation([
    void Function(CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderRestaurantLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderRestaurantLocation rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderRestaurantLocation &&
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
            r'CaptainActiveOrderDtoOutputOrderRestaurantLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderRestaurantLocation,
          CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderRestaurantLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder() {
    CaptainActiveOrderDtoOutputOrderRestaurantLocation._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderRestaurantLocation other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderRestaurantLocation;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderRestaurantLocation build() => _build();

  _$CaptainActiveOrderDtoOutputOrderRestaurantLocation _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderRestaurantLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainActiveOrderDtoOutputOrderRestaurantLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainActiveOrderDtoOutputOrderRestaurantLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
