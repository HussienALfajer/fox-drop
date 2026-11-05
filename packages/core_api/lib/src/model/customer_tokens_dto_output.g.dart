// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_tokens_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerTokensDtoOutput extends CustomerTokensDtoOutput {
  @override
  final String accessToken;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;

  factory _$CustomerTokensDtoOutput([
    void Function(CustomerTokensDtoOutputBuilder)? updates,
  ]) => (CustomerTokensDtoOutputBuilder()..update(updates))._build();

  _$CustomerTokensDtoOutput._({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  }) : super._();
  @override
  CustomerTokensDtoOutput rebuild(
    void Function(CustomerTokensDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerTokensDtoOutputBuilder toBuilder() =>
      CustomerTokensDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerTokensDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CustomerTokensDtoOutput')
          ..add('accessToken', accessToken)
          ..add('accessTokenExpiresAt', accessTokenExpiresAt)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class CustomerTokensDtoOutputBuilder
    implements
        Builder<CustomerTokensDtoOutput, CustomerTokensDtoOutputBuilder> {
  _$CustomerTokensDtoOutput? _$v;

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

  CustomerTokensDtoOutputBuilder() {
    CustomerTokensDtoOutput._defaults(this);
  }

  CustomerTokensDtoOutputBuilder get _$this {
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
  void replace(CustomerTokensDtoOutput other) {
    _$v = other as _$CustomerTokensDtoOutput;
  }

  @override
  void update(void Function(CustomerTokensDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerTokensDtoOutput build() => _build();

  _$CustomerTokensDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerTokensDtoOutput._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'CustomerTokensDtoOutput',
            'accessToken',
          ),
          accessTokenExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessTokenExpiresAt,
            r'CustomerTokensDtoOutput',
            'accessTokenExpiresAt',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'CustomerTokensDtoOutput',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
