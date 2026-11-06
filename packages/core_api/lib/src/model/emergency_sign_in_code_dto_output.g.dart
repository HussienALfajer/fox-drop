// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_sign_in_code_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmergencySignInCodeDtoOutput extends EmergencySignInCodeDtoOutput {
  @override
  final String code;
  @override
  final DateTime expiresAt;
  @override
  final String accountId;

  factory _$EmergencySignInCodeDtoOutput([
    void Function(EmergencySignInCodeDtoOutputBuilder)? updates,
  ]) => (EmergencySignInCodeDtoOutputBuilder()..update(updates))._build();

  _$EmergencySignInCodeDtoOutput._({
    required this.code,
    required this.expiresAt,
    required this.accountId,
  }) : super._();
  @override
  EmergencySignInCodeDtoOutput rebuild(
    void Function(EmergencySignInCodeDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmergencySignInCodeDtoOutputBuilder toBuilder() =>
      EmergencySignInCodeDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmergencySignInCodeDtoOutput &&
        code == other.code &&
        expiresAt == other.expiresAt &&
        accountId == other.accountId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmergencySignInCodeDtoOutput')
          ..add('code', code)
          ..add('expiresAt', expiresAt)
          ..add('accountId', accountId))
        .toString();
  }
}

class EmergencySignInCodeDtoOutputBuilder
    implements
        Builder<
          EmergencySignInCodeDtoOutput,
          EmergencySignInCodeDtoOutputBuilder
        > {
  _$EmergencySignInCodeDtoOutput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  EmergencySignInCodeDtoOutputBuilder() {
    EmergencySignInCodeDtoOutput._defaults(this);
  }

  EmergencySignInCodeDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _expiresAt = $v.expiresAt;
      _accountId = $v.accountId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmergencySignInCodeDtoOutput other) {
    _$v = other as _$EmergencySignInCodeDtoOutput;
  }

  @override
  void update(void Function(EmergencySignInCodeDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmergencySignInCodeDtoOutput build() => _build();

  _$EmergencySignInCodeDtoOutput _build() {
    final _$result =
        _$v ??
        _$EmergencySignInCodeDtoOutput._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'EmergencySignInCodeDtoOutput',
            'code',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'EmergencySignInCodeDtoOutput',
            'expiresAt',
          ),
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'EmergencySignInCodeDtoOutput',
            'accountId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
