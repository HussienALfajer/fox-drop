//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_history_dto_output_orders_inner_steps_inner.g.dart';

/// CaptainOrderHistoryDtoOutputOrdersInnerStepsInner
///
/// Properties:
/// * [step]
/// * [at]
@BuiltValue()
abstract class CaptainOrderHistoryDtoOutputOrdersInnerStepsInner
    implements
        Built<
          CaptainOrderHistoryDtoOutputOrdersInnerStepsInner,
          CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerBuilder
        > {
  @BuiltValueField(wireName: r'step')
  CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum get step;
  // enum stepEnum {  assigned,  received_handover,  arrived_at_restaurant,  picked_up,  handed_over,  arrived_at_customer,  delivered,  failed,  cancelled,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainOrderHistoryDtoOutputOrdersInnerStepsInner._();

  factory CaptainOrderHistoryDtoOutputOrdersInnerStepsInner([
    void updates(CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerBuilder b),
  ]) = _$CaptainOrderHistoryDtoOutputOrdersInnerStepsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderHistoryDtoOutputOrdersInnerStepsInner>
  get serializer =>
      _$CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerSerializer();
}

class _$CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerSerializer
    implements
        PrimitiveSerializer<CaptainOrderHistoryDtoOutputOrdersInnerStepsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderHistoryDtoOutputOrdersInnerStepsInner,
    _$CaptainOrderHistoryDtoOutputOrdersInnerStepsInner,
  ];

  @override
  final String wireName = r'CaptainOrderHistoryDtoOutputOrdersInnerStepsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderHistoryDtoOutputOrdersInnerStepsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(
        CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum,
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
    CaptainOrderHistoryDtoOutputOrdersInnerStepsInner object, {
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
    required CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerBuilder result,
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
                      CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum,
                    ),
                  )
                  as CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum;
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
  CaptainOrderHistoryDtoOutputOrdersInnerStepsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerBuilder();
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

class CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'assigned')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  assigned =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_assigned;
  @BuiltValueEnumConst(wireName: r'received_handover')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  receivedHandover =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_receivedHandover;
  @BuiltValueEnumConst(wireName: r'arrived_at_restaurant')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  arrivedAtRestaurant =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_arrivedAtRestaurant;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  pickedUp =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'handed_over')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  handedOver =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_handedOver;
  @BuiltValueEnumConst(wireName: r'arrived_at_customer')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  arrivedAtCustomer =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_arrivedAtCustomer;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  delivered =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  failed = _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_failed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum
  cancelled =
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum_cancelled;

  static Serializer<CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum>
  get serializer =>
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnumSerializer;

  const CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum._(String name)
    : super(name);

  static BuiltSet<CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum>
  get values =>
      _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnumValues;
  static CaptainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnum valueOf(
    String name,
  ) => _$captainOrderHistoryDtoOutputOrdersInnerStepsInnerStepEnumValueOf(name);
}
