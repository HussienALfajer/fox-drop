// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_portal_sign_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPortalSignInDto extends MerchantPortalSignInDto {
  @override
  final String phone;
  @override
  final String browserId;
  @override
  final String code;

  factory _$MerchantPortalSignInDto([
    void Function(MerchantPortalSignInDtoBuilder)? updates,
  ]) => (MerchantPortalSignInDtoBuilder()..update(updates))._build();

  _$MerchantPortalSignInDto._({
    required this.phone,
    required this.browserId,
    required this.code,
  }) : super._();
  @override
  MerchantPortalSignInDto rebuild(
    void Function(MerchantPortalSignInDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPortalSignInDtoBuilder toBuilder() =>
      MerchantPortalSignInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPortalSignInDto &&
        phone == other.phone &&
        browserId == other.browserId &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, browserId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPortalSignInDto')
          ..add('phone', phone)
          ..add('browserId', browserId)
          ..add('code', code))
        .toString();
  }
}

class MerchantPortalSignInDtoBuilder
    implements
        Builder<MerchantPortalSignInDto, MerchantPortalSignInDtoBuilder> {
  _$MerchantPortalSignInDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _browserId;
  String? get browserId => _$this._browserId;
  set browserId(String? browserId) => _$this._browserId = browserId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MerchantPortalSignInDtoBuilder() {
    MerchantPortalSignInDto._defaults(this);
  }

  MerchantPortalSignInDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _browserId = $v.browserId;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPortalSignInDto other) {
    _$v = other as _$MerchantPortalSignInDto;
  }

  @override
  void update(void Function(MerchantPortalSignInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPortalSignInDto build() => _build();

  _$MerchantPortalSignInDto _build() {
    final _$result =
        _$v ??
        _$MerchantPortalSignInDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'MerchantPortalSignInDto',
            'phone',
          ),
          browserId: BuiltValueNullFieldError.checkNotNull(
            browserId,
            r'MerchantPortalSignInDto',
            'browserId',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantPortalSignInDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
