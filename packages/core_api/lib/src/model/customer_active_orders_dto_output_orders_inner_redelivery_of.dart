//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_redelivery_of.g.dart';

/// CU §11.2: «إعادة توصيل مجانية لطلب #{رقم}» (AP §9.9.3): the order whose items it re-delivers; a total of 0, never cancelled or rated.
///
/// Properties:
/// * [orderId]
/// * [number]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf,
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf,
    _$CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf object, {
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
    CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder result,
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
  CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerRedeliveryOfBuilder();
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
