// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_new_category_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminNewCategoryDto extends AdminNewCategoryDto {
  @override
  final String name;

  factory _$AdminNewCategoryDto([
    void Function(AdminNewCategoryDtoBuilder)? updates,
  ]) => (AdminNewCategoryDtoBuilder()..update(updates))._build();

  _$AdminNewCategoryDto._({required this.name}) : super._();
  @override
  AdminNewCategoryDto rebuild(
    void Function(AdminNewCategoryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNewCategoryDtoBuilder toBuilder() =>
      AdminNewCategoryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNewCategoryDto && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminNewCategoryDto',
    )..add('name', name)).toString();
  }
}

class AdminNewCategoryDtoBuilder
    implements Builder<AdminNewCategoryDto, AdminNewCategoryDtoBuilder> {
  _$AdminNewCategoryDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminNewCategoryDtoBuilder() {
    AdminNewCategoryDto._defaults(this);
  }

  AdminNewCategoryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNewCategoryDto other) {
    _$v = other as _$AdminNewCategoryDto;
  }

  @override
  void update(void Function(AdminNewCategoryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNewCategoryDto build() => _build();

  _$AdminNewCategoryDto _build() {
    final _$result =
        _$v ??
        _$AdminNewCategoryDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminNewCategoryDto',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
