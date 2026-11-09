// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateUserDtoRolesEnum _$createUserDtoRolesEnum_OWN =
    const CreateUserDtoRolesEnum._('OWN');
const CreateUserDtoRolesEnum _$createUserDtoRolesEnum_OPS =
    const CreateUserDtoRolesEnum._('OPS');
const CreateUserDtoRolesEnum _$createUserDtoRolesEnum_SUP =
    const CreateUserDtoRolesEnum._('SUP');
const CreateUserDtoRolesEnum _$createUserDtoRolesEnum_FIN =
    const CreateUserDtoRolesEnum._('FIN');
const CreateUserDtoRolesEnum _$createUserDtoRolesEnum_DATA =
    const CreateUserDtoRolesEnum._('DATA');

CreateUserDtoRolesEnum _$createUserDtoRolesEnumValueOf(String name) {
  switch (name) {
    case 'OWN':
      return _$createUserDtoRolesEnum_OWN;
    case 'OPS':
      return _$createUserDtoRolesEnum_OPS;
    case 'SUP':
      return _$createUserDtoRolesEnum_SUP;
    case 'FIN':
      return _$createUserDtoRolesEnum_FIN;
    case 'DATA':
      return _$createUserDtoRolesEnum_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateUserDtoRolesEnum> _$createUserDtoRolesEnumValues =
    BuiltSet<CreateUserDtoRolesEnum>(const <CreateUserDtoRolesEnum>[
      _$createUserDtoRolesEnum_OWN,
      _$createUserDtoRolesEnum_OPS,
      _$createUserDtoRolesEnum_SUP,
      _$createUserDtoRolesEnum_FIN,
      _$createUserDtoRolesEnum_DATA,
    ]);

Serializer<CreateUserDtoRolesEnum> _$createUserDtoRolesEnumSerializer =
    _$CreateUserDtoRolesEnumSerializer();

class _$CreateUserDtoRolesEnumSerializer
    implements PrimitiveSerializer<CreateUserDtoRolesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OWN': 'OWN',
    'OPS': 'OPS',
    'SUP': 'SUP',
    'FIN': 'FIN',
    'DATA': 'DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OWN': 'OWN',
    'OPS': 'OPS',
    'SUP': 'SUP',
    'FIN': 'FIN',
    'DATA': 'DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateUserDtoRolesEnum];
  @override
  final String wireName = 'CreateUserDtoRolesEnum';

  @override
  Object serialize(
    Serializers serializers,
    CreateUserDtoRolesEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CreateUserDtoRolesEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CreateUserDtoRolesEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CreateUserDto extends CreateUserDto {
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final BuiltList<CreateUserDtoRolesEnum> roles;

  factory _$CreateUserDto([void Function(CreateUserDtoBuilder)? updates]) =>
      (CreateUserDtoBuilder()..update(updates))._build();

  _$CreateUserDto._({
    required this.name,
    this.email,
    this.phone,
    required this.roles,
  }) : super._();
  @override
  CreateUserDto rebuild(void Function(CreateUserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateUserDtoBuilder toBuilder() => CreateUserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateUserDto &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        roles == other.roles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateUserDto')
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('roles', roles))
        .toString();
  }
}

class CreateUserDtoBuilder
    implements Builder<CreateUserDto, CreateUserDtoBuilder> {
  _$CreateUserDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  ListBuilder<CreateUserDtoRolesEnum>? _roles;
  ListBuilder<CreateUserDtoRolesEnum> get roles =>
      _$this._roles ??= ListBuilder<CreateUserDtoRolesEnum>();
  set roles(ListBuilder<CreateUserDtoRolesEnum>? roles) =>
      _$this._roles = roles;

  CreateUserDtoBuilder() {
    CreateUserDto._defaults(this);
  }

  CreateUserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _email = $v.email;
      _phone = $v.phone;
      _roles = $v.roles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateUserDto other) {
    _$v = other as _$CreateUserDto;
  }

  @override
  void update(void Function(CreateUserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateUserDto build() => _build();

  _$CreateUserDto _build() {
    _$CreateUserDto _$result;
    try {
      _$result =
          _$v ??
          _$CreateUserDto._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CreateUserDto',
              'name',
            ),
            email: email,
            phone: phone,
            roles: roles.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreateUserDto',
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
