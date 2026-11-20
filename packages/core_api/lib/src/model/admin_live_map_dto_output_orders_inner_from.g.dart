// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_orders_inner_from.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutputOrdersInnerFrom
    extends AdminLiveMapDtoOutputOrdersInnerFrom {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminLiveMapDtoOutputOrdersInnerFrom([
    void Function(AdminLiveMapDtoOutputOrdersInnerFromBuilder)? updates,
  ]) =>
      (AdminLiveMapDtoOutputOrdersInnerFromBuilder()..update(updates))._build();

  _$AdminLiveMapDtoOutputOrdersInnerFrom._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminLiveMapDtoOutputOrdersInnerFrom rebuild(
    void Function(AdminLiveMapDtoOutputOrdersInnerFromBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputOrdersInnerFromBuilder toBuilder() =>
      AdminLiveMapDtoOutputOrdersInnerFromBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputOrdersInnerFrom &&
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
    return (newBuiltValueToStringHelper(r'AdminLiveMapDtoOutputOrdersInnerFrom')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminLiveMapDtoOutputOrdersInnerFromBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputOrdersInnerFrom,
          AdminLiveMapDtoOutputOrdersInnerFromBuilder
        > {
  _$AdminLiveMapDtoOutputOrdersInnerFrom? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminLiveMapDtoOutputOrdersInnerFromBuilder() {
    AdminLiveMapDtoOutputOrdersInnerFrom._defaults(this);
  }

  AdminLiveMapDtoOutputOrdersInnerFromBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputOrdersInnerFrom other) {
    _$v = other as _$AdminLiveMapDtoOutputOrdersInnerFrom;
  }

  @override
  void update(
    void Function(AdminLiveMapDtoOutputOrdersInnerFromBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputOrdersInnerFrom build() => _build();

  _$AdminLiveMapDtoOutputOrdersInnerFrom _build() {
    final _$result =
        _$v ??
        _$AdminLiveMapDtoOutputOrdersInnerFrom._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminLiveMapDtoOutputOrdersInnerFrom',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminLiveMapDtoOutputOrdersInnerFrom',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
