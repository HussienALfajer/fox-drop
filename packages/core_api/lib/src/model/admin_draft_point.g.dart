// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftPoint extends AdminDraftPoint {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminDraftPoint([void Function(AdminDraftPointBuilder)? updates]) =>
      (AdminDraftPointBuilder()..update(updates))._build();

  _$AdminDraftPoint._({required this.latitude, required this.longitude})
    : super._();
  @override
  AdminDraftPoint rebuild(void Function(AdminDraftPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDraftPointBuilder toBuilder() => AdminDraftPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftPoint &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftPoint')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminDraftPointBuilder
    implements Builder<AdminDraftPoint, AdminDraftPointBuilder> {
  _$AdminDraftPoint? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminDraftPointBuilder() {
    AdminDraftPoint._defaults(this);
  }

  AdminDraftPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftPoint other) {
    _$v = other as _$AdminDraftPoint;
  }

  @override
  void update(void Function(AdminDraftPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftPoint build() => _build();

  _$AdminDraftPoint _build() {
    final _$result =
        _$v ??
        _$AdminDraftPoint._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminDraftPoint',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminDraftPoint',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
