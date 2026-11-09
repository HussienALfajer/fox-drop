// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_images_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantImagesDtoOutput extends AdminRestaurantImagesDtoOutput {
  @override
  final String? logoKey;
  @override
  final String? coverKey;
  @override
  final BuiltList<AdminRestaurantImagesDtoOutputCategoriesInner> categories;

  factory _$AdminRestaurantImagesDtoOutput([
    void Function(AdminRestaurantImagesDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantImagesDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantImagesDtoOutput._({
    this.logoKey,
    this.coverKey,
    required this.categories,
  }) : super._();
  @override
  AdminRestaurantImagesDtoOutput rebuild(
    void Function(AdminRestaurantImagesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantImagesDtoOutputBuilder toBuilder() =>
      AdminRestaurantImagesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantImagesDtoOutput &&
        logoKey == other.logoKey &&
        coverKey == other.coverKey &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, logoKey.hashCode);
    _$hash = $jc(_$hash, coverKey.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantImagesDtoOutput')
          ..add('logoKey', logoKey)
          ..add('coverKey', coverKey)
          ..add('categories', categories))
        .toString();
  }
}

class AdminRestaurantImagesDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantImagesDtoOutput,
          AdminRestaurantImagesDtoOutputBuilder
        > {
  _$AdminRestaurantImagesDtoOutput? _$v;

  String? _logoKey;
  String? get logoKey => _$this._logoKey;
  set logoKey(String? logoKey) => _$this._logoKey = logoKey;

  String? _coverKey;
  String? get coverKey => _$this._coverKey;
  set coverKey(String? coverKey) => _$this._coverKey = coverKey;

  ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInner>? _categories;
  ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInner>();
  set categories(
    ListBuilder<AdminRestaurantImagesDtoOutputCategoriesInner>? categories,
  ) => _$this._categories = categories;

  AdminRestaurantImagesDtoOutputBuilder() {
    AdminRestaurantImagesDtoOutput._defaults(this);
  }

  AdminRestaurantImagesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _logoKey = $v.logoKey;
      _coverKey = $v.coverKey;
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantImagesDtoOutput other) {
    _$v = other as _$AdminRestaurantImagesDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantImagesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantImagesDtoOutput build() => _build();

  _$AdminRestaurantImagesDtoOutput _build() {
    _$AdminRestaurantImagesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantImagesDtoOutput._(
            logoKey: logoKey,
            coverKey: coverKey,
            categories: categories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantImagesDtoOutput',
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
