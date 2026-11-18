// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_new_home_section_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminNewHomeSectionDto extends AdminNewHomeSectionDto {
  @override
  final String cityId;
  @override
  final String title;
  @override
  final BuiltList<String> restaurantIds;

  factory _$AdminNewHomeSectionDto([
    void Function(AdminNewHomeSectionDtoBuilder)? updates,
  ]) => (AdminNewHomeSectionDtoBuilder()..update(updates))._build();

  _$AdminNewHomeSectionDto._({
    required this.cityId,
    required this.title,
    required this.restaurantIds,
  }) : super._();
  @override
  AdminNewHomeSectionDto rebuild(
    void Function(AdminNewHomeSectionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNewHomeSectionDtoBuilder toBuilder() =>
      AdminNewHomeSectionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNewHomeSectionDto &&
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
    return (newBuiltValueToStringHelper(r'AdminNewHomeSectionDto')
          ..add('cityId', cityId)
          ..add('title', title)
          ..add('restaurantIds', restaurantIds))
        .toString();
  }
}

class AdminNewHomeSectionDtoBuilder
    implements Builder<AdminNewHomeSectionDto, AdminNewHomeSectionDtoBuilder> {
  _$AdminNewHomeSectionDto? _$v;

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

  AdminNewHomeSectionDtoBuilder() {
    AdminNewHomeSectionDto._defaults(this);
  }

  AdminNewHomeSectionDtoBuilder get _$this {
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
  void replace(AdminNewHomeSectionDto other) {
    _$v = other as _$AdminNewHomeSectionDto;
  }

  @override
  void update(void Function(AdminNewHomeSectionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNewHomeSectionDto build() => _build();

  _$AdminNewHomeSectionDto _build() {
    _$AdminNewHomeSectionDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminNewHomeSectionDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminNewHomeSectionDto',
              'cityId',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'AdminNewHomeSectionDto',
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
          r'AdminNewHomeSectionDto',
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
