// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_tokens_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainTokensDtoOutput extends CaptainTokensDtoOutput {
  @override
  final String accessToken;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;

  factory _$CaptainTokensDtoOutput([
    void Function(CaptainTokensDtoOutputBuilder)? updates,
  ]) => (CaptainTokensDtoOutputBuilder()..update(updates))._build();

  _$CaptainTokensDtoOutput._({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  }) : super._();
  @override
  CaptainTokensDtoOutput rebuild(
    void Function(CaptainTokensDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainTokensDtoOutputBuilder toBuilder() =>
      CaptainTokensDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainTokensDtoOutput &&
        accessToken == other.accessToken &&
        accessTokenExpiresAt == other.accessTokenExpiresAt &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, accessTokenExpiresAt.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainTokensDtoOutput')
          ..add('accessToken', accessToken)
          ..add('accessTokenExpiresAt', accessTokenExpiresAt)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class CaptainTokensDtoOutputBuilder
    implements Builder<CaptainTokensDtoOutput, CaptainTokensDtoOutputBuilder> {
  _$CaptainTokensDtoOutput? _$v;

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

  CaptainTokensDtoOutputBuilder() {
    CaptainTokensDtoOutput._defaults(this);
  }

  CaptainTokensDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _accessTokenExpiresAt = $v.accessTokenExpiresAt;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainTokensDtoOutput other) {
    _$v = other as _$CaptainTokensDtoOutput;
  }

  @override
  void update(void Function(CaptainTokensDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainTokensDtoOutput build() => _build();

  _$CaptainTokensDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainTokensDtoOutput._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'CaptainTokensDtoOutput',
            'accessToken',
          ),
          accessTokenExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessTokenExpiresAt,
            r'CaptainTokensDtoOutput',
            'accessTokenExpiresAt',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'CaptainTokensDtoOutput',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
