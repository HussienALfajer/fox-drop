//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_new_restaurant_account_dto.g.dart';

/// AdminNewRestaurantAccountDto
///
/// Properties:
/// * [role]
/// * [name]
/// * [phone] - A mobile of any country in E.164, as at sign-in.
@BuiltValue()
abstract class AdminNewRestaurantAccountDto
    implements
        Built<
          AdminNewRestaurantAccountDto,
          AdminNewRestaurantAccountDtoBuilder
        > {
  @BuiltValueField(wireName: r'role')
  AdminNewRestaurantAccountDtoRoleEnum get role;
  // enum roleEnum {  owner,  cashier,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  /// A mobile of any country in E.164, as at sign-in.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  AdminNewRestaurantAccountDto._();

  factory AdminNewRestaurantAccountDto([
    void updates(AdminNewRestaurantAccountDtoBuilder b),
  ]) = _$AdminNewRestaurantAccountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNewRestaurantAccountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNewRestaurantAccountDto> get serializer =>
      _$AdminNewRestaurantAccountDtoSerializer();
}

class _$AdminNewRestaurantAccountDtoSerializer
    implements PrimitiveSerializer<AdminNewRestaurantAccountDto> {
  @override
  final Iterable<Type> types = const [
    AdminNewRestaurantAccountDto,
    _$AdminNewRestaurantAccountDto,
  ];

  @override
  final String wireName = r'AdminNewRestaurantAccountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNewRestaurantAccountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminNewRestaurantAccountDtoRoleEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNewRestaurantAccountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminNewRestaurantAccountDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminNewRestaurantAccountDtoRoleEnum,
                    ),
                  )
                  as AdminNewRestaurantAccountDtoRoleEnum;
          result.role = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNewRestaurantAccountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNewRestaurantAccountDtoBuilder();
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

class AdminNewRestaurantAccountDtoRoleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'owner')
  static const AdminNewRestaurantAccountDtoRoleEnum owner =
      _$adminNewRestaurantAccountDtoRoleEnum_owner;
  @BuiltValueEnumConst(wireName: r'cashier')
  static const AdminNewRestaurantAccountDtoRoleEnum cashier =
      _$adminNewRestaurantAccountDtoRoleEnum_cashier;

  static Serializer<AdminNewRestaurantAccountDtoRoleEnum> get serializer =>
      _$adminNewRestaurantAccountDtoRoleEnumSerializer;

  const AdminNewRestaurantAccountDtoRoleEnum._(String name) : super(name);

  static BuiltSet<AdminNewRestaurantAccountDtoRoleEnum> get values =>
      _$adminNewRestaurantAccountDtoRoleEnumValues;
  static AdminNewRestaurantAccountDtoRoleEnum valueOf(String name) =>
      _$adminNewRestaurantAccountDtoRoleEnumValueOf(name);
}
