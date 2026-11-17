//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_rate_order_dto_restaurant.dart';
import 'package:core_api/src/model/customer_rate_order_dto_captain.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_rate_order_dto.g.dart';

/// CustomerRateOrderDto
///
/// Properties:
/// * [restaurant]
/// * [captain]
@BuiltValue()
abstract class CustomerRateOrderDto
    implements Built<CustomerRateOrderDto, CustomerRateOrderDtoBuilder> {
  @BuiltValueField(wireName: r'restaurant')
  CustomerRateOrderDtoRestaurant? get restaurant;

  @BuiltValueField(wireName: r'captain')
  CustomerRateOrderDtoCaptain? get captain;

  CustomerRateOrderDto._();

  factory CustomerRateOrderDto([void updates(CustomerRateOrderDtoBuilder b)]) =
      _$CustomerRateOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRateOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRateOrderDto> get serializer =>
      _$CustomerRateOrderDtoSerializer();
}

class _$CustomerRateOrderDtoSerializer
    implements PrimitiveSerializer<CustomerRateOrderDto> {
  @override
  final Iterable<Type> types = const [
    CustomerRateOrderDto,
    _$CustomerRateOrderDto,
  ];

  @override
  final String wireName = r'CustomerRateOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRateOrderDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurant';
    yield object.restaurant == null
        ? null
        : serializers.serialize(
            object.restaurant,
            specifiedType: const FullType.nullable(
              CustomerRateOrderDtoRestaurant,
            ),
          );
    yield r'captain';
    yield object.captain == null
        ? null
        : serializers.serialize(
            object.captain,
            specifiedType: const FullType.nullable(CustomerRateOrderDtoCaptain),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRateOrderDto object, {
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
    required CustomerRateOrderDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerRateOrderDtoRestaurant,
                    ),
                  )
                  as CustomerRateOrderDtoRestaurant?;
          if (valueDes == null) continue;
          result.restaurant.replace(valueDes);
          break;
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerRateOrderDtoCaptain,
                    ),
                  )
                  as CustomerRateOrderDtoCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRateOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRateOrderDtoBuilder();
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
