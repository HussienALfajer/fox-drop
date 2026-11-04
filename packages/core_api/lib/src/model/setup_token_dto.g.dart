// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_token_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetupTokenDto extends SetupTokenDto {
  @override
  final String token;

  factory _$SetupTokenDto([void Function(SetupTokenDtoBuilder)? updates]) =>
      (SetupTokenDtoBuilder()..update(updates))._build();

  _$SetupTokenDto._({required this.token}) : super._();
  @override
  SetupTokenDto rebuild(void Function(SetupTokenDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetupTokenDtoBuilder toBuilder() => SetupTokenDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetupTokenDto && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SetupTokenDto',
    )..add('token', token)).toString();
  }
}

class SetupTokenDtoBuilder
    implements Builder<SetupTokenDto, SetupTokenDtoBuilder> {
  _$SetupTokenDto? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  SetupTokenDtoBuilder() {
    SetupTokenDto._defaults(this);
  }

  SetupTokenDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetupTokenDto other) {
    _$v = other as _$SetupTokenDto;
  }

  @override
  void update(void Function(SetupTokenDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetupTokenDto build() => _build();

  _$SetupTokenDto _build() {
    final _$result =
        _$v ??
        _$SetupTokenDto._(
          token: BuiltValueNullFieldError.checkNotNull(
            token,
            r'SetupTokenDto',
            'token',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
