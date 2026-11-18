// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_basics_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftBasicsDto extends AdminDraftBasicsDto {
  @override
  final String cityId;
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final BuiltList<String> categoryIds;
  @override
  final String? description;

  factory _$AdminDraftBasicsDto([
    void Function(AdminDraftBasicsDtoBuilder)? updates,
  ]) => (AdminDraftBasicsDtoBuilder()..update(updates))._build();

  _$AdminDraftBasicsDto._({
    required this.cityId,
    required this.nameAr,
    this.nameEn,
    required this.categoryIds,
    this.description,
  }) : super._();
  @override
  AdminDraftBasicsDto rebuild(
    void Function(AdminDraftBasicsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftBasicsDtoBuilder toBuilder() =>
      AdminDraftBasicsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftBasicsDto &&
        cityId == other.cityId &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        categoryIds == other.categoryIds &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftBasicsDto')
          ..add('cityId', cityId)
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('categoryIds', categoryIds)
          ..add('description', description))
        .toString();
  }
}

class AdminDraftBasicsDtoBuilder
    implements Builder<AdminDraftBasicsDto, AdminDraftBasicsDtoBuilder> {
  _$AdminDraftBasicsDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

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

  AdminDraftBasicsDtoBuilder() {
    AdminDraftBasicsDto._defaults(this);
  }

  AdminDraftBasicsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _categoryIds = $v.categoryIds.toBuilder();
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftBasicsDto other) {
    _$v = other as _$AdminDraftBasicsDto;
  }

  @override
  void update(void Function(AdminDraftBasicsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftBasicsDto build() => _build();

  _$AdminDraftBasicsDto _build() {
    _$AdminDraftBasicsDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftBasicsDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminDraftBasicsDto',
              'cityId',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminDraftBasicsDto',
              'nameAr',
            ),
            nameEn: nameEn,
            categoryIds: categoryIds.build(),
            description: description,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categoryIds';
        categoryIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDraftBasicsDto',
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
