// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_banner_city_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBannerCityDto extends AdminBannerCityDto {
  @override
  final String cityId;

  factory _$AdminBannerCityDto([
    void Function(AdminBannerCityDtoBuilder)? updates,
  ]) => (AdminBannerCityDtoBuilder()..update(updates))._build();

  _$AdminBannerCityDto._({required this.cityId}) : super._();
  @override
  AdminBannerCityDto rebuild(
    void Function(AdminBannerCityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBannerCityDtoBuilder toBuilder() =>
      AdminBannerCityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBannerCityDto && cityId == other.cityId;
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
      r'AdminBannerCityDto',
    )..add('cityId', cityId)).toString();
  }
}

class AdminBannerCityDtoBuilder
    implements Builder<AdminBannerCityDto, AdminBannerCityDtoBuilder> {
  _$AdminBannerCityDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminBannerCityDtoBuilder() {
    AdminBannerCityDto._defaults(this);
  }

  AdminBannerCityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBannerCityDto other) {
    _$v = other as _$AdminBannerCityDto;
  }

  @override
  void update(void Function(AdminBannerCityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBannerCityDto build() => _build();

  _$AdminBannerCityDto _build() {
    final _$result =
        _$v ??
        _$AdminBannerCityDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminBannerCityDto',
            'cityId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
