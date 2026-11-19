// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_orders_inner_to.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutputOrdersInnerTo
    extends AdminLiveMapDtoOutputOrdersInnerTo {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminLiveMapDtoOutputOrdersInnerTo([
    void Function(AdminLiveMapDtoOutputOrdersInnerToBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputOrdersInnerToBuilder()..update(updates))._build();

  _$AdminLiveMapDtoOutputOrdersInnerTo._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminLiveMapDtoOutputOrdersInnerTo rebuild(
    void Function(AdminLiveMapDtoOutputOrdersInnerToBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputOrdersInnerToBuilder toBuilder() =>
      AdminLiveMapDtoOutputOrdersInnerToBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputOrdersInnerTo &&
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
    return (newBuiltValueToStringHelper(r'AdminLiveMapDtoOutputOrdersInnerTo')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminLiveMapDtoOutputOrdersInnerToBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputOrdersInnerTo,
          AdminLiveMapDtoOutputOrdersInnerToBuilder
        > {
  _$AdminLiveMapDtoOutputOrdersInnerTo? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminLiveMapDtoOutputOrdersInnerToBuilder() {
    AdminLiveMapDtoOutputOrdersInnerTo._defaults(this);
  }

  AdminLiveMapDtoOutputOrdersInnerToBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputOrdersInnerTo other) {
    _$v = other as _$AdminLiveMapDtoOutputOrdersInnerTo;
  }

  @override
  void update(
    void Function(AdminLiveMapDtoOutputOrdersInnerToBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputOrdersInnerTo build() => _build();

  _$AdminLiveMapDtoOutputOrdersInnerTo _build() {
    final _$result =
        _$v ??
        _$AdminLiveMapDtoOutputOrdersInnerTo._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminLiveMapDtoOutputOrdersInnerTo',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminLiveMapDtoOutputOrdersInnerTo',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
