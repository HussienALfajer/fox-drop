//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_terminated_dto_output.g.dart';

/// AdminRestaurantTerminatedDtoOutput
///
/// Properties:
/// * [restaurantId]
/// * [accountStatus]
@BuiltValue()
abstract class AdminRestaurantTerminatedDtoOutput
    implements
        Built<
          AdminRestaurantTerminatedDtoOutput,
          AdminRestaurantTerminatedDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'accountStatus')
  AdminRestaurantTerminatedDtoOutputAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  terminated,  };

  AdminRestaurantTerminatedDtoOutput._();

  factory AdminRestaurantTerminatedDtoOutput([
    void updates(AdminRestaurantTerminatedDtoOutputBuilder b),
  ]) = _$AdminRestaurantTerminatedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantTerminatedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantTerminatedDtoOutput> get serializer =>
      _$AdminRestaurantTerminatedDtoOutputSerializer();
}

class _$AdminRestaurantTerminatedDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantTerminatedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantTerminatedDtoOutput,
    _$AdminRestaurantTerminatedDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantTerminatedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantTerminatedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(
        AdminRestaurantTerminatedDtoOutputAccountStatusEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantTerminatedDtoOutput object, {
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
    required AdminRestaurantTerminatedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantTerminatedDtoOutputAccountStatusEnum,
                    ),
                  )
                  as AdminRestaurantTerminatedDtoOutputAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantTerminatedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantTerminatedDtoOutputBuilder();
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

class AdminRestaurantTerminatedDtoOutputAccountStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminRestaurantTerminatedDtoOutputAccountStatusEnum terminated =
      _$adminRestaurantTerminatedDtoOutputAccountStatusEnum_terminated;

  static Serializer<AdminRestaurantTerminatedDtoOutputAccountStatusEnum>
  get serializer =>
      _$adminRestaurantTerminatedDtoOutputAccountStatusEnumSerializer;

  const AdminRestaurantTerminatedDtoOutputAccountStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantTerminatedDtoOutputAccountStatusEnum>
  get values => _$adminRestaurantTerminatedDtoOutputAccountStatusEnumValues;
  static AdminRestaurantTerminatedDtoOutputAccountStatusEnum valueOf(
    String name,
  ) => _$adminRestaurantTerminatedDtoOutputAccountStatusEnumValueOf(name);
}
