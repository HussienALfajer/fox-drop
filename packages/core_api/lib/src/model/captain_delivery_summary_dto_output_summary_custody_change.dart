//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_delivery_summary_dto_output_summary_custody_change.g.dart';

/// «تغيّرت عهدتك: {+المبلغ}»: the net collected minus the pickup payment.
///
/// Properties:
/// * [amount] 
/// * [currency] 
@BuiltValue()
abstract class CaptainDeliverySummaryDtoOutputSummaryCustodyChange implements Built<CaptainDeliverySummaryDtoOutputSummaryCustodyChange, CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder> {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainDeliverySummaryDtoOutputSummaryCustodyChange._();

  factory CaptainDeliverySummaryDtoOutputSummaryCustodyChange([void updates(CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder b)]) = _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeliverySummaryDtoOutputSummaryCustodyChange> get serializer => _$CaptainDeliverySummaryDtoOutputSummaryCustodyChangeSerializer();
}

class _$CaptainDeliverySummaryDtoOutputSummaryCustodyChangeSerializer implements PrimitiveSerializer<CaptainDeliverySummaryDtoOutputSummaryCustodyChange> {
  @override
  final Iterable<Type> types = const [CaptainDeliverySummaryDtoOutputSummaryCustodyChange, _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange];

  @override
  final String wireName = r'CaptainDeliverySummaryDtoOutputSummaryCustodyChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutputSummaryCustodyChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutputSummaryCustodyChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDeliverySummaryDtoOutputSummaryCustodyChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder();
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


