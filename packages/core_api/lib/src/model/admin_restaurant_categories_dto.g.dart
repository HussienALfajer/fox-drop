// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_categories_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantCategoriesDto extends AdminRestaurantCategoriesDto {
  @override
  final BuiltList<String> categoryIds;

  factory _$AdminRestaurantCategoriesDto([
    void Function(AdminRestaurantCategoriesDtoBuilder)? updates,
  ]) => (AdminRestaurantCategoriesDtoBuilder()..update(updates))._build();

  _$AdminRestaurantCategoriesDto._({required this.categoryIds}) : super._();
  @override
  AdminRestaurantCategoriesDto rebuild(
    void Function(AdminRestaurantCategoriesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantCategoriesDtoBuilder toBuilder() =>
      AdminRestaurantCategoriesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantCategoriesDto &&
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
      r'AdminRestaurantCategoriesDto',
    )..add('categoryIds', categoryIds)).toString();
  }
}

class AdminRestaurantCategoriesDtoBuilder
    implements
        Builder<
          AdminRestaurantCategoriesDto,
          AdminRestaurantCategoriesDtoBuilder
        > {
  _$AdminRestaurantCategoriesDto? _$v;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  AdminRestaurantCategoriesDtoBuilder() {
    AdminRestaurantCategoriesDto._defaults(this);
  }

  AdminRestaurantCategoriesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryIds = $v.categoryIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantCategoriesDto other) {
    _$v = other as _$AdminRestaurantCategoriesDto;
  }

  @override
  void update(void Function(AdminRestaurantCategoriesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantCategoriesDto build() => _build();

  _$AdminRestaurantCategoriesDto _build() {
    _$AdminRestaurantCategoriesDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantCategoriesDto._(categoryIds: categoryIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        categoryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantCategoriesDto',
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
