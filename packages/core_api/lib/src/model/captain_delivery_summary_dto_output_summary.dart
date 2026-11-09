//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_delivery_summary_dto_output_summary_hand_in_today.dart';
import 'package:core_api/src/model/captain_delivery_summary_dto_output_summary_custody_change.dart';
import 'package:core_api/src/model/captain_delivery_summary_dto_output_summary_pay.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_delivery_summary_dto_output_summary.g.dart';

/// The order summary (CA §9.8); the captain is free for the next offer.
///
/// Properties:
/// * [orderId]
/// * [number]
/// * [pay]
/// * [custodyChange]
/// * [handInToday]
@BuiltValue()
abstract class CaptainDeliverySummaryDtoOutputSummary
    implements
        Built<
          CaptainDeliverySummaryDtoOutputSummary,
          CaptainDeliverySummaryDtoOutputSummaryBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'pay')
  CaptainDeliverySummaryDtoOutputSummaryPay get pay;

  @BuiltValueField(wireName: r'custodyChange')
  CaptainDeliverySummaryDtoOutputSummaryCustodyChange get custodyChange;

  @BuiltValueField(wireName: r'handInToday')
  CaptainDeliverySummaryDtoOutputSummaryHandInToday get handInToday;

  CaptainDeliverySummaryDtoOutputSummary._();

  factory CaptainDeliverySummaryDtoOutputSummary([
    void updates(CaptainDeliverySummaryDtoOutputSummaryBuilder b),
  ]) = _$CaptainDeliverySummaryDtoOutputSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeliverySummaryDtoOutputSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeliverySummaryDtoOutputSummary> get serializer =>
      _$CaptainDeliverySummaryDtoOutputSummarySerializer();
}

class _$CaptainDeliverySummaryDtoOutputSummarySerializer
    implements PrimitiveSerializer<CaptainDeliverySummaryDtoOutputSummary> {
  @override
  final Iterable<Type> types = const [
    CaptainDeliverySummaryDtoOutputSummary,
    _$CaptainDeliverySummaryDtoOutputSummary,
  ];

  @override
  final String wireName = r'CaptainDeliverySummaryDtoOutputSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutputSummary object, {
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
    yield r'pay';
    yield serializers.serialize(
      object.pay,
      specifiedType: const FullType(CaptainDeliverySummaryDtoOutputSummaryPay),
    );
    yield r'custodyChange';
    yield serializers.serialize(
      object.custodyChange,
      specifiedType: const FullType(
        CaptainDeliverySummaryDtoOutputSummaryCustodyChange,
      ),
    );
    yield r'handInToday';
    yield serializers.serialize(
      object.handInToday,
      specifiedType: const FullType(
        CaptainDeliverySummaryDtoOutputSummaryHandInToday,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutputSummary object, {
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
    required CaptainDeliverySummaryDtoOutputSummaryBuilder result,
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
        case r'pay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainDeliverySummaryDtoOutputSummaryPay,
                    ),
                  )
                  as CaptainDeliverySummaryDtoOutputSummaryPay;
          result.pay.replace(valueDes);
          break;
        case r'custodyChange':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainDeliverySummaryDtoOutputSummaryCustodyChange,
                    ),
                  )
                  as CaptainDeliverySummaryDtoOutputSummaryCustodyChange;
          result.custodyChange.replace(valueDes);
          break;
        case r'handInToday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainDeliverySummaryDtoOutputSummaryHandInToday,
                    ),
                  )
                  as CaptainDeliverySummaryDtoOutputSummaryHandInToday;
          result.handInToday.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDeliverySummaryDtoOutputSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeliverySummaryDtoOutputSummaryBuilder();
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
