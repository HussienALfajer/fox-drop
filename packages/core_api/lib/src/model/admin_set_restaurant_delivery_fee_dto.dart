//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_set_restaurant_delivery_fee_dto_rule.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_restaurant_delivery_fee_dto.g.dart';

/// AdminSetRestaurantDeliveryFeeDto
///
/// Properties:
/// * [cityId]
/// * [rule]
/// * [reason]
@BuiltValue()
abstract class AdminSetRestaurantDeliveryFeeDto
    implements
        Built<
          AdminSetRestaurantDeliveryFeeDto,
          AdminSetRestaurantDeliveryFeeDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'rule')
  AdminSetRestaurantDeliveryFeeDtoRule? get rule;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminSetRestaurantDeliveryFeeDto._();

  factory AdminSetRestaurantDeliveryFeeDto([
    void updates(AdminSetRestaurantDeliveryFeeDtoBuilder b),
  ]) = _$AdminSetRestaurantDeliveryFeeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetRestaurantDeliveryFeeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetRestaurantDeliveryFeeDto> get serializer =>
      _$AdminSetRestaurantDeliveryFeeDtoSerializer();
}

class _$AdminSetRestaurantDeliveryFeeDtoSerializer
    implements PrimitiveSerializer<AdminSetRestaurantDeliveryFeeDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetRestaurantDeliveryFeeDto,
    _$AdminSetRestaurantDeliveryFeeDto,
  ];

  @override
  final String wireName = r'AdminSetRestaurantDeliveryFeeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'rule';
    yield object.rule == null
        ? null
        : serializers.serialize(
            object.rule,
            specifiedType: const FullType.nullable(
              AdminSetRestaurantDeliveryFeeDtoRule,
            ),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDto object, {
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
    required AdminSetRestaurantDeliveryFeeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'rule':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminSetRestaurantDeliveryFeeDtoRule,
                    ),
                  )
                  as AdminSetRestaurantDeliveryFeeDtoRule?;
          if (valueDes == null) continue;
          result.rule.replace(valueDes);
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetRestaurantDeliveryFeeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetRestaurantDeliveryFeeDtoBuilder();
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
