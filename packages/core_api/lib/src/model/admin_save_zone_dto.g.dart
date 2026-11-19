// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_save_zone_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSaveZoneDto extends AdminSaveZoneDto {
  @override
  final String name;
  @override
  final BuiltList<AdminSaveZoneDtoAreaInner> area;
  @override
  final bool active;
  @override
  final String? reason;

  factory _$AdminSaveZoneDto([
    void Function(AdminSaveZoneDtoBuilder)? updates,
  ]) => (AdminSaveZoneDtoBuilder()..update(updates))._build();

  _$AdminSaveZoneDto._({
    required this.name,
    required this.area,
    required this.active,
    this.reason,
  }) : super._();
  @override
  AdminSaveZoneDto rebuild(void Function(AdminSaveZoneDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSaveZoneDtoBuilder toBuilder() =>
      AdminSaveZoneDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSaveZoneDto &&
        name == other.name &&
        area == other.area &&
        active == other.active &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, area.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSaveZoneDto')
          ..add('name', name)
          ..add('area', area)
          ..add('active', active)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSaveZoneDtoBuilder
    implements Builder<AdminSaveZoneDto, AdminSaveZoneDtoBuilder> {
  _$AdminSaveZoneDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<AdminSaveZoneDtoAreaInner>? _area;
  ListBuilder<AdminSaveZoneDtoAreaInner> get area =>
      _$this._area ??= ListBuilder<AdminSaveZoneDtoAreaInner>();
  set area(ListBuilder<AdminSaveZoneDtoAreaInner>? area) => _$this._area = area;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSaveZoneDtoBuilder() {
    AdminSaveZoneDto._defaults(this);
  }

  AdminSaveZoneDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _area = $v.area.toBuilder();
      _active = $v.active;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSaveZoneDto other) {
    _$v = other as _$AdminSaveZoneDto;
  }

  @override
  void update(void Function(AdminSaveZoneDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSaveZoneDto build() => _build();

  _$AdminSaveZoneDto _build() {
    _$AdminSaveZoneDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminSaveZoneDto._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminSaveZoneDto',
              'name',
            ),
            area: area.build(),
            active: BuiltValueNullFieldError.checkNotNull(
              active,
              r'AdminSaveZoneDto',
              'active',
            ),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'area';
        area.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSaveZoneDto',
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
