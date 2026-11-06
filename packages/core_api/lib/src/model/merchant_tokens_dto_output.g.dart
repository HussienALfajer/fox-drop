// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_tokens_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantTokensDtoOutput extends MerchantTokensDtoOutput {
  @override
  final String accessToken;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;

  factory _$MerchantTokensDtoOutput([
    void Function(MerchantTokensDtoOutputBuilder)? updates,
  ]) => (MerchantTokensDtoOutputBuilder()..update(updates))._build();

  _$MerchantTokensDtoOutput._({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  }) : super._();
  @override
  MerchantTokensDtoOutput rebuild(
    void Function(MerchantTokensDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantTokensDtoOutputBuilder toBuilder() =>
      MerchantTokensDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantTokensDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantTokensDtoOutput')
          ..add('accessToken', accessToken)
          ..add('accessTokenExpiresAt', accessTokenExpiresAt)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class MerchantTokensDtoOutputBuilder
    implements
        Builder<MerchantTokensDtoOutput, MerchantTokensDtoOutputBuilder> {
  _$MerchantTokensDtoOutput? _$v;

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

  MerchantTokensDtoOutputBuilder() {
    MerchantTokensDtoOutput._defaults(this);
  }

  MerchantTokensDtoOutputBuilder get _$this {
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
  void replace(MerchantTokensDtoOutput other) {
    _$v = other as _$MerchantTokensDtoOutput;
  }

  @override
  void update(void Function(MerchantTokensDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantTokensDtoOutput build() => _build();

  _$MerchantTokensDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantTokensDtoOutput._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'MerchantTokensDtoOutput',
            'accessToken',
          ),
          accessTokenExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessTokenExpiresAt,
            r'MerchantTokensDtoOutput',
            'accessTokenExpiresAt',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'MerchantTokensDtoOutput',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
