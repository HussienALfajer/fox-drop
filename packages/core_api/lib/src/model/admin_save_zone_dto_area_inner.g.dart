// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_save_zone_dto_area_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSaveZoneDtoAreaInner extends AdminSaveZoneDtoAreaInner {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminSaveZoneDtoAreaInner([
    void Function(AdminSaveZoneDtoAreaInnerBuilder)? updates,
  ]) => (AdminSaveZoneDtoAreaInnerBuilder()..update(updates))._build();

  _$AdminSaveZoneDtoAreaInner._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminSaveZoneDtoAreaInner rebuild(
    void Function(AdminSaveZoneDtoAreaInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSaveZoneDtoAreaInnerBuilder toBuilder() =>
      AdminSaveZoneDtoAreaInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSaveZoneDtoAreaInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSaveZoneDtoAreaInner')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminSaveZoneDtoAreaInnerBuilder
    implements
        Builder<AdminSaveZoneDtoAreaInner, AdminSaveZoneDtoAreaInnerBuilder> {
  _$AdminSaveZoneDtoAreaInner? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminSaveZoneDtoAreaInnerBuilder() {
    AdminSaveZoneDtoAreaInner._defaults(this);
  }

  AdminSaveZoneDtoAreaInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSaveZoneDtoAreaInner other) {
    _$v = other as _$AdminSaveZoneDtoAreaInner;
  }

  @override
  void update(void Function(AdminSaveZoneDtoAreaInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSaveZoneDtoAreaInner build() => _build();

  _$AdminSaveZoneDtoAreaInner _build() {
    final _$result =
        _$v ??
        _$AdminSaveZoneDtoAreaInner._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminSaveZoneDtoAreaInner',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminSaveZoneDtoAreaInner',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
