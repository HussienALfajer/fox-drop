// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_zones_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutputZonesInner
    extends AdminLiveMapDtoOutputZonesInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool active;
  @override
  final BuiltList<AdminCustomerDtoOutputAddressesInnerLocation> area;

  factory _$AdminLiveMapDtoOutputZonesInner([
    void Function(AdminLiveMapDtoOutputZonesInnerBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputZonesInnerBuilder()..update(updates))._build();

  _$AdminLiveMapDtoOutputZonesInner._({
    required this.id,
    required this.name,
    required this.active,
    required this.area,
  }) : super._();
  @override
  AdminLiveMapDtoOutputZonesInner rebuild(
    void Function(AdminLiveMapDtoOutputZonesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputZonesInnerBuilder toBuilder() =>
      AdminLiveMapDtoOutputZonesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputZonesInner &&
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
    return (newBuiltValueToStringHelper(r'AdminLiveMapDtoOutputZonesInner')
          ..add('id', id)
          ..add('name', name)
          ..add('active', active)
          ..add('area', area))
        .toString();
  }
}

class AdminLiveMapDtoOutputZonesInnerBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputZonesInner,
          AdminLiveMapDtoOutputZonesInnerBuilder
        > {
  _$AdminLiveMapDtoOutputZonesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation>? _area;
  ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation> get area =>
      _$this._area ??=
          ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation>();
  set area(ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation>? area) =>
      _$this._area = area;

  AdminLiveMapDtoOutputZonesInnerBuilder() {
    AdminLiveMapDtoOutputZonesInner._defaults(this);
  }

  AdminLiveMapDtoOutputZonesInnerBuilder get _$this {
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
  void replace(AdminLiveMapDtoOutputZonesInner other) {
    _$v = other as _$AdminLiveMapDtoOutputZonesInner;
  }

  @override
  void update(void Function(AdminLiveMapDtoOutputZonesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputZonesInner build() => _build();

  _$AdminLiveMapDtoOutputZonesInner _build() {
    _$AdminLiveMapDtoOutputZonesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminLiveMapDtoOutputZonesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminLiveMapDtoOutputZonesInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminLiveMapDtoOutputZonesInner',
              'name',
            ),
            active: BuiltValueNullFieldError.checkNotNull(
              active,
              r'AdminLiveMapDtoOutputZonesInner',
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
          r'AdminLiveMapDtoOutputZonesInner',
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
