//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_order_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_dto_output.g.dart';

/// CustomerOrderDtoOutput
///
/// Properties:
/// * [order] 
@BuiltValue()
abstract class CustomerOrderDtoOutput implements Built<CustomerOrderDtoOutput, CustomerOrderDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  CustomerOrderDtoOutputOrder get order;

  CustomerOrderDtoOutput._();

  factory CustomerOrderDtoOutput([void updates(CustomerOrderDtoOutputBuilder b)]) = _$CustomerOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderDtoOutput> get serializer => _$CustomerOrderDtoOutputSerializer();
}

class _$CustomerOrderDtoOutputSerializer implements PrimitiveSerializer<CustomerOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerOrderDtoOutput, _$CustomerOrderDtoOutput];

  @override
  final String wireName = r'CustomerOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(CustomerOrderDtoOutputOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerOrderDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerOrderDtoOutputOrder),
          ) as CustomerOrderDtoOutputOrder;
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
  CustomerOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderDtoOutputBuilder();
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


