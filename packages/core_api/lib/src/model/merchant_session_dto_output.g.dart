// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantSessionDtoOutputRoleEnum
_$merchantSessionDtoOutputRoleEnum_owner =
    const MerchantSessionDtoOutputRoleEnum._('owner');
const MerchantSessionDtoOutputRoleEnum
_$merchantSessionDtoOutputRoleEnum_cashier =
    const MerchantSessionDtoOutputRoleEnum._('cashier');

MerchantSessionDtoOutputRoleEnum _$merchantSessionDtoOutputRoleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'owner':
      return _$merchantSessionDtoOutputRoleEnum_owner;
    case 'cashier':
      return _$merchantSessionDtoOutputRoleEnum_cashier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantSessionDtoOutputRoleEnum>
_$merchantSessionDtoOutputRoleEnumValues =
    BuiltSet<MerchantSessionDtoOutputRoleEnum>(
      const <MerchantSessionDtoOutputRoleEnum>[
        _$merchantSessionDtoOutputRoleEnum_owner,
        _$merchantSessionDtoOutputRoleEnum_cashier,
      ],
    );

Serializer<MerchantSessionDtoOutputRoleEnum>
_$merchantSessionDtoOutputRoleEnumSerializer =
    _$MerchantSessionDtoOutputRoleEnumSerializer();

class _$MerchantSessionDtoOutputRoleEnumSerializer
    implements PrimitiveSerializer<MerchantSessionDtoOutputRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'owner': 'owner',
    'cashier': 'cashier',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'owner': 'owner',
    'cashier': 'cashier',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantSessionDtoOutputRoleEnum];
  @override
  final String wireName = 'MerchantSessionDtoOutputRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantSessionDtoOutputRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantSessionDtoOutputRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantSessionDtoOutputRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantSessionDtoOutput extends MerchantSessionDtoOutput {
  @override
  final String accountId;
  @override
  final String restaurantId;
  @override
  final MerchantSessionDtoOutputRoleEnum role;
  @override
  final String name;
  @override
  final bool deviceNamed;
  @override
  final String sessionId;

  factory _$MerchantSessionDtoOutput([
    void Function(MerchantSessionDtoOutputBuilder)? updates,
  ]) => (MerchantSessionDtoOutputBuilder()..update(updates))._build();

  _$MerchantSessionDtoOutput._({
    required this.accountId,
    required this.restaurantId,
    required this.role,
    required this.name,
    required this.deviceNamed,
    required this.sessionId,
  }) : super._();
  @override
  MerchantSessionDtoOutput rebuild(
    void Function(MerchantSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantSessionDtoOutputBuilder toBuilder() =>
      MerchantSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantSessionDtoOutput &&
        accountId == other.accountId &&
        restaurantId == other.restaurantId &&
        role == other.role &&
        name == other.name &&
        deviceNamed == other.deviceNamed &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, deviceNamed.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantSessionDtoOutput')
          ..add('accountId', accountId)
          ..add('restaurantId', restaurantId)
          ..add('role', role)
          ..add('name', name)
          ..add('deviceNamed', deviceNamed)
          ..add('sessionId', sessionId))
        .toString();
  }
}

class MerchantSessionDtoOutputBuilder
    implements
        Builder<MerchantSessionDtoOutput, MerchantSessionDtoOutputBuilder> {
  _$MerchantSessionDtoOutput? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  MerchantSessionDtoOutputRoleEnum? _role;
  MerchantSessionDtoOutputRoleEnum? get role => _$this._role;
  set role(MerchantSessionDtoOutputRoleEnum? role) => _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _deviceNamed;
  bool? get deviceNamed => _$this._deviceNamed;
  set deviceNamed(bool? deviceNamed) => _$this._deviceNamed = deviceNamed;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  MerchantSessionDtoOutputBuilder() {
    MerchantSessionDtoOutput._defaults(this);
  }

  MerchantSessionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _restaurantId = $v.restaurantId;
      _role = $v.role;
      _name = $v.name;
      _deviceNamed = $v.deviceNamed;
      _sessionId = $v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantSessionDtoOutput other) {
    _$v = other as _$MerchantSessionDtoOutput;
  }

  @override
  void update(void Function(MerchantSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantSessionDtoOutput build() => _build();

  _$MerchantSessionDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantSessionDtoOutput._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'MerchantSessionDtoOutput',
            'accountId',
          ),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'MerchantSessionDtoOutput',
            'restaurantId',
          ),
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'MerchantSessionDtoOutput',
            'role',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantSessionDtoOutput',
            'name',
          ),
          deviceNamed: BuiltValueNullFieldError.checkNotNull(
            deviceNamed,
            r'MerchantSessionDtoOutput',
            'deviceNamed',
          ),
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'MerchantSessionDtoOutput',
            'sessionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
