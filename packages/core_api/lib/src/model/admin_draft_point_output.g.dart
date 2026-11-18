// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_point_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftPointOutput extends AdminDraftPointOutput {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminDraftPointOutput([
    void Function(AdminDraftPointOutputBuilder)? updates,
  ]) => (AdminDraftPointOutputBuilder()..update(updates))._build();

  _$AdminDraftPointOutput._({required this.latitude, required this.longitude})
    : super._();
  @override
  AdminDraftPointOutput rebuild(
    void Function(AdminDraftPointOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftPointOutputBuilder toBuilder() =>
      AdminDraftPointOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftPointOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftPointOutput')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminDraftPointOutputBuilder
    implements Builder<AdminDraftPointOutput, AdminDraftPointOutputBuilder> {
  _$AdminDraftPointOutput? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminDraftPointOutputBuilder() {
    AdminDraftPointOutput._defaults(this);
  }

  AdminDraftPointOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftPointOutput other) {
    _$v = other as _$AdminDraftPointOutput;
  }

  @override
  void update(void Function(AdminDraftPointOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftPointOutput build() => _build();

  _$AdminDraftPointOutput _build() {
    final _$result =
        _$v ??
        _$AdminDraftPointOutput._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminDraftPointOutput',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminDraftPointOutput',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
