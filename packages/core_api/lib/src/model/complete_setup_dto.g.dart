// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_setup_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompleteSetupDto extends CompleteSetupDto {
  @override
  final String token;
  @override
  final String password;
  @override
  final String code;

  factory _$CompleteSetupDto([
    void Function(CompleteSetupDtoBuilder)? updates,
  ]) => (CompleteSetupDtoBuilder()..update(updates))._build();

  _$CompleteSetupDto._({
    required this.token,
    required this.password,
    required this.code,
  }) : super._();
  @override
  CompleteSetupDto rebuild(void Function(CompleteSetupDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompleteSetupDtoBuilder toBuilder() =>
      CompleteSetupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompleteSetupDto &&
        token == other.token &&
        password == other.password &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompleteSetupDto')
          ..add('token', token)
          ..add('password', password)
          ..add('code', code))
        .toString();
  }
}

class CompleteSetupDtoBuilder
    implements Builder<CompleteSetupDto, CompleteSetupDtoBuilder> {
  _$CompleteSetupDto? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CompleteSetupDtoBuilder() {
    CompleteSetupDto._defaults(this);
  }

  CompleteSetupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _password = $v.password;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompleteSetupDto other) {
    _$v = other as _$CompleteSetupDto;
  }

  @override
  void update(void Function(CompleteSetupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompleteSetupDto build() => _build();

  _$CompleteSetupDto _build() {
    final _$result =
        _$v ??
        _$CompleteSetupDto._(
          token: BuiltValueNullFieldError.checkNotNull(
            token,
            r'CompleteSetupDto',
            'token',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'CompleteSetupDto',
            'password',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CompleteSetupDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
