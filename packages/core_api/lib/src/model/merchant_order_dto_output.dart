//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_dto_output.g.dart';

/// MerchantOrderDtoOutput
///
/// Properties:
/// * [order]
@BuiltValue()
abstract class MerchantOrderDtoOutput
    implements Built<MerchantOrderDtoOutput, MerchantOrderDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  MerchantOrdersDtoOutputOrdersInner get order;

  MerchantOrderDtoOutput._();

  factory MerchantOrderDtoOutput([
    void updates(MerchantOrderDtoOutputBuilder b),
  ]) = _$MerchantOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderDtoOutput> get serializer =>
      _$MerchantOrderDtoOutputSerializer();
}

class _$MerchantOrderDtoOutputSerializer
    implements PrimitiveSerializer<MerchantOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderDtoOutput,
    _$MerchantOrderDtoOutput,
  ];

  @override
  final String wireName = r'MerchantOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInner),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderDtoOutput object, {
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
    required MerchantOrderDtoOutputBuilder result,
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
                      MerchantOrdersDtoOutputOrdersInner,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInner;
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
  MerchantOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderDtoOutputBuilder();
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
