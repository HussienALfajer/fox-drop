// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_update_category_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUpdateCategoryDto extends AdminUpdateCategoryDto {
  @override
  final String name;
  @override
  final bool active;

  factory _$AdminUpdateCategoryDto([
    void Function(AdminUpdateCategoryDtoBuilder)? updates,
  ]) => (AdminUpdateCategoryDtoBuilder()..update(updates))._build();

  _$AdminUpdateCategoryDto._({required this.name, required this.active})
    : super._();
  @override
  AdminUpdateCategoryDto rebuild(
    void Function(AdminUpdateCategoryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUpdateCategoryDtoBuilder toBuilder() =>
      AdminUpdateCategoryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUpdateCategoryDto &&
        name == other.name &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUpdateCategoryDto')
          ..add('name', name)
          ..add('active', active))
        .toString();
  }
}

class AdminUpdateCategoryDtoBuilder
    implements Builder<AdminUpdateCategoryDto, AdminUpdateCategoryDtoBuilder> {
  _$AdminUpdateCategoryDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  AdminUpdateCategoryDtoBuilder() {
    AdminUpdateCategoryDto._defaults(this);
  }

  AdminUpdateCategoryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUpdateCategoryDto other) {
    _$v = other as _$AdminUpdateCategoryDto;
  }

  @override
  void update(void Function(AdminUpdateCategoryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUpdateCategoryDto build() => _build();

  _$AdminUpdateCategoryDto _build() {
    final _$result =
        _$v ??
        _$AdminUpdateCategoryDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminUpdateCategoryDto',
            'name',
          ),
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'AdminUpdateCategoryDto',
            'active',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
