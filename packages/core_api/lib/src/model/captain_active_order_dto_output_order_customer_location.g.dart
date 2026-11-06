// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_customer_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderCustomerLocation
    extends CaptainActiveOrderDtoOutputOrderCustomerLocation {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$CaptainActiveOrderDtoOutputOrderCustomerLocation([
    void Function(CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderCustomerLocation._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCustomerLocation rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCustomerLocation &&
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
            r'CaptainActiveOrderDtoOutputOrderCustomerLocation',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCustomerLocation,
          CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCustomerLocation? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder() {
    CaptainActiveOrderDtoOutputOrderCustomerLocation._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCustomerLocation other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCustomerLocation;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomerLocation build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCustomerLocation _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderCustomerLocation._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CaptainActiveOrderDtoOutputOrderCustomerLocation',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CaptainActiveOrderDtoOutputOrderCustomerLocation',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
