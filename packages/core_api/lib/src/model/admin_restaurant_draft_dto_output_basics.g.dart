// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_basics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputBasics
    extends AdminRestaurantDraftDtoOutputBasics {
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final BuiltList<String> categoryIds;
  @override
  final String? description;
  @override
  final String? logoKey;
  @override
  final String? coverKey;

  factory _$AdminRestaurantDraftDtoOutputBasics([
    void Function(AdminRestaurantDraftDtoOutputBasicsBuilder)? updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputBasicsBuilder()..update(updates))._build();

  _$AdminRestaurantDraftDtoOutputBasics._({
    required this.nameAr,
    this.nameEn,
    required this.categoryIds,
    this.description,
    this.logoKey,
    this.coverKey,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputBasics rebuild(
    void Function(AdminRestaurantDraftDtoOutputBasicsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputBasicsBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputBasicsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputBasics &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        categoryIds == other.categoryIds &&
        description == other.description &&
        logoKey == other.logoKey &&
        coverKey == other.coverKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, logoKey.hashCode);
    _$hash = $jc(_$hash, coverKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantDraftDtoOutputBasics')
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('categoryIds', categoryIds)
          ..add('description', description)
          ..add('logoKey', logoKey)
          ..add('coverKey', coverKey))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputBasicsBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputBasics,
          AdminRestaurantDraftDtoOutputBasicsBuilder
        > {
  _$AdminRestaurantDraftDtoOutputBasics? _$v;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _nameEn;
  String? get nameEn => _$this._nameEn;
  set nameEn(String? nameEn) => _$this._nameEn = nameEn;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _logoKey;
  String? get logoKey => _$this._logoKey;
  set logoKey(String? logoKey) => _$this._logoKey = logoKey;

  String? _coverKey;
  String? get coverKey => _$this._coverKey;
  set coverKey(String? coverKey) => _$this._coverKey = coverKey;

  AdminRestaurantDraftDtoOutputBasicsBuilder() {
    AdminRestaurantDraftDtoOutputBasics._defaults(this);
  }

  AdminRestaurantDraftDtoOutputBasicsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _categoryIds = $v.categoryIds.toBuilder();
      _description = $v.description;
      _logoKey = $v.logoKey;
      _coverKey = $v.coverKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputBasics other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputBasics;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputBasicsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputBasics build() => _build();

  _$AdminRestaurantDraftDtoOutputBasics _build() {
    _$AdminRestaurantDraftDtoOutputBasics _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftDtoOutputBasics._(
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminRestaurantDraftDtoOutputBasics',
              'nameAr',
            ),
            nameEn: nameEn,
            categoryIds: categoryIds.build(),
            description: description,
            logoKey: logoKey,
            coverKey: coverKey,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        categoryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftDtoOutputBasics',
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
