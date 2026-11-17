// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_devices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputDevicesInner
    extends AdminCustomerDtoOutputDevicesInner {
  @override
  final String deviceId;
  @override
  final DateTime firstSeenAt;
  @override
  final DateTime lastSeenAt;
  @override
  final String? ipAddress;
  @override
  final String? userAgent;
  @override
  final bool blocked;
  @override
  final BuiltList<AdminCustomerDtoOutputDevicesInnerAccountsInner> accounts;
  @override
  final AdminCustomerDtoOutputDevicesInnerLift? lift;

  factory _$AdminCustomerDtoOutputDevicesInner([
    void Function(AdminCustomerDtoOutputDevicesInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputDevicesInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputDevicesInner._({
    required this.deviceId,
    required this.firstSeenAt,
    required this.lastSeenAt,
    this.ipAddress,
    this.userAgent,
    required this.blocked,
    required this.accounts,
    this.lift,
  }) : super._();
  @override
  AdminCustomerDtoOutputDevicesInner rebuild(
    void Function(AdminCustomerDtoOutputDevicesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputDevicesInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputDevicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputDevicesInner &&
        deviceId == other.deviceId &&
        firstSeenAt == other.firstSeenAt &&
        lastSeenAt == other.lastSeenAt &&
        ipAddress == other.ipAddress &&
        userAgent == other.userAgent &&
        blocked == other.blocked &&
        accounts == other.accounts &&
        lift == other.lift;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, firstSeenAt.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, userAgent.hashCode);
    _$hash = $jc(_$hash, blocked.hashCode);
    _$hash = $jc(_$hash, accounts.hashCode);
    _$hash = $jc(_$hash, lift.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputDevicesInner')
          ..add('deviceId', deviceId)
          ..add('firstSeenAt', firstSeenAt)
          ..add('lastSeenAt', lastSeenAt)
          ..add('ipAddress', ipAddress)
          ..add('userAgent', userAgent)
          ..add('blocked', blocked)
          ..add('accounts', accounts)
          ..add('lift', lift))
        .toString();
  }
}

class AdminCustomerDtoOutputDevicesInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputDevicesInner,
          AdminCustomerDtoOutputDevicesInnerBuilder
        > {
  _$AdminCustomerDtoOutputDevicesInner? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  DateTime? _firstSeenAt;
  DateTime? get firstSeenAt => _$this._firstSeenAt;
  set firstSeenAt(DateTime? firstSeenAt) => _$this._firstSeenAt = firstSeenAt;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  String? _userAgent;
  String? get userAgent => _$this._userAgent;
  set userAgent(String? userAgent) => _$this._userAgent = userAgent;

  bool? _blocked;
  bool? get blocked => _$this._blocked;
  set blocked(bool? blocked) => _$this._blocked = blocked;

  ListBuilder<AdminCustomerDtoOutputDevicesInnerAccountsInner>? _accounts;
  ListBuilder<AdminCustomerDtoOutputDevicesInnerAccountsInner> get accounts =>
      _$this._accounts ??=
          ListBuilder<AdminCustomerDtoOutputDevicesInnerAccountsInner>();
  set accounts(
    ListBuilder<AdminCustomerDtoOutputDevicesInnerAccountsInner>? accounts,
  ) => _$this._accounts = accounts;

  AdminCustomerDtoOutputDevicesInnerLiftBuilder? _lift;
  AdminCustomerDtoOutputDevicesInnerLiftBuilder get lift =>
      _$this._lift ??= AdminCustomerDtoOutputDevicesInnerLiftBuilder();
  set lift(AdminCustomerDtoOutputDevicesInnerLiftBuilder? lift) =>
      _$this._lift = lift;

  AdminCustomerDtoOutputDevicesInnerBuilder() {
    AdminCustomerDtoOutputDevicesInner._defaults(this);
  }

  AdminCustomerDtoOutputDevicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _firstSeenAt = $v.firstSeenAt;
      _lastSeenAt = $v.lastSeenAt;
      _ipAddress = $v.ipAddress;
      _userAgent = $v.userAgent;
      _blocked = $v.blocked;
      _accounts = $v.accounts.toBuilder();
      _lift = $v.lift?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputDevicesInner other) {
    _$v = other as _$AdminCustomerDtoOutputDevicesInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputDevicesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputDevicesInner build() => _build();

  _$AdminCustomerDtoOutputDevicesInner _build() {
    _$AdminCustomerDtoOutputDevicesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDtoOutputDevicesInner._(
            deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId,
              r'AdminCustomerDtoOutputDevicesInner',
              'deviceId',
            ),
            firstSeenAt: BuiltValueNullFieldError.checkNotNull(
              firstSeenAt,
              r'AdminCustomerDtoOutputDevicesInner',
              'firstSeenAt',
            ),
            lastSeenAt: BuiltValueNullFieldError.checkNotNull(
              lastSeenAt,
              r'AdminCustomerDtoOutputDevicesInner',
              'lastSeenAt',
            ),
            ipAddress: ipAddress,
            userAgent: userAgent,
            blocked: BuiltValueNullFieldError.checkNotNull(
              blocked,
              r'AdminCustomerDtoOutputDevicesInner',
              'blocked',
            ),
            accounts: accounts.build(),
            lift: _lift?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'accounts';
        accounts.build();
        _$failedField = 'lift';
        _lift?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDtoOutputDevicesInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
