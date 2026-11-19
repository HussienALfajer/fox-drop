// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_devices_dto_output_devices_inner_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_owner =
    const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum._('owner');
const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_cashier =
    const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum._('cashier');

AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum
_$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumValueOf(String name) {
  switch (name) {
    case 'owner':
      return _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_owner;
    case 'cashier':
      return _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_cashier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum>
_$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumValues =
    BuiltSet<AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum>(
      const <AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum>[
        _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_owner,
        _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_cashier,
      ],
    );

Serializer<AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum>
_$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumSerializer =
    _$AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumSerializer();

class _$AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum
        > {
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
    AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantDevicesDtoOutputDevicesInnerUser
    extends AdminRestaurantDevicesDtoOutputDevicesInnerUser {
  @override
  final String name;
  @override
  final AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum role;

  factory _$AdminRestaurantDevicesDtoOutputDevicesInnerUser([
    void Function(AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDevicesDtoOutputDevicesInnerUser._({
    required this.name,
    required this.role,
  }) : super._();
  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerUser rebuild(
    void Function(AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder toBuilder() =>
      AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDevicesDtoOutputDevicesInnerUser &&
        name == other.name &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDevicesDtoOutputDevicesInnerUser',
          )
          ..add('name', name)
          ..add('role', role))
        .toString();
  }
}

class AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder
    implements
        Builder<
          AdminRestaurantDevicesDtoOutputDevicesInnerUser,
          AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder
        > {
  _$AdminRestaurantDevicesDtoOutputDevicesInnerUser? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum? _role;
  AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum? get role =>
      _$this._role;
  set role(AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum? role) =>
      _$this._role = role;

  AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder() {
    AdminRestaurantDevicesDtoOutputDevicesInnerUser._defaults(this);
  }

  AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDevicesDtoOutputDevicesInnerUser other) {
    _$v = other as _$AdminRestaurantDevicesDtoOutputDevicesInnerUser;
  }

  @override
  void update(
    void Function(AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerUser build() => _build();

  _$AdminRestaurantDevicesDtoOutputDevicesInnerUser _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDevicesDtoOutputDevicesInnerUser._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminRestaurantDevicesDtoOutputDevicesInnerUser',
            'name',
          ),
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'AdminRestaurantDevicesDtoOutputDevicesInnerUser',
            'role',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
