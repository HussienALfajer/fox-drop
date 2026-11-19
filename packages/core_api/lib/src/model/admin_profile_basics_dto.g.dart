// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_profile_basics_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminProfileBasicsDto extends AdminProfileBasicsDto {
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final BuiltList<String> categoryIds;
  @override
  final String? description;

  factory _$AdminProfileBasicsDto([
    void Function(AdminProfileBasicsDtoBuilder)? updates,
  ]) => (AdminProfileBasicsDtoBuilder()..update(updates))._build();

  _$AdminProfileBasicsDto._({
    required this.nameAr,
    this.nameEn,
    required this.categoryIds,
    this.description,
  }) : super._();
  @override
  AdminProfileBasicsDto rebuild(
    void Function(AdminProfileBasicsDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminProfileBasicsDtoBuilder toBuilder() =>
      AdminProfileBasicsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminProfileBasicsDto &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        categoryIds == other.categoryIds &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminProfileBasicsDto')
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('categoryIds', categoryIds)
          ..add('description', description))
        .toString();
  }
}

class AdminProfileBasicsDtoBuilder
    implements Builder<AdminProfileBasicsDto, AdminProfileBasicsDtoBuilder> {
  _$AdminProfileBasicsDto? _$v;

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

  AdminProfileBasicsDtoBuilder() {
    AdminProfileBasicsDto._defaults(this);
  }

  AdminProfileBasicsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _categoryIds = $v.categoryIds.toBuilder();
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminProfileBasicsDto other) {
    _$v = other as _$AdminProfileBasicsDto;
  }

  @override
  void update(void Function(AdminProfileBasicsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminProfileBasicsDto build() => _build();

  _$AdminProfileBasicsDto _build() {
    _$AdminProfileBasicsDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminProfileBasicsDto._(
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminProfileBasicsDto',
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
          r'AdminProfileBasicsDto',
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
