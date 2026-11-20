//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_with_timeline_dto_output_timeline_inner.g.dart';

/// MerchantOrderWithTimelineDtoOutputTimelineInner
///
/// Properties:
/// * [step]
/// * [at]
@BuiltValue()
abstract class MerchantOrderWithTimelineDtoOutputTimelineInner
    implements
        Built<
          MerchantOrderWithTimelineDtoOutputTimelineInner,
          MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder
        > {
  @BuiltValueField(wireName: r'step')
  MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum get step;
  // enum stepEnum {  placed,  accepted,  picked_up,  arrived,  delivered,  failed,  rejected,  cancelled,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  MerchantOrderWithTimelineDtoOutputTimelineInner._();

  factory MerchantOrderWithTimelineDtoOutputTimelineInner([
    void updates(MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder b),
  ]) = _$MerchantOrderWithTimelineDtoOutputTimelineInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderWithTimelineDtoOutputTimelineInner>
  get serializer =>
      _$MerchantOrderWithTimelineDtoOutputTimelineInnerSerializer();
}

class _$MerchantOrderWithTimelineDtoOutputTimelineInnerSerializer
    implements
        PrimitiveSerializer<MerchantOrderWithTimelineDtoOutputTimelineInner> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderWithTimelineDtoOutputTimelineInner,
    _$MerchantOrderWithTimelineDtoOutputTimelineInner,
  ];

  @override
  final String wireName = r'MerchantOrderWithTimelineDtoOutputTimelineInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutputTimelineInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(
        MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum,
      ),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutputTimelineInner object, {
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
    required MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'step':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum,
                    ),
                  )
                  as MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum;
          result.step = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrderWithTimelineDtoOutputTimelineInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderWithTimelineDtoOutputTimelineInnerBuilder();
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

class MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum placed =
      _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
  accepted = _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_accepted;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
  pickedUp = _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum arrived =
      _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
  delivered =
      _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum failed =
      _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_failed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
  rejected = _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum
  cancelled =
      _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnum_cancelled;

  static Serializer<MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum>
  get serializer =>
      _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnumSerializer;

  const MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum._(String name)
    : super(name);

  static BuiltSet<MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum>
  get values => _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnumValues;
  static MerchantOrderWithTimelineDtoOutputTimelineInnerStepEnum valueOf(
    String name,
  ) => _$merchantOrderWithTimelineDtoOutputTimelineInnerStepEnumValueOf(name);
}
