//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_outcome_to_collect_amount.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_outcome_to_collect.g.dart';

/// Operations ended the order with an amount to collect (CA §9.10, K9): «أنهت العمليات الطلب: {النتيجة}. اقبض {المبلغ}.», the payment screen for this amount and the badge «بانتظار تسجيل التحصيل»; record it with POST .../outcome-payment.
///
/// Properties:
/// * [outcome]
/// * [amount]
/// * [equivalents] - The amount in the other accepted currencies, each by its rounding (CA §9.7).
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderOutcomeToCollect
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderOutcomeToCollect,
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder
        > {
  @BuiltValueField(wireName: r'outcome')
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  damaged,  };

  @BuiltValueField(wireName: r'amount')
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount get amount;

  /// The amount in the other accepted currencies, each by its rounding (CA §9.7).
  @BuiltValueField(wireName: r'equivalents')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get equivalents;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollect._();

  factory CaptainActiveOrderDtoOutputOrderOutcomeToCollect([
    void updates(CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderOutcomeToCollect>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderOutcomeToCollect> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderOutcomeToCollect,
    _$CaptainActiveOrderDtoOutputOrderOutcomeToCollect,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderOutcomeToCollect';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderOutcomeToCollect object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum,
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
        FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderOutcomeToCollect object, {
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
    required CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder result,
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
                      CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum;
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
                      FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
                    ]),
                  )
                  as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
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
  CaptainActiveOrderDtoOutputOrderOutcomeToCollect deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderOutcomeToCollectBuilder();
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

class CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
  free = _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum
  damaged =
      _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum_damaged;

  static Serializer<CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum>
  get values =>
      _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValues;
  static CaptainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderOutcomeToCollectOutcomeEnumValueOf(
    name,
  );
}
