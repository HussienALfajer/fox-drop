//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'change_roles_dto.g.dart';

/// ChangeRolesDto
///
/// Properties:
/// * [roles] - One or more roles (AP §6.1).
@BuiltValue()
abstract class ChangeRolesDto implements Built<ChangeRolesDto, ChangeRolesDtoBuilder> {
  /// One or more roles (AP §6.1).
  @BuiltValueField(wireName: r'roles')
  BuiltList<ChangeRolesDtoRolesEnum> get roles;
  // enum rolesEnum {  OWN,  OPS,  SUP,  FIN,  DATA,  };

  ChangeRolesDto._();

  factory ChangeRolesDto([void updates(ChangeRolesDtoBuilder b)]) = _$ChangeRolesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChangeRolesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChangeRolesDto> get serializer => _$ChangeRolesDtoSerializer();
}

class _$ChangeRolesDtoSerializer implements PrimitiveSerializer<ChangeRolesDto> {
  @override
  final Iterable<Type> types = const [ChangeRolesDto, _$ChangeRolesDto];

  @override
  final String wireName = r'ChangeRolesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChangeRolesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(ChangeRolesDtoRolesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChangeRolesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChangeRolesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChangeRolesDtoRolesEnum)]),
          ) as BuiltList<ChangeRolesDtoRolesEnum>;
          result.roles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChangeRolesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChangeRolesDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class ChangeRolesDtoRolesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWN')
  static const ChangeRolesDtoRolesEnum OWN = _$changeRolesDtoRolesEnum_OWN;
  @BuiltValueEnumConst(wireName: r'OPS')
  static const ChangeRolesDtoRolesEnum OPS = _$changeRolesDtoRolesEnum_OPS;
  @BuiltValueEnumConst(wireName: r'SUP')
  static const ChangeRolesDtoRolesEnum SUP = _$changeRolesDtoRolesEnum_SUP;
  @BuiltValueEnumConst(wireName: r'FIN')
  static const ChangeRolesDtoRolesEnum FIN = _$changeRolesDtoRolesEnum_FIN;
  @BuiltValueEnumConst(wireName: r'DATA')
  static const ChangeRolesDtoRolesEnum DATA = _$changeRolesDtoRolesEnum_DATA;

  static Serializer<ChangeRolesDtoRolesEnum> get serializer => _$changeRolesDtoRolesEnumSerializer;

  const ChangeRolesDtoRolesEnum._(String name): super(name);

  static BuiltSet<ChangeRolesDtoRolesEnum> get values => _$changeRolesDtoRolesEnumValues;
  static ChangeRolesDtoRolesEnum valueOf(String name) => _$changeRolesDtoRolesEnumValueOf(name);
}

