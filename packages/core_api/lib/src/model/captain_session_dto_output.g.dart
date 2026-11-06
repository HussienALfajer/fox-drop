// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainSessionDtoOutput extends CaptainSessionDtoOutput {
  @override
  final String accountId;
  @override
  final String captainId;
  @override
  final String sessionId;

  factory _$CaptainSessionDtoOutput([
    void Function(CaptainSessionDtoOutputBuilder)? updates,
  ]) => (CaptainSessionDtoOutputBuilder()..update(updates))._build();

  _$CaptainSessionDtoOutput._({
    required this.accountId,
    required this.captainId,
    required this.sessionId,
  }) : super._();
  @override
  CaptainSessionDtoOutput rebuild(
    void Function(CaptainSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainSessionDtoOutputBuilder toBuilder() =>
      CaptainSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainSessionDtoOutput &&
        accountId == other.accountId &&
        captainId == other.captainId &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainSessionDtoOutput')
          ..add('accountId', accountId)
          ..add('captainId', captainId)
          ..add('sessionId', sessionId))
        .toString();
  }
}

class CaptainSessionDtoOutputBuilder
    implements
        Builder<CaptainSessionDtoOutput, CaptainSessionDtoOutputBuilder> {
  _$CaptainSessionDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  CaptainSessionDtoOutputBuilder() {
    CaptainSessionDtoOutput._defaults(this);
  }

  CaptainSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _captainId = $v.captainId;
      _sessionId = $v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainSessionDtoOutput other) {
    _$v = other as _$CaptainSessionDtoOutput;
  }

  @override
  void update(void Function(CaptainSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainSessionDtoOutput build() => _build();

  _$CaptainSessionDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainSessionDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'CaptainSessionDtoOutput',
            'accountId',
          ),
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'CaptainSessionDtoOutput',
            'captainId',
          ),
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'CaptainSessionDtoOutput',
            'sessionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
