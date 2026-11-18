// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_category_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuCategoryDto extends AdminMenuCategoryDto {
  @override
  final String name;
  @override
  final bool hidden;
  @override
  final AdminMenuWindow? window;

  factory _$AdminMenuCategoryDto([
    void Function(AdminMenuCategoryDtoBuilder)? updates,
  ]) => (AdminMenuCategoryDtoBuilder()..update(updates))._build();

  _$AdminMenuCategoryDto._({
    required this.name,
    required this.hidden,
    this.window,
  }) : super._();
  @override
  AdminMenuCategoryDto rebuild(
    void Function(AdminMenuCategoryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuCategoryDtoBuilder toBuilder() =>
      AdminMenuCategoryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuCategoryDto &&
        name == other.name &&
        hidden == other.hidden &&
        window == other.window;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuCategoryDto')
          ..add('name', name)
          ..add('hidden', hidden)
          ..add('window', window))
        .toString();
  }
}

class AdminMenuCategoryDtoBuilder
    implements Builder<AdminMenuCategoryDto, AdminMenuCategoryDtoBuilder> {
  _$AdminMenuCategoryDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  AdminMenuWindowBuilder? _window;
  AdminMenuWindowBuilder get window =>
      _$this._window ??= AdminMenuWindowBuilder();
  set window(AdminMenuWindowBuilder? window) => _$this._window = window;

  AdminMenuCategoryDtoBuilder() {
    AdminMenuCategoryDto._defaults(this);
  }

  AdminMenuCategoryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _hidden = $v.hidden;
      _window = $v.window?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuCategoryDto other) {
    _$v = other as _$AdminMenuCategoryDto;
  }

  @override
  void update(void Function(AdminMenuCategoryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuCategoryDto build() => _build();

  _$AdminMenuCategoryDto _build() {
    _$AdminMenuCategoryDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuCategoryDto._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuCategoryDto',
              'name',
            ),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'AdminMenuCategoryDto',
              'hidden',
            ),
            window: _window?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'window';
        _window?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuCategoryDto',
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
