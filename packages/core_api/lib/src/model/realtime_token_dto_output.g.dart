// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_token_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RealtimeTokenDtoOutput extends RealtimeTokenDtoOutput {
  @override
  final String token;
  @override
  final DateTime expiresAt;

  factory _$RealtimeTokenDtoOutput([
    void Function(RealtimeTokenDtoOutputBuilder)? updates,
  ]) => (RealtimeTokenDtoOutputBuilder()..update(updates))._build();

  _$RealtimeTokenDtoOutput._({required this.token, required this.expiresAt})
    : super._();
  @override
  RealtimeTokenDtoOutput rebuild(
    void Function(RealtimeTokenDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RealtimeTokenDtoOutputBuilder toBuilder() =>
      RealtimeTokenDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RealtimeTokenDtoOutput &&
        token == other.token &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RealtimeTokenDtoOutput')
          ..add('token', token)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class RealtimeTokenDtoOutputBuilder
    implements Builder<RealtimeTokenDtoOutput, RealtimeTokenDtoOutputBuilder> {
  _$RealtimeTokenDtoOutput? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  RealtimeTokenDtoOutputBuilder() {
    RealtimeTokenDtoOutput._defaults(this);
  }

  RealtimeTokenDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RealtimeTokenDtoOutput other) {
    _$v = other as _$RealtimeTokenDtoOutput;
  }

  @override
  void update(void Function(RealtimeTokenDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RealtimeTokenDtoOutput build() => _build();

  _$RealtimeTokenDtoOutput _build() {
    final _$result =
        _$v ??
        _$RealtimeTokenDtoOutput._(
          token: BuiltValueNullFieldError.checkNotNull(
            token,
            r'RealtimeTokenDtoOutput',
            'token',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'RealtimeTokenDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
