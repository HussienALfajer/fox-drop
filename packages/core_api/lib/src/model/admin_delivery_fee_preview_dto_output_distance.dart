//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fee_preview_dto_output_distance.g.dart';

/// The motorbike's distance from the restaurant, as a band fee measures it.
///
/// Properties:
/// * [metres]
/// * [method]
@BuiltValue()
abstract class AdminDeliveryFeePreviewDtoOutputDistance
    implements
        Built<
          AdminDeliveryFeePreviewDtoOutputDistance,
          AdminDeliveryFeePreviewDtoOutputDistanceBuilder
        > {
  @BuiltValueField(wireName: r'metres')
  int get metres;

  @BuiltValueField(wireName: r'method')
  AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum get method;
  // enum methodEnum {  road,  straight_x1.3,  };

  AdminDeliveryFeePreviewDtoOutputDistance._();

  factory AdminDeliveryFeePreviewDtoOutputDistance([
    void updates(AdminDeliveryFeePreviewDtoOutputDistanceBuilder b),
  ]) = _$AdminDeliveryFeePreviewDtoOutputDistance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeliveryFeePreviewDtoOutputDistanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeePreviewDtoOutputDistance> get serializer =>
      _$AdminDeliveryFeePreviewDtoOutputDistanceSerializer();
}

class _$AdminDeliveryFeePreviewDtoOutputDistanceSerializer
    implements PrimitiveSerializer<AdminDeliveryFeePreviewDtoOutputDistance> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeePreviewDtoOutputDistance,
    _$AdminDeliveryFeePreviewDtoOutputDistance,
  ];

  @override
  final String wireName = r'AdminDeliveryFeePreviewDtoOutputDistance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeePreviewDtoOutputDistance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'metres';
    yield serializers.serialize(
      object.metres,
      specifiedType: const FullType(int),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(
        AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeePreviewDtoOutputDistance object, {
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
    required AdminDeliveryFeePreviewDtoOutputDistanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.metres = valueDes;
          break;
        case r'method':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum,
                    ),
                  )
                  as AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum;
          result.method = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeliveryFeePreviewDtoOutputDistance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeePreviewDtoOutputDistanceBuilder();
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

class AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'road')
  static const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum road =
      _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_road;
  @BuiltValueEnumConst(wireName: r'straight_x1.3')
  static const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum
  straightX1Period3 =
      _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnum_straightX1Period3;

  static Serializer<AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum>
  get serializer =>
      _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnumSerializer;

  const AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum._(String name)
    : super(name);

  static BuiltSet<AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum>
  get values => _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnumValues;
  static AdminDeliveryFeePreviewDtoOutputDistanceMethodEnum valueOf(
    String name,
  ) => _$adminDeliveryFeePreviewDtoOutputDistanceMethodEnumValueOf(name);
}
