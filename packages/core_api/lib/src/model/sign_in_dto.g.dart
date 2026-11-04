// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignInDto extends SignInDto {
  @override
  final String login;
  @override
  final String password;
  @override
  final String code;

  factory _$SignInDto([void Function(SignInDtoBuilder)? updates]) =>
      (SignInDtoBuilder()..update(updates))._build();

  _$SignInDto._({
    required this.login,
    required this.password,
    required this.code,
  }) : super._();
  @override
  SignInDto rebuild(void Function(SignInDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignInDtoBuilder toBuilder() => SignInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignInDto &&
        login == other.login &&
        password == other.password &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, login.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignInDto')
          ..add('login', login)
          ..add('password', password)
          ..add('code', code))
        .toString();
  }
}

class SignInDtoBuilder implements Builder<SignInDto, SignInDtoBuilder> {
  _$SignInDto? _$v;

  String? _login;
  String? get login => _$this._login;
  set login(String? login) => _$this._login = login;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  SignInDtoBuilder() {
    SignInDto._defaults(this);
  }

  SignInDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _login = $v.login;
      _password = $v.password;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignInDto other) {
    _$v = other as _$SignInDto;
  }

  @override
  void update(void Function(SignInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignInDto build() => _build();

  _$SignInDto _build() {
    final _$result =
        _$v ??
        _$SignInDto._(
          login: BuiltValueNullFieldError.checkNotNull(
            login,
            r'SignInDto',
            'login',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'SignInDto',
            'password',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'SignInDto',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
