// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_category_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuCategoryOrderDto extends MerchantMenuCategoryOrderDto {
  @override
  final BuiltList<String> categoryIds;

  factory _$MerchantMenuCategoryOrderDto([
    void Function(MerchantMenuCategoryOrderDtoBuilder)? updates,
  ]) => (MerchantMenuCategoryOrderDtoBuilder()..update(updates))._build();

  _$MerchantMenuCategoryOrderDto._({required this.categoryIds}) : super._();
  @override
  MerchantMenuCategoryOrderDto rebuild(
    void Function(MerchantMenuCategoryOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuCategoryOrderDtoBuilder toBuilder() =>
      MerchantMenuCategoryOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuCategoryOrderDto &&
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
      r'MerchantMenuCategoryOrderDto',
    )..add('categoryIds', categoryIds)).toString();
  }
}

class MerchantMenuCategoryOrderDtoBuilder
    implements
        Builder<
          MerchantMenuCategoryOrderDto,
          MerchantMenuCategoryOrderDtoBuilder
        > {
  _$MerchantMenuCategoryOrderDto? _$v;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  MerchantMenuCategoryOrderDtoBuilder() {
    MerchantMenuCategoryOrderDto._defaults(this);
  }

  MerchantMenuCategoryOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryIds = $v.categoryIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuCategoryOrderDto other) {
    _$v = other as _$MerchantMenuCategoryOrderDto;
  }

  @override
  void update(void Function(MerchantMenuCategoryOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuCategoryOrderDto build() => _build();

  _$MerchantMenuCategoryOrderDto _build() {
    _$MerchantMenuCategoryOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuCategoryOrderDto._(categoryIds: categoryIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        categoryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuCategoryOrderDto',
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
