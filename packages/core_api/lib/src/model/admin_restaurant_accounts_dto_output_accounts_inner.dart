//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_accounts_dto_output_accounts_inner.g.dart';

/// AdminRestaurantAccountsDtoOutputAccountsInner
///
/// Properties:
/// * [id]
/// * [role]
/// * [name]
/// * [phone] - The number the user signs in with (OTP): E.164 for restaurants.owner_accounts (each such read is audited), else masked as «+963 ••• 456».
@BuiltValue()
abstract class AdminRestaurantAccountsDtoOutputAccountsInner
    implements
        Built<
          AdminRestaurantAccountsDtoOutputAccountsInner,
          AdminRestaurantAccountsDtoOutputAccountsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'role')
  AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum get role;
  // enum roleEnum {  owner,  cashier,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The number the user signs in with (OTP): E.164 for restaurants.owner_accounts (each such read is audited), else masked as «+963 ••• 456».
  @BuiltValueField(wireName: r'phone')
  String get phone;

  AdminRestaurantAccountsDtoOutputAccountsInner._();

  factory AdminRestaurantAccountsDtoOutputAccountsInner([
    void updates(AdminRestaurantAccountsDtoOutputAccountsInnerBuilder b),
  ]) = _$AdminRestaurantAccountsDtoOutputAccountsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantAccountsDtoOutputAccountsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantAccountsDtoOutputAccountsInner>
  get serializer => _$AdminRestaurantAccountsDtoOutputAccountsInnerSerializer();
}

class _$AdminRestaurantAccountsDtoOutputAccountsInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantAccountsDtoOutputAccountsInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantAccountsDtoOutputAccountsInner,
    _$AdminRestaurantAccountsDtoOutputAccountsInner,
  ];

  @override
  final String wireName = r'AdminRestaurantAccountsDtoOutputAccountsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantAccountsDtoOutputAccountsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(
        AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum,
      ),
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
    AdminRestaurantAccountsDtoOutputAccountsInner object, {
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
    required AdminRestaurantAccountsDtoOutputAccountsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum,
                    ),
                  )
                  as AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum;
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
  AdminRestaurantAccountsDtoOutputAccountsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantAccountsDtoOutputAccountsInnerBuilder();
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

class AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'owner')
  static const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum owner =
      _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_owner;
  @BuiltValueEnumConst(wireName: r'cashier')
  static const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum cashier =
      _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnum_cashier;

  static Serializer<AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum>
  get serializer =>
      _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnumSerializer;

  const AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum>
  get values => _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnumValues;
  static AdminRestaurantAccountsDtoOutputAccountsInnerRoleEnum valueOf(
    String name,
  ) => _$adminRestaurantAccountsDtoOutputAccountsInnerRoleEnumValueOf(name);
}
