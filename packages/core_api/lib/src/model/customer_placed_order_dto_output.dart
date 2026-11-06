//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_placed_order_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_placed_order_dto_output.g.dart';

/// CustomerPlacedOrderDtoOutput
///
/// Properties:
/// * [order]
@BuiltValue()
abstract class CustomerPlacedOrderDtoOutput
    implements
        Built<
          CustomerPlacedOrderDtoOutput,
          CustomerPlacedOrderDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'order')
  CustomerPlacedOrderDtoOutputOrder get order;

  CustomerPlacedOrderDtoOutput._();

  factory CustomerPlacedOrderDtoOutput([
    void updates(CustomerPlacedOrderDtoOutputBuilder b),
  ]) = _$CustomerPlacedOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPlacedOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlacedOrderDtoOutput> get serializer =>
      _$CustomerPlacedOrderDtoOutputSerializer();
}

class _$CustomerPlacedOrderDtoOutputSerializer
    implements PrimitiveSerializer<CustomerPlacedOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerPlacedOrderDtoOutput,
    _$CustomerPlacedOrderDtoOutput,
  ];

  @override
  final String wireName = r'CustomerPlacedOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlacedOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(CustomerPlacedOrderDtoOutputOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPlacedOrderDtoOutput object, {
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
    required CustomerPlacedOrderDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerPlacedOrderDtoOutputOrder,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrder;
          result.order.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPlacedOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlacedOrderDtoOutputBuilder();
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
