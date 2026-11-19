// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_zones_dto_output_zones_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminZonesDtoOutputZonesInner extends AdminZonesDtoOutputZonesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool active;
  @override
  final BuiltList<AdminZonesDtoOutputZonesInnerAreaInner> area;

  factory _$AdminZonesDtoOutputZonesInner([
    void Function(AdminZonesDtoOutputZonesInnerBuilder)? updates,
  ]) => (AdminZonesDtoOutputZonesInnerBuilder()..update(updates))._build();

  _$AdminZonesDtoOutputZonesInner._({
    required this.id,
    required this.name,
    required this.active,
    required this.area,
  }) : super._();
  @override
  AdminZonesDtoOutputZonesInner rebuild(
    void Function(AdminZonesDtoOutputZonesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminZonesDtoOutputZonesInnerBuilder toBuilder() =>
      AdminZonesDtoOutputZonesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminZonesDtoOutputZonesInner &&
        id == other.id &&
        name == other.name &&
        active == other.active &&
        area == other.area;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, area.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminZonesDtoOutputZonesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('active', active)
          ..add('area', area))
        .toString();
  }
}

class AdminZonesDtoOutputZonesInnerBuilder
    implements
        Builder<
          AdminZonesDtoOutputZonesInner,
          AdminZonesDtoOutputZonesInnerBuilder
        > {
  _$AdminZonesDtoOutputZonesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  ListBuilder<AdminZonesDtoOutputZonesInnerAreaInner>? _area;
  ListBuilder<AdminZonesDtoOutputZonesInnerAreaInner> get area =>
      _$this._area ??= ListBuilder<AdminZonesDtoOutputZonesInnerAreaInner>();
  set area(ListBuilder<AdminZonesDtoOutputZonesInnerAreaInner>? area) =>
      _$this._area = area;

  AdminZonesDtoOutputZonesInnerBuilder() {
    AdminZonesDtoOutputZonesInner._defaults(this);
  }

  AdminZonesDtoOutputZonesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _active = $v.active;
      _area = $v.area.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminZonesDtoOutputZonesInner other) {
    _$v = other as _$AdminZonesDtoOutputZonesInner;
  }

  @override
  void update(void Function(AdminZonesDtoOutputZonesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminZonesDtoOutputZonesInner build() => _build();

  _$AdminZonesDtoOutputZonesInner _build() {
    _$AdminZonesDtoOutputZonesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminZonesDtoOutputZonesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminZonesDtoOutputZonesInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminZonesDtoOutputZonesInner',
              'name',
            ),
            active: BuiltValueNullFieldError.checkNotNull(
              active,
              r'AdminZonesDtoOutputZonesInner',
              'active',
            ),
            area: area.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'area';
        area.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminZonesDtoOutputZonesInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
