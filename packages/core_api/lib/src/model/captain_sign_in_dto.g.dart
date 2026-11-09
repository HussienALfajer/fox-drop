// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_sign_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainSignInDto extends CaptainSignInDto {
  @override
  final String phone;
  @override
  final String deviceId;
  @override
  final String code;

  factory _$CaptainSignInDto([
    void Function(CaptainSignInDtoBuilder)? updates,
  ]) => (CaptainSignInDtoBuilder()..update(updates))._build();

  _$CaptainSignInDto._({
    required this.phone,
    required this.deviceId,
    required this.code,
  }) : super._();
  @override
  CaptainSignInDto rebuild(void Function(CaptainSignInDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CaptainSignInDtoBuilder toBuilder() =>
      CaptainSignInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainSignInDto &&
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
    return (newBuiltValueToStringHelper(r'CaptainSignInDto')
          ..add('phone', phone)
          ..add('deviceId', deviceId)
          ..add('code', code))
        .toString();
  }
}

class CaptainSignInDtoBuilder
    implements Builder<CaptainSignInDto, CaptainSignInDtoBuilder> {
  _$CaptainSignInDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CaptainSignInDtoBuilder() {
    CaptainSignInDto._defaults(this);
  }

  CaptainSignInDtoBuilder get _$this {
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
  void replace(CaptainSignInDto other) {
    _$v = other as _$CaptainSignInDto;
  }

  @override
  void update(void Function(CaptainSignInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainSignInDto build() => _build();

  _$CaptainSignInDto _build() {
    final _$result =
        _$v ??
        _$CaptainSignInDto._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'CaptainSignInDto',
            'phone',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'CaptainSignInDto',
            'deviceId',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CaptainSignInDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
