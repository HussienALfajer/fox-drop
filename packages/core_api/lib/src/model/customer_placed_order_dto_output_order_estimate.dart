//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_placed_order_dto_output_order_estimate.g.dart';

/// CustomerPlacedOrderDtoOutputOrderEstimate
///
/// Properties:
/// * [fromMin]
/// * [toMin]
@BuiltValue()
abstract class CustomerPlacedOrderDtoOutputOrderEstimate
    implements
        Built<
          CustomerPlacedOrderDtoOutputOrderEstimate,
          CustomerPlacedOrderDtoOutputOrderEstimateBuilder
        > {
  @BuiltValueField(wireName: r'fromMin')
  int get fromMin;

  @BuiltValueField(wireName: r'toMin')
  int get toMin;

  CustomerPlacedOrderDtoOutputOrderEstimate._();

  factory CustomerPlacedOrderDtoOutputOrderEstimate([
    void updates(CustomerPlacedOrderDtoOutputOrderEstimateBuilder b),
  ]) = _$CustomerPlacedOrderDtoOutputOrderEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPlacedOrderDtoOutputOrderEstimateBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlacedOrderDtoOutputOrderEstimate> get serializer =>
      _$CustomerPlacedOrderDtoOutputOrderEstimateSerializer();
}

class _$CustomerPlacedOrderDtoOutputOrderEstimateSerializer
    implements PrimitiveSerializer<CustomerPlacedOrderDtoOutputOrderEstimate> {
  @override
  final Iterable<Type> types = const [
    CustomerPlacedOrderDtoOutputOrderEstimate,
    _$CustomerPlacedOrderDtoOutputOrderEstimate,
  ];

  @override
  final String wireName = r'CustomerPlacedOrderDtoOutputOrderEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrderEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromMin';
    yield serializers.serialize(
      object.fromMin,
      specifiedType: const FullType(int),
    );
    yield r'toMin';
    yield serializers.serialize(
      object.toMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrderEstimate object, {
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
    required CustomerPlacedOrderDtoOutputOrderEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.fromMin = valueDes;
          break;
        case r'toMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.toMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPlacedOrderDtoOutputOrderEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlacedOrderDtoOutputOrderEstimateBuilder();
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
