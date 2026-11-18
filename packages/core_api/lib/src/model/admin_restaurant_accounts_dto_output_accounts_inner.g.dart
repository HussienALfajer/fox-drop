// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_accounts_dto_output_accounts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum
_$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_owner =
    const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum._('owner');
const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum
_$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_cashier =
    const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum._('cashier');

AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum
_$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'owner':
      return _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_owner;
    case 'cashier':
      return _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_cashier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum>
_$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnumValues =
    BuiltSet<AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum>(
      const <AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum>[
        _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_owner,
        _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_cashier,
      ],
    );

Serializer<AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum>
_$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnumSerializer =
    _$AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnumSerializer();

class _$AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum
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
    AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantAccountsDtoOutputAccountsInner
    extends AdminRestaurantAccountsDtoOutputAccountsInner {
  @override
  final String id;
  @override
  final AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum role;
  @override
  final String name;
  @override
  final String phone;

  factory _$AdminRestaurantAccountsDtoOutputAccountsInner([
    void Function(AdminRestaurantAccountsDtoOutputAccountsInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantAccountsDtoOutputAccountsInnerBuilder()..update(updates))
          ._build();

  _$AdminRestaurantAccountsDtoOutputAccountsInner._({
    required this.id,
    required this.role,
    required this.name,
    required this.phone,
  }) : super._();
  @override
  AdminRestaurantAccountsDtoOutputAccountsInner rebuild(
    void Function(AdminRestaurantAccountsDtoOutputAccountsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantAccountsDtoOutputAccountsInnerBuilder toBuilder() =>
      AdminRestaurantAccountsDtoOutputAccountsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantAccountsDtoOutputAccountsInner &&
        id == other.id &&
        role == other.role &&
        name == other.name &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantAccountsDtoOutputAccountsInner',
          )
          ..add('id', id)
          ..add('role', role)
          ..add('name', name)
          ..add('phone', phone))
        .toString();
  }
}

class AdminRestaurantAccountsDtoOutputAccountsInnerBuilder
    implements
        Builder<
          AdminRestaurantAccountsDtoOutputAccountsInner,
          AdminRestaurantAccountsDtoOutputAccountsInnerBuilder
        > {
  _$AdminRestaurantAccountsDtoOutputAccountsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum? _role;
  AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum? get role =>
      _$this._role;
  set role(AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum? role) =>
      _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  AdminRestaurantAccountsDtoOutputAccountsInnerBuilder() {
    AdminRestaurantAccountsDtoOutputAccountsInner._defaults(this);
  }

  AdminRestaurantAccountsDtoOutputAccountsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _role = $v.role;
      _name = $v.name;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantAccountsDtoOutputAccountsInner other) {
    _$v = other as _$AdminRestaurantAccountsDtoOutputAccountsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantAccountsDtoOutputAccountsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantAccountsDtoOutputAccountsInner build() => _build();

  _$AdminRestaurantAccountsDtoOutputAccountsInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantAccountsDtoOutputAccountsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantAccountsDtoOutputAccountsInner',
            'id',
          ),
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'AdminRestaurantAccountsDtoOutputAccountsInner',
            'role',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminRestaurantAccountsDtoOutputAccountsInner',
            'name',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'AdminRestaurantAccountsDtoOutputAccountsInner',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
