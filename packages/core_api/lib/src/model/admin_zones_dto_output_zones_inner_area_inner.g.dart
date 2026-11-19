// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_zones_dto_output_zones_inner_area_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminZonesDtoOutputZonesInnerAreaInner
    extends AdminZonesDtoOutputZonesInnerAreaInner {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminZonesDtoOutputZonesInnerAreaInner([
    void Function(AdminZonesDtoOutputZonesInnerAreaInnerBuilder)? updates,
  ]) => (AdminZonesDtoOutputZonesInnerAreaInnerBuilder()..update(updates))
      ._build();

  _$AdminZonesDtoOutputZonesInnerAreaInner._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminZonesDtoOutputZonesInnerAreaInner rebuild(
    void Function(AdminZonesDtoOutputZonesInnerAreaInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminZonesDtoOutputZonesInnerAreaInnerBuilder toBuilder() =>
      AdminZonesDtoOutputZonesInnerAreaInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminZonesDtoOutputZonesInnerAreaInner &&
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
            r'AdminZonesDtoOutputZonesInnerAreaInner',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminZonesDtoOutputZonesInnerAreaInnerBuilder
    implements
        Builder<
          AdminZonesDtoOutputZonesInnerAreaInner,
          AdminZonesDtoOutputZonesInnerAreaInnerBuilder
        > {
  _$AdminZonesDtoOutputZonesInnerAreaInner? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminZonesDtoOutputZonesInnerAreaInnerBuilder() {
    AdminZonesDtoOutputZonesInnerAreaInner._defaults(this);
  }

  AdminZonesDtoOutputZonesInnerAreaInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminZonesDtoOutputZonesInnerAreaInner other) {
    _$v = other as _$AdminZonesDtoOutputZonesInnerAreaInner;
  }

  @override
  void update(
    void Function(AdminZonesDtoOutputZonesInnerAreaInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminZonesDtoOutputZonesInnerAreaInner build() => _build();

  _$AdminZonesDtoOutputZonesInnerAreaInner _build() {
    final _$result =
        _$v ??
        _$AdminZonesDtoOutputZonesInnerAreaInner._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminZonesDtoOutputZonesInnerAreaInner',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminZonesDtoOutputZonesInnerAreaInner',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
