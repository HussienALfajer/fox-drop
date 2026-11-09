// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_signed_in_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSignedInDtoOutput extends CustomerSignedInDtoOutput {
  @override
  final String accountId;
  @override
  final bool newAccount;
  @override
  final String accessToken;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;

  factory _$CustomerSignedInDtoOutput([
    void Function(CustomerSignedInDtoOutputBuilder)? updates,
  ]) => (CustomerSignedInDtoOutputBuilder()..update(updates))._build();

  _$CustomerSignedInDtoOutput._({
    required this.accountId,
    required this.newAccount,
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  }) : super._();
  @override
  CustomerSignedInDtoOutput rebuild(
    void Function(CustomerSignedInDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSignedInDtoOutputBuilder toBuilder() =>
      CustomerSignedInDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSignedInDtoOutput &&
        accountId == other.accountId &&
        newAccount == other.newAccount &&
        accessToken == other.accessToken &&
        accessTokenExpiresAt == other.accessTokenExpiresAt &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, newAccount.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, accessTokenExpiresAt.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSignedInDtoOutput')
          ..add('accountId', accountId)
          ..add('newAccount', newAccount)
          ..add('accessToken', accessToken)
          ..add('accessTokenExpiresAt', accessTokenExpiresAt)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class CustomerSignedInDtoOutputBuilder
    implements
        Builder<CustomerSignedInDtoOutput, CustomerSignedInDtoOutputBuilder> {
  _$CustomerSignedInDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  bool? _newAccount;
  bool? get newAccount => _$this._newAccount;
  set newAccount(bool? newAccount) => _$this._newAccount = newAccount;

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

  CustomerSignedInDtoOutputBuilder() {
    CustomerSignedInDtoOutput._defaults(this);
  }

  CustomerSignedInDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _newAccount = $v.newAccount;
      _accessToken = $v.accessToken;
      _accessTokenExpiresAt = $v.accessTokenExpiresAt;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSignedInDtoOutput other) {
    _$v = other as _$CustomerSignedInDtoOutput;
  }

  @override
  void update(void Function(CustomerSignedInDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSignedInDtoOutput build() => _build();

  _$CustomerSignedInDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerSignedInDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'CustomerSignedInDtoOutput',
            'accountId',
          ),
          newAccount: BuiltValueNullFieldError.checkNotNull(
            newAccount,
            r'CustomerSignedInDtoOutput',
            'newAccount',
          ),
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'CustomerSignedInDtoOutput',
            'accessToken',
          ),
          accessTokenExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessTokenExpiresAt,
            r'CustomerSignedInDtoOutput',
            'accessTokenExpiresAt',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'CustomerSignedInDtoOutput',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
