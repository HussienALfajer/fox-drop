//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output_order_redelivery_of.g.dart';

/// «إعادة توصيل مجانية لطلب #{رقم}» (AP §9.9.3): the order whose items it re-delivers (owner decision 2026-11-17: the badge); the customer pays 0.
///
/// Properties:
/// * [orderId]
/// * [number]
@BuiltValue()
abstract class CaptainOrderDtoOutputOrderRedeliveryOf
    implements
        Built<
          CaptainOrderDtoOutputOrderRedeliveryOf,
          CaptainOrderDtoOutputOrderRedeliveryOfBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  CaptainOrderDtoOutputOrderRedeliveryOf._();

  factory CaptainOrderDtoOutputOrderRedeliveryOf([
    void updates(CaptainOrderDtoOutputOrderRedeliveryOfBuilder b),
  ]) = _$CaptainOrderDtoOutputOrderRedeliveryOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputOrderRedeliveryOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutputOrderRedeliveryOf> get serializer =>
      _$CaptainOrderDtoOutputOrderRedeliveryOfSerializer();
}

class _$CaptainOrderDtoOutputOrderRedeliveryOfSerializer
    implements PrimitiveSerializer<CaptainOrderDtoOutputOrderRedeliveryOf> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderDtoOutputOrderRedeliveryOf,
    _$CaptainOrderDtoOutputOrderRedeliveryOf,
  ];

  @override
  final String wireName = r'CaptainOrderDtoOutputOrderRedeliveryOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutputOrderRedeliveryOf object, {
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
    CaptainOrderDtoOutputOrderRedeliveryOf object, {
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
    required CaptainOrderDtoOutputOrderRedeliveryOfBuilder result,
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
  CaptainOrderDtoOutputOrderRedeliveryOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputOrderRedeliveryOfBuilder();
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
