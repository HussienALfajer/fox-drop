// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_new_restaurant_account_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminNewRestaurantAccountDtoRoleEnum
_$adminNewRestaurantAccountDtoRoleEnum_owner =
    const AdminNewRestaurantAccountDtoRoleEnum._('owner');
const AdminNewRestaurantAccountDtoRoleEnum
_$adminNewRestaurantAccountDtoRoleEnum_cashier =
    const AdminNewRestaurantAccountDtoRoleEnum._('cashier');

AdminNewRestaurantAccountDtoRoleEnum
_$adminNewRestaurantAccountDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'owner':
      return _$adminNewRestaurantAccountDtoRoleEnum_owner;
    case 'cashier':
      return _$adminNewRestaurantAccountDtoRoleEnum_cashier;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNewRestaurantAccountDtoRoleEnum>
_$adminNewRestaurantAccountDtoRoleEnumValues =
    BuiltSet<AdminNewRestaurantAccountDtoRoleEnum>(
      const <AdminNewRestaurantAccountDtoRoleEnum>[
        _$adminNewRestaurantAccountDtoRoleEnum_owner,
        _$adminNewRestaurantAccountDtoRoleEnum_cashier,
      ],
    );

Serializer<AdminNewRestaurantAccountDtoRoleEnum>
_$adminNewRestaurantAccountDtoRoleEnumSerializer =
    _$AdminNewRestaurantAccountDtoRoleEnumSerializer();

class _$AdminNewRestaurantAccountDtoRoleEnumSerializer
    implements PrimitiveSerializer<AdminNewRestaurantAccountDtoRoleEnum> {
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
    AdminNewRestaurantAccountDtoRoleEnum,
  ];
  @override
  final String wireName = 'AdminNewRestaurantAccountDtoRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNewRestaurantAccountDtoRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNewRestaurantAccountDtoRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNewRestaurantAccountDtoRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNewRestaurantAccountDto extends AdminNewRestaurantAccountDto {
  @override
  final AdminNewRestaurantAccountDtoRoleEnum role;
  @override
  final String name;
  @override
  final String phone;

  factory _$AdminNewRestaurantAccountDto([
    void Function(AdminNewRestaurantAccountDtoBuilder)? updates,
  ]) => (AdminNewRestaurantAccountDtoBuilder()..update(updates))._build();

  _$AdminNewRestaurantAccountDto._({
    required this.role,
    required this.name,
    required this.phone,
  }) : super._();
  @override
  AdminNewRestaurantAccountDto rebuild(
    void Function(AdminNewRestaurantAccountDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNewRestaurantAccountDtoBuilder toBuilder() =>
      AdminNewRestaurantAccountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNewRestaurantAccountDto &&
        role == other.role &&
        name == other.name &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminNewRestaurantAccountDto')
          ..add('role', role)
          ..add('name', name)
          ..add('phone', phone))
        .toString();
  }
}

class AdminNewRestaurantAccountDtoBuilder
    implements
        Builder<
          AdminNewRestaurantAccountDto,
          AdminNewRestaurantAccountDtoBuilder
        > {
  _$AdminNewRestaurantAccountDto? _$v;

  AdminNewRestaurantAccountDtoRoleEnum? _role;
  AdminNewRestaurantAccountDtoRoleEnum? get role => _$this._role;
  set role(AdminNewRestaurantAccountDtoRoleEnum? role) => _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  AdminNewRestaurantAccountDtoBuilder() {
    AdminNewRestaurantAccountDto._defaults(this);
  }

  AdminNewRestaurantAccountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _name = $v.name;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNewRestaurantAccountDto other) {
    _$v = other as _$AdminNewRestaurantAccountDto;
  }

  @override
  void update(void Function(AdminNewRestaurantAccountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNewRestaurantAccountDto build() => _build();

  _$AdminNewRestaurantAccountDto _build() {
    final _$result =
        _$v ??
        _$AdminNewRestaurantAccountDto._(
          role: BuiltValueNullFieldError.checkNotNull(
            role,
            r'AdminNewRestaurantAccountDto',
            'role',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminNewRestaurantAccountDto',
            'name',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'AdminNewRestaurantAccountDto',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
