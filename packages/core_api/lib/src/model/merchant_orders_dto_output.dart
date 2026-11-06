//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output.g.dart';

/// MerchantOrdersDtoOutput
///
/// Properties:
/// * [orders] - Every order until it is delivered or ends, oldest first (RA §8.2).
@BuiltValue()
abstract class MerchantOrdersDtoOutput
    implements Built<MerchantOrdersDtoOutput, MerchantOrdersDtoOutputBuilder> {
  /// Every order until it is delivered or ends, oldest first (RA §8.2).
  @BuiltValueField(wireName: r'orders')
  BuiltList<MerchantOrdersDtoOutputOrdersInner> get orders;

  MerchantOrdersDtoOutput._();

  factory MerchantOrdersDtoOutput([
    void updates(MerchantOrdersDtoOutputBuilder b),
  ]) = _$MerchantOrdersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutput> get serializer =>
      _$MerchantOrdersDtoOutputSerializer();
}

class _$MerchantOrdersDtoOutputSerializer
    implements PrimitiveSerializer<MerchantOrdersDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutput,
    _$MerchantOrdersDtoOutput,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrdersDtoOutputOrdersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutput object, {
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
    required MerchantOrdersDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantOrdersDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<MerchantOrdersDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputBuilder();
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
