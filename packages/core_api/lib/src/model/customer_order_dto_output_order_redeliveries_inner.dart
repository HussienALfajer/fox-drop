//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_dto_output_order_redeliveries_inner.g.dart';

/// CustomerOrderDtoOutputOrderRedeliveriesInner
///
/// Properties:
/// * [orderId]
/// * [number]
@BuiltValue()
abstract class CustomerOrderDtoOutputOrderRedeliveriesInner
    implements
        Built<
          CustomerOrderDtoOutputOrderRedeliveriesInner,
          CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  CustomerOrderDtoOutputOrderRedeliveriesInner._();

  factory CustomerOrderDtoOutputOrderRedeliveriesInner([
    void updates(CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder b),
  ]) = _$CustomerOrderDtoOutputOrderRedeliveriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderDtoOutputOrderRedeliveriesInner>
  get serializer => _$CustomerOrderDtoOutputOrderRedeliveriesInnerSerializer();
}

class _$CustomerOrderDtoOutputOrderRedeliveriesInnerSerializer
    implements
        PrimitiveSerializer<CustomerOrderDtoOutputOrderRedeliveriesInner> {
  @override
  final Iterable<Type> types = const [
    CustomerOrderDtoOutputOrderRedeliveriesInner,
    _$CustomerOrderDtoOutputOrderRedeliveriesInner,
  ];

  @override
  final String wireName = r'CustomerOrderDtoOutputOrderRedeliveriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderDtoOutputOrderRedeliveriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderDtoOutputOrderRedeliveriesInner object, {
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
    required CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerOrderDtoOutputOrderRedeliveriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderDtoOutputOrderRedeliveriesInnerBuilder();
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
