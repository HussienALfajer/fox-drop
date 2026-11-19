// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_staff_dto_output_staff_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantStaffDtoOutputStaffInnerRoleEnum
_$merchantStaffDtoOutputStaffInnerRoleEnum_owner =
    const MerchantStaffDtoOutputStaffInnerRoleEnum._('owner');
const MerchantStaffDtoOutputStaffInnerRoleEnum
_$merchantStaffDtoOutputStaffInnerRoleEnum_cashier =
    const MerchantStaffDtoOutputStaffInnerRoleEnum._('cashier');

MerchantStaffDtoOutputStaffInnerRoleEnum
_$merchantStaffDtoOutputStaffInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'owner':
      return _$merchantStaffDtoOutputStaffInnerRoleEnum_owner;
    case 'cashier':
      return _$merchantStaffDtoOutputStaffInnerRoleEnum_cashier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantStaffDtoOutputStaffInnerRoleEnum>
_$merchantStaffDtoOutputStaffInnerRoleEnumValues =
    BuiltSet<MerchantStaffDtoOutputStaffInnerRoleEnum>(
      const <MerchantStaffDtoOutputStaffInnerRoleEnum>[
        _$merchantStaffDtoOutputStaffInnerRoleEnum_owner,
        _$merchantStaffDtoOutputStaffInnerRoleEnum_cashier,
      ],
    );

Serializer<MerchantStaffDtoOutputStaffInnerRoleEnum>
_$merchantStaffDtoOutputStaffInnerRoleEnumSerializer =
    _$MerchantStaffDtoOutputStaffInnerRoleEnumSerializer();

class _$MerchantStaffDtoOutputStaffInnerRoleEnumSerializer
    implements PrimitiveSerializer<MerchantStaffDtoOutputStaffInnerRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'owner': 'owner',
    'cashier': 'cashier',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'owner': 'owner',
    'cashier': 'cashier',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantStaffDtoOutputStaffInnerRoleEnum,
  ];
  @override
  final String wireName = 'MerchantStaffDtoOutputStaffInnerRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantStaffDtoOutputStaffInnerRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantStaffDtoOutputStaffInnerRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantStaffDtoOutputStaffInnerRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantStaffDtoOutputStaffInner
    extends MerchantStaffDtoOutputStaffInner {
  @override
  final String accountId;
  @override
  final MerchantStaffDtoOutputStaffInnerRoleEnum role;
  @override
  final String name;
  @override
  final String phone;
  @override
  final int devices;
  @override
  final DateTime? lastActiveAt;

  factory _$MerchantStaffDtoOutputStaffInner([
    void Function(MerchantStaffDtoOutputStaffInnerBuilder)? updates,
  ]) => (MerchantStaffDtoOutputStaffInnerBuilder()..update(updates))._build();

  _$MerchantStaffDtoOutputStaffInner._({
    required this.accountId,
    required this.role,
    required this.name,
    required this.phone,
    required this.devices,
    this.lastActiveAt,
  }) : super._();
  @override
  MerchantStaffDtoOutputStaffInner rebuild(
    void Function(MerchantStaffDtoOutputStaffInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStaffDtoOutputStaffInnerBuilder toBuilder() =>
      MerchantStaffDtoOutputStaffInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStaffDtoOutputStaffInner &&
        accountId == other.accountId &&
        role == other.role &&
        name == other.name &&
        phone == other.phone &&
        devices == other.devices &&
        lastActiveAt == other.lastActiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, devices.hashCode);
    _$hash = $jc(_$hash, lastActiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantStaffDtoOutputStaffInner')
          ..add('accountId', accountId)
          ..add('role', role)
          ..add('name', name)
          ..add('phone', phone)
          ..add('devices', devices)
          ..add('lastActiveAt', lastActiveAt))
        .toString();
  }
}

class MerchantStaffDtoOutputStaffInnerBuilder
    implements
        Builder<
          MerchantStaffDtoOutputStaffInner,
          MerchantStaffDtoOutputStaffInnerBuilder
        > {
  _$MerchantStaffDtoOutputStaffInner? _$v;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  MerchantStaffDtoOutputStaffInnerRoleEnum? _role;
  MerchantStaffDtoOutputStaffInnerRoleEnum? get role => _$this._role;
  set role(MerchantStaffDtoOutputStaffInnerRoleEnum? role) =>
      _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  int? _devices;
  int? get devices => _$this._devices;
  set devices(int? devices) => _$this._devices = devices;

  DateTime? _lastActiveAt;
  DateTime? get lastActiveAt => _$this._lastActiveAt;
  set lastActiveAt(DateTime? lastActiveAt) =>
      _$this._lastActiveAt = lastActiveAt;

  MerchantStaffDtoOutputStaffInnerBuilder() {
    MerchantStaffDtoOutputStaffInner._defaults(this);
  }

  MerchantStaffDtoOutputStaffInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _role = $v.role;
      _name = $v.name;
      _phone = $v.phone;
      _devices = $v.devices;
      _lastActiveAt = $v.lastActiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStaffDtoOutputStaffInner other) {
    _$v = other as _$MerchantStaffDtoOutputStaffInner;
  }

  @override
  void update(void Function(MerchantStaffDtoOutputStaffInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStaffDtoOutputStaffInner build() => _build();

  _$MerchantStaffDtoOutputStaffInner _build() {
    final _$result =
        _$v ??
        _$MerchantStaffDtoOutputStaffInner._(
          accountId: BuiltValueNullFieldError.checkNotNull(
            accountId,
            r'MerchantStaffDtoOutputStaffInner',
            'accountId',
          ),
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'MerchantStaffDtoOutputStaffInner',
            'role',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantStaffDtoOutputStaffInner',
            'name',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'MerchantStaffDtoOutputStaffInner',
            'phone',
          ),
          devices: BuiltValueNullFieldError.checkNotNull(
            devices,
            r'MerchantStaffDtoOutputStaffInner',
            'devices',
          ),
          lastActiveAt: lastActiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
