//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_redeliveries_inner.g.dart';

/// «إعادة توصيل مجانية لطلب #{رقم}» (AP §9.9.3): the order whose items it re-delivers (owner decision 2026-11-17: the badge); its items carry no price when the restaurant replaces them.
///
/// Properties:
/// * [orderId]
/// * [number]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner,
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner,
    _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner object, {
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
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder
    result,
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
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerRedeliveriesInnerBuilder();
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
