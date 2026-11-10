//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_ended_charge.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_ended_pay.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_ended.g.dart';

/// The latest order operations ended with an outcome within 12 hours that the captain has not acknowledged (POST …/acknowledge-outcome).
///
/// Properties:
/// * [orderId]
/// * [number]
/// * [outcome] - «أنهت العمليات الطلب: {النتيجة}.» with the label of AP Appendix C.
/// * [status]
/// * [food] - Where a failed order's food goes (CA §9.12), by Content's food_after_failed.
/// * [pay]
/// * [charge]
/// * [at]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputEnded
    implements
        Built<
          CaptainActiveOrderDtoOutputEnded,
          CaptainActiveOrderDtoOutputEndedBuilder
        > {
  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'number')
  String get number;

  /// «أنهت العمليات الطلب: {النتيجة}.» with the label of AP Appendix C.
  @BuiltValueField(wireName: r'outcome')
  CaptainActiveOrderDtoOutputEndedOutcomeEnum get outcome;
  // enum outcomeEnum {  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'status')
  CaptainActiveOrderDtoOutputEndedStatusEnum get status;
  // enum statusEnum {  delivered,  failed,  };

  /// Where a failed order's food goes (CA §9.12), by Content's food_after_failed.
  @BuiltValueField(wireName: r'food')
  CaptainActiveOrderDtoOutputEndedFoodEnum? get food;
  // enum foodEnum {  kept_by_captain,  returned_to_restaurant,  destroyed,  };

  @BuiltValueField(wireName: r'pay')
  CaptainActiveOrderDtoOutputEndedPay? get pay;

  @BuiltValueField(wireName: r'charge')
  CaptainActiveOrderDtoOutputEndedCharge? get charge;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputEnded._();

  factory CaptainActiveOrderDtoOutputEnded([
    void updates(CaptainActiveOrderDtoOutputEndedBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputEnded;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputEndedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputEnded> get serializer =>
      _$CaptainActiveOrderDtoOutputEndedSerializer();
}

class _$CaptainActiveOrderDtoOutputEndedSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputEnded> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputEnded,
    _$CaptainActiveOrderDtoOutputEnded,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputEnded';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputEnded object, {
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
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputEndedOutcomeEnum,
      ),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputEndedStatusEnum),
    );
    yield r'food';
    yield object.food == null
        ? null
        : serializers.serialize(
            object.food,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputEndedFoodEnum,
            ),
          );
    yield r'pay';
    yield object.pay == null
        ? null
        : serializers.serialize(
            object.pay,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputEndedPay,
            ),
          );
    yield r'charge';
    yield object.charge == null
        ? null
        : serializers.serialize(
            object.charge,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputEndedCharge,
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
    CaptainActiveOrderDtoOutputEnded object, {
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
    required CaptainActiveOrderDtoOutputEndedBuilder result,
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
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputEndedOutcomeEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputEndedOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputEndedStatusEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputEndedStatusEnum;
          result.status = valueDes;
          break;
        case r'food':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputEndedFoodEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputEndedFoodEnum?;
          if (valueDes == null) continue;
          result.food = valueDes;
          break;
        case r'pay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputEndedPay,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputEndedPay?;
          if (valueDes == null) continue;
          result.pay.replace(valueDes);
          break;
        case r'charge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputEndedCharge,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputEndedCharge?;
          if (valueDes == null) continue;
          result.charge.replace(valueDes);
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
  CaptainActiveOrderDtoOutputEnded deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputEndedBuilder();
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

/// «أنهت العمليات الطلب: {النتيجة}.» with the label of AP Appendix C.
class CaptainActiveOrderDtoOutputEndedOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'free')
  static const CaptainActiveOrderDtoOutputEndedOutcomeEnum free =
      _$captainActiveOrderDtoOutputEndedOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const CaptainActiveOrderDtoOutputEndedOutcomeEnum fake =
      _$captainActiveOrderDtoOutputEndedOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const CaptainActiveOrderDtoOutputEndedOutcomeEnum damaged =
      _$captainActiveOrderDtoOutputEndedOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const CaptainActiveOrderDtoOutputEndedOutcomeEnum wrongRefused =
      _$captainActiveOrderDtoOutputEndedOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const CaptainActiveOrderDtoOutputEndedOutcomeEnum failedOther =
      _$captainActiveOrderDtoOutputEndedOutcomeEnum_failedOther;

  static Serializer<CaptainActiveOrderDtoOutputEndedOutcomeEnum>
  get serializer => _$captainActiveOrderDtoOutputEndedOutcomeEnumSerializer;

  const CaptainActiveOrderDtoOutputEndedOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputEndedOutcomeEnum> get values =>
      _$captainActiveOrderDtoOutputEndedOutcomeEnumValues;
  static CaptainActiveOrderDtoOutputEndedOutcomeEnum valueOf(String name) =>
      _$captainActiveOrderDtoOutputEndedOutcomeEnumValueOf(name);
}

class CaptainActiveOrderDtoOutputEndedStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CaptainActiveOrderDtoOutputEndedStatusEnum delivered =
      _$captainActiveOrderDtoOutputEndedStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CaptainActiveOrderDtoOutputEndedStatusEnum failed =
      _$captainActiveOrderDtoOutputEndedStatusEnum_failed;

  static Serializer<CaptainActiveOrderDtoOutputEndedStatusEnum>
  get serializer => _$captainActiveOrderDtoOutputEndedStatusEnumSerializer;

  const CaptainActiveOrderDtoOutputEndedStatusEnum._(String name) : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputEndedStatusEnum> get values =>
      _$captainActiveOrderDtoOutputEndedStatusEnumValues;
  static CaptainActiveOrderDtoOutputEndedStatusEnum valueOf(String name) =>
      _$captainActiveOrderDtoOutputEndedStatusEnumValueOf(name);
}

/// Where a failed order's food goes (CA §9.12), by Content's food_after_failed.
class CaptainActiveOrderDtoOutputEndedFoodEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'kept_by_captain')
  static const CaptainActiveOrderDtoOutputEndedFoodEnum keptByCaptain =
      _$captainActiveOrderDtoOutputEndedFoodEnum_keptByCaptain;
  @BuiltValueEnumConst(wireName: r'returned_to_restaurant')
  static const CaptainActiveOrderDtoOutputEndedFoodEnum returnedToRestaurant =
      _$captainActiveOrderDtoOutputEndedFoodEnum_returnedToRestaurant;
  @BuiltValueEnumConst(wireName: r'destroyed')
  static const CaptainActiveOrderDtoOutputEndedFoodEnum destroyed =
      _$captainActiveOrderDtoOutputEndedFoodEnum_destroyed;

  static Serializer<CaptainActiveOrderDtoOutputEndedFoodEnum> get serializer =>
      _$captainActiveOrderDtoOutputEndedFoodEnumSerializer;

  const CaptainActiveOrderDtoOutputEndedFoodEnum._(String name) : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputEndedFoodEnum> get values =>
      _$captainActiveOrderDtoOutputEndedFoodEnumValues;
  static CaptainActiveOrderDtoOutputEndedFoodEnum valueOf(String name) =>
      _$captainActiveOrderDtoOutputEndedFoodEnumValueOf(name);
}
