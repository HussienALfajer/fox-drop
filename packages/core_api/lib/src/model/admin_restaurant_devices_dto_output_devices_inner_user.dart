//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_devices_dto_output_devices_inner_user.g.dart';

/// Signed in on it now, else the latest who was; null before any sign-in.
///
/// Properties:
/// * [name]
/// * [role]
@BuiltValue()
abstract class AdminRestaurantDevicesDtoOutputDevicesInnerUser
    implements
        Built<
          AdminRestaurantDevicesDtoOutputDevicesInnerUser,
          AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'role')
  AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum get role;
  // enum roleEnum {  owner,  cashier,  };

  AdminRestaurantDevicesDtoOutputDevicesInnerUser._();

  factory AdminRestaurantDevicesDtoOutputDevicesInnerUser([
    void updates(AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder b),
  ]) = _$AdminRestaurantDevicesDtoOutputDevicesInnerUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDevicesDtoOutputDevicesInnerUser>
  get serializer =>
      _$AdminRestaurantDevicesDtoOutputDevicesInnerUserSerializer();
}

class _$AdminRestaurantDevicesDtoOutputDevicesInnerUserSerializer
    implements
        PrimitiveSerializer<AdminRestaurantDevicesDtoOutputDevicesInnerUser> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDevicesDtoOutputDevicesInnerUser,
    _$AdminRestaurantDevicesDtoOutputDevicesInnerUser,
  ];

  @override
  final String wireName = r'AdminRestaurantDevicesDtoOutputDevicesInnerUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutputDevicesInnerUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(
        AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutputDevicesInnerUser object, {
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
    required AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum,
                    ),
                  )
                  as AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDevicesDtoOutputDevicesInnerUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDevicesDtoOutputDevicesInnerUserBuilder();
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

class AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'owner')
  static const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum owner =
      _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_owner;
  @BuiltValueEnumConst(wireName: r'cashier')
  static const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum cashier =
      _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum_cashier;

  static Serializer<AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum>
  get serializer =>
      _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumSerializer;

  const AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum>
  get values => _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumValues;
  static AdminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnum valueOf(
    String name,
  ) => _$adminRestaurantDevicesDtoOutputDevicesInnerUserRoleEnumValueOf(name);
}
