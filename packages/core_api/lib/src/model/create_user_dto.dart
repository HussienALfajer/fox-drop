//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_user_dto.g.dart';

/// CreateUserDto
///
/// Properties:
/// * [name] 
/// * [email] 
/// * [phone] - In international form, such as +963944000000.
/// * [roles] - One or more roles (AP §6.1).
@BuiltValue()
abstract class CreateUserDto implements Built<CreateUserDto, CreateUserDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String? get email;

  /// In international form, such as +963944000000.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  /// One or more roles (AP §6.1).
  @BuiltValueField(wireName: r'roles')
  BuiltList<CreateUserDtoRolesEnum> get roles;
  // enum rolesEnum {  OWN,  OPS,  SUP,  FIN,  DATA,  };

  CreateUserDto._();

  factory CreateUserDto([void updates(CreateUserDtoBuilder b)]) = _$CreateUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateUserDto> get serializer => _$CreateUserDtoSerializer();
}

class _$CreateUserDtoSerializer implements PrimitiveSerializer<CreateUserDto> {
  @override
  final Iterable<Type> types = const [CreateUserDto, _$CreateUserDto];

  @override
  final String wireName = r'CreateUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(CreateUserDtoRolesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateUserDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreateUserDtoRolesEnum)]),
          ) as BuiltList<CreateUserDtoRolesEnum>;
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
  CreateUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateUserDtoBuilder();
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


class CreateUserDtoRolesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWN')
  static const CreateUserDtoRolesEnum OWN = _$createUserDtoRolesEnum_OWN;
  @BuiltValueEnumConst(wireName: r'OPS')
  static const CreateUserDtoRolesEnum OPS = _$createUserDtoRolesEnum_OPS;
  @BuiltValueEnumConst(wireName: r'SUP')
  static const CreateUserDtoRolesEnum SUP = _$createUserDtoRolesEnum_SUP;
  @BuiltValueEnumConst(wireName: r'FIN')
  static const CreateUserDtoRolesEnum FIN = _$createUserDtoRolesEnum_FIN;
  @BuiltValueEnumConst(wireName: r'DATA')
  static const CreateUserDtoRolesEnum DATA = _$createUserDtoRolesEnum_DATA;

  static Serializer<CreateUserDtoRolesEnum> get serializer => _$createUserDtoRolesEnumSerializer;

  const CreateUserDtoRolesEnum._(String name): super(name);

  static BuiltSet<CreateUserDtoRolesEnum> get values => _$createUserDtoRolesEnumValues;
  static CreateUserDtoRolesEnum valueOf(String name) => _$createUserDtoRolesEnumValueOf(name);
}

