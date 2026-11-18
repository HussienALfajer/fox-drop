// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_categories_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCategoriesDtoOutput extends AdminCategoriesDtoOutput {
  @override
  final BuiltList<AdminCategoriesDtoOutputCategoriesInner> categories;

  factory _$AdminCategoriesDtoOutput([
    void Function(AdminCategoriesDtoOutputBuilder)? updates,
  ]) => (AdminCategoriesDtoOutputBuilder()..update(updates))._build();

  _$AdminCategoriesDtoOutput._({required this.categories}) : super._();
  @override
  AdminCategoriesDtoOutput rebuild(
    void Function(AdminCategoriesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCategoriesDtoOutputBuilder toBuilder() =>
      AdminCategoriesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCategoriesDtoOutput && categories == other.categories;
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
      r'AdminCategoriesDtoOutput',
    )..add('categories', categories)).toString();
  }
}

class AdminCategoriesDtoOutputBuilder
    implements
        Builder<AdminCategoriesDtoOutput, AdminCategoriesDtoOutputBuilder> {
  _$AdminCategoriesDtoOutput? _$v;

  ListBuilder<AdminCategoriesDtoOutputCategoriesInner>? _categories;
  ListBuilder<AdminCategoriesDtoOutputCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<AdminCategoriesDtoOutputCategoriesInner>();
  set categories(
    ListBuilder<AdminCategoriesDtoOutputCategoriesInner>? categories,
  ) => _$this._categories = categories;

  AdminCategoriesDtoOutputBuilder() {
    AdminCategoriesDtoOutput._defaults(this);
  }

  AdminCategoriesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCategoriesDtoOutput other) {
    _$v = other as _$AdminCategoriesDtoOutput;
  }

  @override
  void update(void Function(AdminCategoriesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCategoriesDtoOutput build() => _build();

  _$AdminCategoriesDtoOutput _build() {
    _$AdminCategoriesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCategoriesDtoOutput._(categories: categories.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCategoriesDtoOutput',
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
