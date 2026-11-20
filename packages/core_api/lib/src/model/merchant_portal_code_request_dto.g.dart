// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_code_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPortalCodeRequestDto extends MerchantPortalCodeRequestDto {
  @override
  final String phone;
  @override
  final String browserId;

  factory _$MerchantPortalCodeRequestDto([
    void Function(MerchantPortalCodeRequestDtoBuilder)? updates,
  ]) => (MerchantPortalCodeRequestDtoBuilder()..update(updates))._build();

  _$MerchantPortalCodeRequestDto._({
    required this.phone,
    required this.browserId,
  }) : super._();
  @override
  MerchantPortalCodeRequestDto rebuild(
    void Function(MerchantPortalCodeRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalCodeRequestDtoBuilder toBuilder() =>
      MerchantPortalCodeRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalCodeRequestDto &&
        phone == other.phone &&
        browserId == other.browserId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, browserId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPortalCodeRequestDto')
          ..add('phone', phone)
          ..add('browserId', browserId))
        .toString();
  }
}

class MerchantPortalCodeRequestDtoBuilder
    implements
        Builder<
          MerchantPortalCodeRequestDto,
          MerchantPortalCodeRequestDtoBuilder
        > {
  _$MerchantPortalCodeRequestDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _browserId;
  String? get browserId => _$this._browserId;
  set browserId(String? browserId) => _$this._browserId = browserId;

  MerchantPortalCodeRequestDtoBuilder() {
    MerchantPortalCodeRequestDto._defaults(this);
  }

  MerchantPortalCodeRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _browserId = $v.browserId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalCodeRequestDto other) {
    _$v = other as _$MerchantPortalCodeRequestDto;
  }

  @override
  void update(void Function(MerchantPortalCodeRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalCodeRequestDto build() => _build();

  _$MerchantPortalCodeRequestDto _build() {
    final _$result =
        _$v ??
        _$MerchantPortalCodeRequestDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'MerchantPortalCodeRequestDto',
            'phone',
          ),
          browserId: BuiltValueNullFieldError.checkNotNull(
            browserId,
            r'MerchantPortalCodeRequestDto',
            'browserId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
