// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutput extends MerchantMenuDtoOutput {
  @override
  final BuiltList<MerchantMenuDtoOutputCategoriesInner> categories;
  @override
  final BuiltList<MerchantMenuDtoOutputOptionGroupsInner> optionGroups;

  factory _$MerchantMenuDtoOutput([
    void Function(MerchantMenuDtoOutputBuilder)? updates,
  ]) => (MerchantMenuDtoOutputBuilder()..update(updates))._build();

  _$MerchantMenuDtoOutput._({
    required this.categories,
    required this.optionGroups,
  }) : super._();
  @override
  MerchantMenuDtoOutput rebuild(
    void Function(MerchantMenuDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputBuilder toBuilder() =>
      MerchantMenuDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutput &&
        categories == other.categories &&
        optionGroups == other.optionGroups;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, optionGroups.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantMenuDtoOutput')
          ..add('categories', categories)
          ..add('optionGroups', optionGroups))
        .toString();
  }
}

class MerchantMenuDtoOutputBuilder
    implements Builder<MerchantMenuDtoOutput, MerchantMenuDtoOutputBuilder> {
  _$MerchantMenuDtoOutput? _$v;

  ListBuilder<MerchantMenuDtoOutputCategoriesInner>? _categories;
  ListBuilder<MerchantMenuDtoOutputCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<MerchantMenuDtoOutputCategoriesInner>();
  set categories(
    ListBuilder<MerchantMenuDtoOutputCategoriesInner>? categories,
  ) => _$this._categories = categories;

  ListBuilder<MerchantMenuDtoOutputOptionGroupsInner>? _optionGroups;
  ListBuilder<MerchantMenuDtoOutputOptionGroupsInner> get optionGroups =>
      _$this._optionGroups ??=
          ListBuilder<MerchantMenuDtoOutputOptionGroupsInner>();
  set optionGroups(
    ListBuilder<MerchantMenuDtoOutputOptionGroupsInner>? optionGroups,
  ) => _$this._optionGroups = optionGroups;

  MerchantMenuDtoOutputBuilder() {
    MerchantMenuDtoOutput._defaults(this);
  }

  MerchantMenuDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _optionGroups = $v.optionGroups.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutput other) {
    _$v = other as _$MerchantMenuDtoOutput;
  }

  @override
  void update(void Function(MerchantMenuDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutput build() => _build();

  _$MerchantMenuDtoOutput _build() {
    _$MerchantMenuDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutput._(
            categories: categories.build(),
            optionGroups: optionGroups.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'optionGroups';
        optionGroups.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutput',
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
