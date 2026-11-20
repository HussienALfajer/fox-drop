// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_windows_registration_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantWindowsRegistrationDto extends MerchantWindowsRegistrationDto {
  @override
  final String code;
  @override
  final String deviceId;
  @override
  final String publicKey;

  factory _$MerchantWindowsRegistrationDto([
    void Function(MerchantWindowsRegistrationDtoBuilder)? updates,
  ]) => (MerchantWindowsRegistrationDtoBuilder()..update(updates))._build();

  _$MerchantWindowsRegistrationDto._({
    required this.code,
    required this.deviceId,
    required this.publicKey,
  }) : super._();
  @override
  MerchantWindowsRegistrationDto rebuild(
    void Function(MerchantWindowsRegistrationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantWindowsRegistrationDtoBuilder toBuilder() =>
      MerchantWindowsRegistrationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantWindowsRegistrationDto &&
        code == other.code &&
        deviceId == other.deviceId &&
        publicKey == other.publicKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, publicKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantWindowsRegistrationDto')
          ..add('code', code)
          ..add('deviceId', deviceId)
          ..add('publicKey', publicKey))
        .toString();
  }
}

class MerchantWindowsRegistrationDtoBuilder
    implements
        Builder<
          MerchantWindowsRegistrationDto,
          MerchantWindowsRegistrationDtoBuilder
        > {
  _$MerchantWindowsRegistrationDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _publicKey;
  String? get publicKey => _$this._publicKey;
  set publicKey(String? publicKey) => _$this._publicKey = publicKey;

  MerchantWindowsRegistrationDtoBuilder() {
    MerchantWindowsRegistrationDto._defaults(this);
  }

  MerchantWindowsRegistrationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _deviceId = $v.deviceId;
      _publicKey = $v.publicKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantWindowsRegistrationDto other) {
    _$v = other as _$MerchantWindowsRegistrationDto;
  }

  @override
  void update(void Function(MerchantWindowsRegistrationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantWindowsRegistrationDto build() => _build();

  _$MerchantWindowsRegistrationDto _build() {
    final _$result =
        _$v ??
        _$MerchantWindowsRegistrationDto._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantWindowsRegistrationDto',
            'code',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'MerchantWindowsRegistrationDto',
            'deviceId',
          ),
          publicKey: BuiltValueNullFieldError.checkNotNull(
            publicKey,
            r'MerchantWindowsRegistrationDto',
            'publicKey',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
