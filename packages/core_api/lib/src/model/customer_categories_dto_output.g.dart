// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_categories_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCategoriesDtoOutput extends CustomerCategoriesDtoOutput {
  @override
  final BuiltList<CustomerCategoriesDtoOutputCategoriesInner> categories;

  factory _$CustomerCategoriesDtoOutput([
    void Function(CustomerCategoriesDtoOutputBuilder)? updates,
  ]) => (CustomerCategoriesDtoOutputBuilder()..update(updates))._build();

  _$CustomerCategoriesDtoOutput._({required this.categories}) : super._();
  @override
  CustomerCategoriesDtoOutput rebuild(
    void Function(CustomerCategoriesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCategoriesDtoOutputBuilder toBuilder() =>
      CustomerCategoriesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCategoriesDtoOutput &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerCategoriesDtoOutput',
    )..add('categories', categories)).toString();
  }
}

class CustomerCategoriesDtoOutputBuilder
    implements
        Builder<
          CustomerCategoriesDtoOutput,
          CustomerCategoriesDtoOutputBuilder
        > {
  _$CustomerCategoriesDtoOutput? _$v;

  ListBuilder<CustomerCategoriesDtoOutputCategoriesInner>? _categories;
  ListBuilder<CustomerCategoriesDtoOutputCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<CustomerCategoriesDtoOutputCategoriesInner>();
  set categories(
    ListBuilder<CustomerCategoriesDtoOutputCategoriesInner>? categories,
  ) => _$this._categories = categories;

  CustomerCategoriesDtoOutputBuilder() {
    CustomerCategoriesDtoOutput._defaults(this);
  }

  CustomerCategoriesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCategoriesDtoOutput other) {
    _$v = other as _$CustomerCategoriesDtoOutput;
  }

  @override
  void update(void Function(CustomerCategoriesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCategoriesDtoOutput build() => _build();

  _$CustomerCategoriesDtoOutput _build() {
    _$CustomerCategoriesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerCategoriesDtoOutput._(categories: categories.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerCategoriesDtoOutput',
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
