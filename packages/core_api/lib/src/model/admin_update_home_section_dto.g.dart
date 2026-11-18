// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_update_home_section_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUpdateHomeSectionDto extends AdminUpdateHomeSectionDto {
  @override
  final String cityId;
  @override
  final String title;
  @override
  final BuiltList<String> restaurantIds;

  factory _$AdminUpdateHomeSectionDto([
    void Function(AdminUpdateHomeSectionDtoBuilder)? updates,
  ]) => (AdminUpdateHomeSectionDtoBuilder()..update(updates))._build();

  _$AdminUpdateHomeSectionDto._({
    required this.cityId,
    required this.title,
    required this.restaurantIds,
  }) : super._();
  @override
  AdminUpdateHomeSectionDto rebuild(
    void Function(AdminUpdateHomeSectionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUpdateHomeSectionDtoBuilder toBuilder() =>
      AdminUpdateHomeSectionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUpdateHomeSectionDto &&
        cityId == other.cityId &&
        title == other.title &&
        restaurantIds == other.restaurantIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, restaurantIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUpdateHomeSectionDto')
          ..add('cityId', cityId)
          ..add('title', title)
          ..add('restaurantIds', restaurantIds))
        .toString();
  }
}

class AdminUpdateHomeSectionDtoBuilder
    implements
        Builder<AdminUpdateHomeSectionDto, AdminUpdateHomeSectionDtoBuilder> {
  _$AdminUpdateHomeSectionDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  AdminUpdateHomeSectionDtoBuilder() {
    AdminUpdateHomeSectionDto._defaults(this);
  }

  AdminUpdateHomeSectionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _title = $v.title;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUpdateHomeSectionDto other) {
    _$v = other as _$AdminUpdateHomeSectionDto;
  }

  @override
  void update(void Function(AdminUpdateHomeSectionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUpdateHomeSectionDto build() => _build();

  _$AdminUpdateHomeSectionDto _build() {
    _$AdminUpdateHomeSectionDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminUpdateHomeSectionDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminUpdateHomeSectionDto',
              'cityId',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'AdminUpdateHomeSectionDto',
              'title',
            ),
            restaurantIds: restaurantIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurantIds';
        restaurantIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminUpdateHomeSectionDto',
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
