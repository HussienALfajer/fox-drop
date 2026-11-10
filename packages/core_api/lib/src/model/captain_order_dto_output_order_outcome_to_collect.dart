//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_outcome_to_collect_amount.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output_order_outcome_to_collect.g.dart';

/// Operations ended the order with an amount to collect (CA §9.10, K9): «أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.», the payment screen for this amount and the badge «بانتظار تسجيل التحصيل»; record it with POST .../outcome-payment.
///
/// Properties:
/// * [outcome]
/// * [amount]
/// * [equivalents] - The amount in the other accepted currencies, each by its rounding (CA §9.7).
@BuiltValue()
abstract class CaptainOrderDtoOutputOrderOutcomeToCollect
    implements
        Built<
          CaptainOrderDtoOutputOrderOutcomeToCollect,
          CaptainOrderDtoOutputOrderOutcomeToCollectBuilder
        > {
  @BuiltValueField(wireName: r'outcome')
  CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  damaged,  };

  @BuiltValueField(wireName: r'amount')
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount get amount;

  /// The amount in the other accepted currencies, each by its rounding (CA §9.7).
  @BuiltValueField(wireName: r'equivalents')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get equivalents;

  CaptainOrderDtoOutputOrderOutcomeToCollect._();

  factory CaptainOrderDtoOutputOrderOutcomeToCollect([
    void updates(CaptainOrderDtoOutputOrderOutcomeToCollectBuilder b),
  ]) = _$CaptainOrderDtoOutputOrderOutcomeToCollect;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputOrderOutcomeToCollectBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutputOrderOutcomeToCollect>
  get serializer => _$CaptainOrderDtoOutputOrderOutcomeToCollectSerializer();
}

class _$CaptainOrderDtoOutputOrderOutcomeToCollectSerializer
    implements PrimitiveSerializer<CaptainOrderDtoOutputOrderOutcomeToCollect> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderDtoOutputOrderOutcomeToCollect,
    _$CaptainOrderDtoOutputOrderOutcomeToCollect,
  ];

  @override
  final String wireName = r'CaptainOrderDtoOutputOrderOutcomeToCollect';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutputOrderOutcomeToCollect object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(
        CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum,
      ),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount,
      ),
    );
    yield r'equivalents';
    yield serializers.serialize(
      object.equivalents,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainAvailabilityDtoOutputCustodyLimit),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrderOutcomeToCollect object, {
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
    required CaptainOrderDtoOutputOrderOutcomeToCollectBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum,
                    ),
                  )
                  as CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount;
          result.amount.replace(valueDes);
          break;
        case r'equivalents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainAvailabilityDtoOutputCustodyLimit),
                    ]),
                  )
                  as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.equivalents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderDtoOutputOrderOutcomeToCollect deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputOrderOutcomeToCollectBuilder();
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

class CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum free =
      _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum damaged =
      _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged;

  static Serializer<CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
  get serializer =>
      _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer;

  const CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
  get values => _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValues;
  static CaptainOrderDtoOutputOrderOutcomeToCollectOutcomeEnum valueOf(
    String name,
  ) => _$captainOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValueOf(name);
}
