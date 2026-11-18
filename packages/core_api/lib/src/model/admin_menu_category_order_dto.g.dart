// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_category_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuCategoryOrderDto extends AdminMenuCategoryOrderDto {
  @override
  final BuiltList<String> categoryIds;

  factory _$AdminMenuCategoryOrderDto([
    void Function(AdminMenuCategoryOrderDtoBuilder)? updates,
  ]) => (AdminMenuCategoryOrderDtoBuilder()..update(updates))._build();

  _$AdminMenuCategoryOrderDto._({required this.categoryIds}) : super._();
  @override
  AdminMenuCategoryOrderDto rebuild(
    void Function(AdminMenuCategoryOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuCategoryOrderDtoBuilder toBuilder() =>
      AdminMenuCategoryOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuCategoryOrderDto &&
        categoryIds == other.categoryIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuCategoryOrderDto',
    )..add('categoryIds', categoryIds)).toString();
  }
}

class AdminMenuCategoryOrderDtoBuilder
    implements
        Builder<AdminMenuCategoryOrderDto, AdminMenuCategoryOrderDtoBuilder> {
  _$AdminMenuCategoryOrderDto? _$v;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  AdminMenuCategoryOrderDtoBuilder() {
    AdminMenuCategoryOrderDto._defaults(this);
  }

  AdminMenuCategoryOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryIds = $v.categoryIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuCategoryOrderDto other) {
    _$v = other as _$AdminMenuCategoryOrderDto;
  }

  @override
  void update(void Function(AdminMenuCategoryOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuCategoryOrderDto build() => _build();

  _$AdminMenuCategoryOrderDto _build() {
    _$AdminMenuCategoryOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuCategoryOrderDto._(categoryIds: categoryIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        categoryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuCategoryOrderDto',
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
