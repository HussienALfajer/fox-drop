//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_order_with_timeline_dto_output_order.dart';
import 'package:core_api/src/model/merchant_order_with_timeline_dto_output_timeline_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_with_timeline_dto_output.g.dart';

/// MerchantOrderWithTimelineDtoOutput
///
/// Properties:
/// * [order]
/// * [timeline] - RA §8.18: the steps the order reached, oldest first.
@BuiltValue()
abstract class MerchantOrderWithTimelineDtoOutput
    implements
        Built<
          MerchantOrderWithTimelineDtoOutput,
          MerchantOrderWithTimelineDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'order')
  MerchantOrderWithTimelineDtoOutputOrder get order;

  /// RA §8.18: the steps the order reached, oldest first.
  @BuiltValueField(wireName: r'timeline')
  BuiltList<MerchantOrderWithTimelineDtoOutputTimelineInner> get timeline;

  MerchantOrderWithTimelineDtoOutput._();

  factory MerchantOrderWithTimelineDtoOutput([
    void updates(MerchantOrderWithTimelineDtoOutputBuilder b),
  ]) = _$MerchantOrderWithTimelineDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderWithTimelineDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderWithTimelineDtoOutput> get serializer =>
      _$MerchantOrderWithTimelineDtoOutputSerializer();
}

class _$MerchantOrderWithTimelineDtoOutputSerializer
    implements PrimitiveSerializer<MerchantOrderWithTimelineDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderWithTimelineDtoOutput,
    _$MerchantOrderWithTimelineDtoOutput,
  ];

  @override
  final String wireName = r'MerchantOrderWithTimelineDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(MerchantOrderWithTimelineDtoOutputOrder),
    );
    yield r'timeline';
    yield serializers.serialize(
      object.timeline,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrderWithTimelineDtoOutputTimelineInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutput object, {
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
    required MerchantOrderWithTimelineDtoOutputBuilder result,
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
                      MerchantOrderWithTimelineDtoOutputOrder,
                    ),
                  )
                  as MerchantOrderWithTimelineDtoOutputOrder;
          result.order.replace(valueDes);
          break;
        case r'timeline':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantOrderWithTimelineDtoOutputTimelineInner),
                    ]),
                  )
                  as BuiltList<MerchantOrderWithTimelineDtoOutputTimelineInner>;
          result.timeline.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrderWithTimelineDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderWithTimelineDtoOutputBuilder();
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
