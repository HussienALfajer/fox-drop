//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_timeline_inner.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner
///
/// Properties:
/// * [step] - «تم الطلب», «قبل المطعم», «استلم الكابتن», «الكابتن عند الباب», «تم التسليم», «تعذّر التسليم», «رفض المطعم», «أُلغي».
/// * [at]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner,
          CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder
        > {
  /// «تم الطلب», «قبل المطعم», «استلم الكابتن», «الكابتن عند الباب», «تم التسليم», «تعذّر التسليم», «رفض المطعم», «أُلغي».
  @BuiltValueField(wireName: r'step')
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum get step;
  // enum stepEnum {  placed,  accepted,  picked_up,  arrived,  delivered,  failed,  rejected,  cancelled,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner,
    _$CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum,
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
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder
    result,
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
                      CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum;
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
  CustomerActiveOrdersDtoOutputOrdersInnerTimelineInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerBuilder();
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

/// «تم الطلب», «قبل المطعم», «استلم الكابتن», «الكابتن عند الباب», «تم التسليم», «تعذّر التسليم», «رفض المطعم», «أُلغي».
class CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  placed =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  accepted =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_accepted;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  pickedUp =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  arrived =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  delivered =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  failed =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_failed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  rejected =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  cancelled =
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum_cancelled;

  static Serializer<
    CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum
  >
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum>
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnum valueOf(
    String name,
  ) => _$customerActiveOrdersDtoOutputOrdersInnerTimelineInnerStepEnumValueOf(
    name,
  );
}
