// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_roles_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChangeRolesDtoRolesEnum _$changeRolesDtoRolesEnum_OWN =
    const ChangeRolesDtoRolesEnum._('OWN');
const ChangeRolesDtoRolesEnum _$changeRolesDtoRolesEnum_OPS =
    const ChangeRolesDtoRolesEnum._('OPS');
const ChangeRolesDtoRolesEnum _$changeRolesDtoRolesEnum_SUP =
    const ChangeRolesDtoRolesEnum._('SUP');
const ChangeRolesDtoRolesEnum _$changeRolesDtoRolesEnum_FIN =
    const ChangeRolesDtoRolesEnum._('FIN');
const ChangeRolesDtoRolesEnum _$changeRolesDtoRolesEnum_DATA =
    const ChangeRolesDtoRolesEnum._('DATA');

ChangeRolesDtoRolesEnum _$changeRolesDtoRolesEnumValueOf(String name) {
  switch (name) {
    case 'OWN':
      return _$changeRolesDtoRolesEnum_OWN;
    case 'OPS':
      return _$changeRolesDtoRolesEnum_OPS;
    case 'SUP':
      return _$changeRolesDtoRolesEnum_SUP;
    case 'FIN':
      return _$changeRolesDtoRolesEnum_FIN;
    case 'DATA':
      return _$changeRolesDtoRolesEnum_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChangeRolesDtoRolesEnum> _$changeRolesDtoRolesEnumValues =
    BuiltSet<ChangeRolesDtoRolesEnum>(const <ChangeRolesDtoRolesEnum>[
      _$changeRolesDtoRolesEnum_OWN,
      _$changeRolesDtoRolesEnum_OPS,
      _$changeRolesDtoRolesEnum_SUP,
      _$changeRolesDtoRolesEnum_FIN,
      _$changeRolesDtoRolesEnum_DATA,
    ]);

Serializer<ChangeRolesDtoRolesEnum> _$changeRolesDtoRolesEnumSerializer =
    _$ChangeRolesDtoRolesEnumSerializer();

class _$ChangeRolesDtoRolesEnumSerializer
    implements PrimitiveSerializer<ChangeRolesDtoRolesEnum> {
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
  final Iterable<Type> types = const <Type>[ChangeRolesDtoRolesEnum];
  @override
  final String wireName = 'ChangeRolesDtoRolesEnum';

  @override
  Object serialize(
    Serializers serializers,
    ChangeRolesDtoRolesEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ChangeRolesDtoRolesEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ChangeRolesDtoRolesEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ChangeRolesDto extends ChangeRolesDto {
  @override
  final BuiltList<ChangeRolesDtoRolesEnum> roles;

  factory _$ChangeRolesDto([void Function(ChangeRolesDtoBuilder)? updates]) =>
      (ChangeRolesDtoBuilder()..update(updates))._build();

  _$ChangeRolesDto._({required this.roles}) : super._();
  @override
  ChangeRolesDto rebuild(void Function(ChangeRolesDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChangeRolesDtoBuilder toBuilder() => ChangeRolesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChangeRolesDto && roles == other.roles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ChangeRolesDto',
    )..add('roles', roles)).toString();
  }
}

class ChangeRolesDtoBuilder
    implements Builder<ChangeRolesDto, ChangeRolesDtoBuilder> {
  _$ChangeRolesDto? _$v;

  ListBuilder<ChangeRolesDtoRolesEnum>? _roles;
  ListBuilder<ChangeRolesDtoRolesEnum> get roles =>
      _$this._roles ??= ListBuilder<ChangeRolesDtoRolesEnum>();
  set roles(ListBuilder<ChangeRolesDtoRolesEnum>? roles) =>
      _$this._roles = roles;

  ChangeRolesDtoBuilder() {
    ChangeRolesDto._defaults(this);
  }

  ChangeRolesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _roles = $v.roles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChangeRolesDto other) {
    _$v = other as _$ChangeRolesDto;
  }

  @override
  void update(void Function(ChangeRolesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChangeRolesDto build() => _build();

  _$ChangeRolesDto _build() {
    _$ChangeRolesDto _$result;
    try {
      _$result = _$v ?? _$ChangeRolesDto._(roles: roles.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ChangeRolesDto',
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
