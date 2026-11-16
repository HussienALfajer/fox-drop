// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_extend_promo_code_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminExtendPromoCodeDto extends AdminExtendPromoCodeDto {
  @override
  final String cityId;
  @override
  final DateTime validTo;

  factory _$AdminExtendPromoCodeDto([
    void Function(AdminExtendPromoCodeDtoBuilder)? updates,
  ]) => (AdminExtendPromoCodeDtoBuilder()..update(updates))._build();

  _$AdminExtendPromoCodeDto._({required this.cityId, required this.validTo})
    : super._();
  @override
  AdminExtendPromoCodeDto rebuild(
    void Function(AdminExtendPromoCodeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExtendPromoCodeDtoBuilder toBuilder() =>
      AdminExtendPromoCodeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExtendPromoCodeDto &&
        cityId == other.cityId &&
        validTo == other.validTo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, validTo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminExtendPromoCodeDto')
          ..add('cityId', cityId)
          ..add('validTo', validTo))
        .toString();
  }
}

class AdminExtendPromoCodeDtoBuilder
    implements
        Builder<AdminExtendPromoCodeDto, AdminExtendPromoCodeDtoBuilder> {
  _$AdminExtendPromoCodeDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  DateTime? _validTo;
  DateTime? get validTo => _$this._validTo;
  set validTo(DateTime? validTo) => _$this._validTo = validTo;

  AdminExtendPromoCodeDtoBuilder() {
    AdminExtendPromoCodeDto._defaults(this);
  }

  AdminExtendPromoCodeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _validTo = $v.validTo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExtendPromoCodeDto other) {
    _$v = other as _$AdminExtendPromoCodeDto;
  }

  @override
  void update(void Function(AdminExtendPromoCodeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminExtendPromoCodeDto build() => _build();

  _$AdminExtendPromoCodeDto _build() {
    final _$result =
        _$v ??
        _$AdminExtendPromoCodeDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminExtendPromoCodeDto',
            'cityId',
          ),
          validTo: BuiltValueNullFieldError.checkNotNull(
            validTo,
            r'AdminExtendPromoCodeDto',
            'validTo',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
