// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_mass_push_city_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMassPushCityDto extends AdminMassPushCityDto {
  @override
  final String cityId;

  factory _$AdminMassPushCityDto([
    void Function(AdminMassPushCityDtoBuilder)? updates,
  ]) => (AdminMassPushCityDtoBuilder()..update(updates))._build();

  _$AdminMassPushCityDto._({required this.cityId}) : super._();
  @override
  AdminMassPushCityDto rebuild(
    void Function(AdminMassPushCityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMassPushCityDtoBuilder toBuilder() =>
      AdminMassPushCityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMassPushCityDto && cityId == other.cityId;
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
      r'AdminMassPushCityDto',
    )..add('cityId', cityId)).toString();
  }
}

class AdminMassPushCityDtoBuilder
    implements Builder<AdminMassPushCityDto, AdminMassPushCityDtoBuilder> {
  _$AdminMassPushCityDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminMassPushCityDtoBuilder() {
    AdminMassPushCityDto._defaults(this);
  }

  AdminMassPushCityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMassPushCityDto other) {
    _$v = other as _$AdminMassPushCityDto;
  }

  @override
  void update(void Function(AdminMassPushCityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMassPushCityDto build() => _build();

  _$AdminMassPushCityDto _build() {
    final _$result =
        _$v ??
        _$AdminMassPushCityDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminMassPushCityDto',
            'cityId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
