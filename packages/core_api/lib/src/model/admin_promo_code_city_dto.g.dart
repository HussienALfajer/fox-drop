// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promo_code_city_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPromoCodeCityDto extends AdminPromoCodeCityDto {
  @override
  final String cityId;

  factory _$AdminPromoCodeCityDto([
    void Function(AdminPromoCodeCityDtoBuilder)? updates,
  ]) => (AdminPromoCodeCityDtoBuilder()..update(updates))._build();

  _$AdminPromoCodeCityDto._({required this.cityId}) : super._();
  @override
  AdminPromoCodeCityDto rebuild(
    void Function(AdminPromoCodeCityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPromoCodeCityDtoBuilder toBuilder() =>
      AdminPromoCodeCityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPromoCodeCityDto && cityId == other.cityId;
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
      r'AdminPromoCodeCityDto',
    )..add('cityId', cityId)).toString();
  }
}

class AdminPromoCodeCityDtoBuilder
    implements Builder<AdminPromoCodeCityDto, AdminPromoCodeCityDtoBuilder> {
  _$AdminPromoCodeCityDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminPromoCodeCityDtoBuilder() {
    AdminPromoCodeCityDto._defaults(this);
  }

  AdminPromoCodeCityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPromoCodeCityDto other) {
    _$v = other as _$AdminPromoCodeCityDto;
  }

  @override
  void update(void Function(AdminPromoCodeCityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPromoCodeCityDto build() => _build();

  _$AdminPromoCodeCityDto _build() {
    final _$result =
        _$v ??
        _$AdminPromoCodeCityDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminPromoCodeCityDto',
            'cityId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
