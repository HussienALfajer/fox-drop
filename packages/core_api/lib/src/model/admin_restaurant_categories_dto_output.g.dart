// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_categories_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantCategoriesDtoOutput
    extends AdminRestaurantCategoriesDtoOutput {
  @override
  final BuiltList<String> categoryIds;

  factory _$AdminRestaurantCategoriesDtoOutput([
    void Function(AdminRestaurantCategoriesDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantCategoriesDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantCategoriesDtoOutput._({required this.categoryIds})
    : super._();
  @override
  AdminRestaurantCategoriesDtoOutput rebuild(
    void Function(AdminRestaurantCategoriesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantCategoriesDtoOutputBuilder toBuilder() =>
      AdminRestaurantCategoriesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantCategoriesDtoOutput &&
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
      r'AdminRestaurantCategoriesDtoOutput',
    )..add('categoryIds', categoryIds)).toString();
  }
}

class AdminRestaurantCategoriesDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantCategoriesDtoOutput,
          AdminRestaurantCategoriesDtoOutputBuilder
        > {
  _$AdminRestaurantCategoriesDtoOutput? _$v;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  AdminRestaurantCategoriesDtoOutputBuilder() {
    AdminRestaurantCategoriesDtoOutput._defaults(this);
  }

  AdminRestaurantCategoriesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryIds = $v.categoryIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantCategoriesDtoOutput other) {
    _$v = other as _$AdminRestaurantCategoriesDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantCategoriesDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantCategoriesDtoOutput build() => _build();

  _$AdminRestaurantCategoriesDtoOutput _build() {
    _$AdminRestaurantCategoriesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantCategoriesDtoOutput._(
            categoryIds: categoryIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        categoryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantCategoriesDtoOutput',
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
