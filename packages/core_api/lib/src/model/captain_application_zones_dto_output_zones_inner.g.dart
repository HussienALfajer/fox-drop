// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_zones_dto_output_zones_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationZonesDtoOutputZonesInner
    extends CaptainApplicationZonesDtoOutputZonesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String cityId;
  @override
  final String cityName;

  factory _$CaptainApplicationZonesDtoOutputZonesInner([
    void Function(CaptainApplicationZonesDtoOutputZonesInnerBuilder)? updates,
  ]) => (CaptainApplicationZonesDtoOutputZonesInnerBuilder()..update(updates))
      ._build();

  _$CaptainApplicationZonesDtoOutputZonesInner._({
    required this.id,
    required this.name,
    required this.cityId,
    required this.cityName,
  }) : super._();
  @override
  CaptainApplicationZonesDtoOutputZonesInner rebuild(
    void Function(CaptainApplicationZonesDtoOutputZonesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationZonesDtoOutputZonesInnerBuilder toBuilder() =>
      CaptainApplicationZonesDtoOutputZonesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationZonesDtoOutputZonesInner &&
        id == other.id &&
        name == other.name &&
        cityId == other.cityId &&
        cityName == other.cityName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, cityName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainApplicationZonesDtoOutputZonesInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('cityId', cityId)
          ..add('cityName', cityName))
        .toString();
  }
}

class CaptainApplicationZonesDtoOutputZonesInnerBuilder
    implements
        Builder<
          CaptainApplicationZonesDtoOutputZonesInner,
          CaptainApplicationZonesDtoOutputZonesInnerBuilder
        > {
  _$CaptainApplicationZonesDtoOutputZonesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _cityName;
  String? get cityName => _$this._cityName;
  set cityName(String? cityName) => _$this._cityName = cityName;

  CaptainApplicationZonesDtoOutputZonesInnerBuilder() {
    CaptainApplicationZonesDtoOutputZonesInner._defaults(this);
  }

  CaptainApplicationZonesDtoOutputZonesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _cityId = $v.cityId;
      _cityName = $v.cityName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationZonesDtoOutputZonesInner other) {
    _$v = other as _$CaptainApplicationZonesDtoOutputZonesInner;
  }

  @override
  void update(
    void Function(CaptainApplicationZonesDtoOutputZonesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationZonesDtoOutputZonesInner build() => _build();

  _$CaptainApplicationZonesDtoOutputZonesInner _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationZonesDtoOutputZonesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CaptainApplicationZonesDtoOutputZonesInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CaptainApplicationZonesDtoOutputZonesInner',
            'name',
          ),
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'CaptainApplicationZonesDtoOutputZonesInner',
            'cityId',
          ),
          cityName: BuiltValueNullFieldError.checkNotNull(
            cityName,
            r'CaptainApplicationZonesDtoOutputZonesInner',
            'cityName',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
