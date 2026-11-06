// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_signed_in_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainSignedInDtoOutput extends CaptainSignedInDtoOutput {
  @override
  final String accountId;
  @override
  final String captainId;
  @override
  final String accessToken;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;

  factory _$CaptainSignedInDtoOutput([
    void Function(CaptainSignedInDtoOutputBuilder)? updates,
  ]) => (CaptainSignedInDtoOutputBuilder()..update(updates))._build();

  _$CaptainSignedInDtoOutput._({
    required this.accountId,
    required this.captainId,
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  }) : super._();
  @override
  CaptainSignedInDtoOutput rebuild(
    void Function(CaptainSignedInDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainSignedInDtoOutputBuilder toBuilder() =>
      CaptainSignedInDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainSignedInDtoOutput &&
        accountId == other.accountId &&
        captainId == other.captainId &&
        accessToken == other.accessToken &&
        accessTokenExpiresAt == other.accessTokenExpiresAt &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, accessTokenExpiresAt.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainSignedInDtoOutput')
          ..add('accountId', accountId)
          ..add('captainId', captainId)
          ..add('accessToken', accessToken)
          ..add('accessTokenExpiresAt', accessTokenExpiresAt)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class CaptainSignedInDtoOutputBuilder
    implements
        Builder<CaptainSignedInDtoOutput, CaptainSignedInDtoOutputBuilder> {
  _$CaptainSignedInDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  DateTime? _accessTokenExpiresAt;
  DateTime? get accessTokenExpiresAt => _$this._accessTokenExpiresAt;
  set accessTokenExpiresAt(DateTime? accessTokenExpiresAt) =>
      _$this._accessTokenExpiresAt = accessTokenExpiresAt;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  CaptainSignedInDtoOutputBuilder() {
    CaptainSignedInDtoOutput._defaults(this);
  }

  CaptainSignedInDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _captainId = $v.captainId;
      _accessToken = $v.accessToken;
      _accessTokenExpiresAt = $v.accessTokenExpiresAt;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainSignedInDtoOutput other) {
    _$v = other as _$CaptainSignedInDtoOutput;
  }

  @override
  void update(void Function(CaptainSignedInDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainSignedInDtoOutput build() => _build();

  _$CaptainSignedInDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainSignedInDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'CaptainSignedInDtoOutput',
            'accountId',
          ),
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'CaptainSignedInDtoOutput',
            'captainId',
          ),
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'CaptainSignedInDtoOutput',
            'accessToken',
          ),
          accessTokenExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessTokenExpiresAt,
            r'CaptainSignedInDtoOutput',
            'accessTokenExpiresAt',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'CaptainSignedInDtoOutput',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
