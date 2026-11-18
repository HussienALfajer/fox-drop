// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_home_section_city_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHomeSectionCityDto extends AdminHomeSectionCityDto {
  @override
  final String cityId;

  factory _$AdminHomeSectionCityDto([
    void Function(AdminHomeSectionCityDtoBuilder)? updates,
  ]) => (AdminHomeSectionCityDtoBuilder()..update(updates))._build();

  _$AdminHomeSectionCityDto._({required this.cityId}) : super._();
  @override
  AdminHomeSectionCityDto rebuild(
    void Function(AdminHomeSectionCityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHomeSectionCityDtoBuilder toBuilder() =>
      AdminHomeSectionCityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHomeSectionCityDto && cityId == other.cityId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminHomeSectionCityDto',
    )..add('cityId', cityId)).toString();
  }
}

class AdminHomeSectionCityDtoBuilder
    implements
        Builder<AdminHomeSectionCityDto, AdminHomeSectionCityDtoBuilder> {
  _$AdminHomeSectionCityDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminHomeSectionCityDtoBuilder() {
    AdminHomeSectionCityDto._defaults(this);
  }

  AdminHomeSectionCityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHomeSectionCityDto other) {
    _$v = other as _$AdminHomeSectionCityDto;
  }

  @override
  void update(void Function(AdminHomeSectionCityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHomeSectionCityDto build() => _build();

  _$AdminHomeSectionCityDto _build() {
    final _$result =
        _$v ??
        _$AdminHomeSectionCityDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminHomeSectionCityDto',
            'cityId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
