// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_sign_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantSignInDto extends MerchantSignInDto {
  @override
  final String phone;
  @override
  final String deviceId;
  @override
  final String code;

  factory _$MerchantSignInDto([
    void Function(MerchantSignInDtoBuilder)? updates,
  ]) => (MerchantSignInDtoBuilder()..update(updates))._build();

  _$MerchantSignInDto._({
    required this.phone,
    required this.deviceId,
    required this.code,
  }) : super._();
  @override
  MerchantSignInDto rebuild(void Function(MerchantSignInDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantSignInDtoBuilder toBuilder() =>
      MerchantSignInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantSignInDto &&
        phone == other.phone &&
        deviceId == other.deviceId &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantSignInDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId)
          ..add('code', code))
        .toString();
  }
}

class MerchantSignInDtoBuilder
    implements Builder<MerchantSignInDto, MerchantSignInDtoBuilder> {
  _$MerchantSignInDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MerchantSignInDtoBuilder() {
    MerchantSignInDto._defaults(this);
  }

  MerchantSignInDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _deviceId = $v.deviceId;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantSignInDto other) {
    _$v = other as _$MerchantSignInDto;
  }

  @override
  void update(void Function(MerchantSignInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantSignInDto build() => _build();

  _$MerchantSignInDto _build() {
    final _$result =
        _$v ??
        _$MerchantSignInDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'MerchantSignInDto',
            'phone',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'MerchantSignInDto',
            'deviceId',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantSignInDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
