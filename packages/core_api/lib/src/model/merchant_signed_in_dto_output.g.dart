// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_signed_in_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantSignedInDtoOutputRoleEnum
_$merchantSignedInDtoOutputRoleEnum_owner =
    const MerchantSignedInDtoOutputRoleEnum._('owner');
const MerchantSignedInDtoOutputRoleEnum
_$merchantSignedInDtoOutputRoleEnum_cashier =
    const MerchantSignedInDtoOutputRoleEnum._('cashier');

MerchantSignedInDtoOutputRoleEnum _$merchantSignedInDtoOutputRoleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'owner':
      return _$merchantSignedInDtoOutputRoleEnum_owner;
    case 'cashier':
      return _$merchantSignedInDtoOutputRoleEnum_cashier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantSignedInDtoOutputRoleEnum>
_$merchantSignedInDtoOutputRoleEnumValues =
    BuiltSet<MerchantSignedInDtoOutputRoleEnum>(
      const <MerchantSignedInDtoOutputRoleEnum>[
        _$merchantSignedInDtoOutputRoleEnum_owner,
        _$merchantSignedInDtoOutputRoleEnum_cashier,
      ],
    );

Serializer<MerchantSignedInDtoOutputRoleEnum>
_$merchantSignedInDtoOutputRoleEnumSerializer =
    _$MerchantSignedInDtoOutputRoleEnumSerializer();

class _$MerchantSignedInDtoOutputRoleEnumSerializer
    implements PrimitiveSerializer<MerchantSignedInDtoOutputRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'owner': 'owner',
    'cashier': 'cashier',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'owner': 'owner',
    'cashier': 'cashier',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantSignedInDtoOutputRoleEnum];
  @override
  final String wireName = 'MerchantSignedInDtoOutputRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantSignedInDtoOutputRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantSignedInDtoOutputRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantSignedInDtoOutputRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantSignedInDtoOutput extends MerchantSignedInDtoOutput {
  @override
  final String accountId;
  @override
  final String restaurantId;
  @override
  final MerchantSignedInDtoOutputRoleEnum role;
  @override
  final String name;
  @override
  final bool deviceNamed;
  @override
  final String accessToken;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;

  factory _$MerchantSignedInDtoOutput([
    void Function(MerchantSignedInDtoOutputBuilder)? updates,
  ]) => (MerchantSignedInDtoOutputBuilder()..update(updates))._build();

  _$MerchantSignedInDtoOutput._({
    required this.accountId,
    required this.restaurantId,
    required this.role,
    required this.name,
    required this.deviceNamed,
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
  }) : super._();
  @override
  MerchantSignedInDtoOutput rebuild(
    void Function(MerchantSignedInDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantSignedInDtoOutputBuilder toBuilder() =>
      MerchantSignedInDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantSignedInDtoOutput &&
        accountId == other.accountId &&
        restaurantId == other.restaurantId &&
        role == other.role &&
        name == other.name &&
        deviceNamed == other.deviceNamed &&
        accessToken == other.accessToken &&
        accessTokenExpiresAt == other.accessTokenExpiresAt &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, deviceNamed.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, accessTokenExpiresAt.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantSignedInDtoOutput')
          ..add('accountId', accountId)
          ..add('restaurantId', restaurantId)
          ..add('role', role)
          ..add('name', name)
          ..add('deviceNamed', deviceNamed)
          ..add('accessToken', accessToken)
          ..add('accessTokenExpiresAt', accessTokenExpiresAt)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class MerchantSignedInDtoOutputBuilder
    implements
        Builder<MerchantSignedInDtoOutput, MerchantSignedInDtoOutputBuilder> {
  _$MerchantSignedInDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  MerchantSignedInDtoOutputRoleEnum? _role;
  MerchantSignedInDtoOutputRoleEnum? get role => _$this._role;
  set role(MerchantSignedInDtoOutputRoleEnum? role) => _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _deviceNamed;
  bool? get deviceNamed => _$this._deviceNamed;
  set deviceNamed(bool? deviceNamed) => _$this._deviceNamed = deviceNamed;

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

  MerchantSignedInDtoOutputBuilder() {
    MerchantSignedInDtoOutput._defaults(this);
  }

  MerchantSignedInDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _restaurantId = $v.restaurantId;
      _role = $v.role;
      _name = $v.name;
      _deviceNamed = $v.deviceNamed;
      _accessToken = $v.accessToken;
      _accessTokenExpiresAt = $v.accessTokenExpiresAt;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantSignedInDtoOutput other) {
    _$v = other as _$MerchantSignedInDtoOutput;
  }

  @override
  void update(void Function(MerchantSignedInDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantSignedInDtoOutput build() => _build();

  _$MerchantSignedInDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantSignedInDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'MerchantSignedInDtoOutput',
            'accountId',
          ),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'MerchantSignedInDtoOutput',
            'restaurantId',
          ),
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'MerchantSignedInDtoOutput',
            'role',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantSignedInDtoOutput',
            'name',
          ),
          deviceNamed: BuiltValueNullFieldError.checkNotNull(
            deviceNamed,
            r'MerchantSignedInDtoOutput',
            'deviceNamed',
          ),
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'MerchantSignedInDtoOutput',
            'accessToken',
          ),
          accessTokenExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessTokenExpiresAt,
            r'MerchantSignedInDtoOutput',
            'accessTokenExpiresAt',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'MerchantSignedInDtoOutput',
            'refreshToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
