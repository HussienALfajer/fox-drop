//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_order_history_dto_output_orders_inner_steps_inner.dart';
import 'package:core_api/src/model/captain_order_history_dto_output_orders_inner_paid_to_restaurant_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_history_dto_output_orders_inner.g.dart';

/// CaptainOrderHistoryDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [placedAt]
/// * [day] - The business day it was placed on, for the grouping.
/// * [restaurantName]
/// * [neighbourhood] - «الحي» only: never the customer's name, phone or address (K8).
/// * [status]
/// * [outcome] - How it ended (AP Appendix C); null when not delivered or failed.
/// * [testOrder]
/// * [redelivery] - «إعادة توصيل مجانية».
/// * [handedOver] - «سلّمته لكابتن آخر»: the captain handed it over; the order went on without them.
/// * [pay] - Integer minor units of its currency.
/// * [paidToRestaurant] - «دفعت للمطعم»: the confirmed pickup payment.
/// * [collected] - «قبضت»: what the captain received at the door.
/// * [change] - «الباقي»: the change given back.
/// * [steps] - The captain's own steps, oldest first (CA §9.13 detail).
@BuiltValue()
abstract class CaptainOrderHistoryDtoOutputOrdersInner
    implements
        Built<
          CaptainOrderHistoryDtoOutputOrdersInner,
          CaptainOrderHistoryDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  /// The business day it was placed on, for the grouping.
  @BuiltValueField(wireName: r'day')
  Date get day;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  /// «الحي» only: never the customer's name, phone or address (K8).
  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  @BuiltValueField(wireName: r'status')
  CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// How it ended (AP Appendix C); null when not delivered or failed.
  @BuiltValueField(wireName: r'outcome')
  CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum? get outcome;
  // enum outcomeEnum {  normal,  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'testOrder')
  bool get testOrder;

  /// «إعادة توصيل مجانية».
  @BuiltValueField(wireName: r'redelivery')
  bool get redelivery;

  /// «سلّمته لكابتن آخر»: the captain handed it over; the order went on without them.
  @BuiltValueField(wireName: r'handedOver')
  bool get handedOver;

  /// Integer minor units of its currency.
  @BuiltValueField(wireName: r'pay')
  String? get pay;

  /// «دفعت للمطعم»: the confirmed pickup payment.
  @BuiltValueField(wireName: r'paidToRestaurant')
  BuiltList<CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner>
  get paidToRestaurant;

  /// «قبضت»: what the captain received at the door.
  @BuiltValueField(wireName: r'collected')
  BuiltList<CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner>
  get collected;

  /// «الباقي»: the change given back.
  @BuiltValueField(wireName: r'change')
  BuiltList<CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner>
  get change;

  /// The captain's own steps, oldest first (CA §9.13 detail).
  @BuiltValueField(wireName: r'steps')
  BuiltList<CaptainOrderHistoryDtoOutputOrdersInnerStepsInner> get steps;

  CaptainOrderHistoryDtoOutputOrdersInner._();

  factory CaptainOrderHistoryDtoOutputOrdersInner([
    void updates(CaptainOrderHistoryDtoOutputOrdersInnerBuilder b),
  ]) = _$CaptainOrderHistoryDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderHistoryDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderHistoryDtoOutputOrdersInner> get serializer =>
      _$CaptainOrderHistoryDtoOutputOrdersInnerSerializer();
}

class _$CaptainOrderHistoryDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<CaptainOrderHistoryDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderHistoryDtoOutputOrdersInner,
    _$CaptainOrderHistoryDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'CaptainOrderHistoryDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderHistoryDtoOutputOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(Date),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum,
            ),
          );
    yield r'testOrder';
    yield serializers.serialize(
      object.testOrder,
      specifiedType: const FullType(bool),
    );
    yield r'redelivery';
    yield serializers.serialize(
      object.redelivery,
      specifiedType: const FullType(bool),
    );
    yield r'handedOver';
    yield serializers.serialize(
      object.handedOver,
      specifiedType: const FullType(bool),
    );
    yield r'pay';
    yield object.pay == null
        ? null
        : serializers.serialize(
            object.pay,
            specifiedType: const FullType.nullable(String),
          );
    yield r'paidToRestaurant';
    yield serializers.serialize(
      object.paidToRestaurant,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner),
      ]),
    );
    yield r'collected';
    yield serializers.serialize(
      object.collected,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner),
      ]),
    );
    yield r'change';
    yield serializers.serialize(
      object.change,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner),
      ]),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainOrderHistoryDtoOutputOrdersInnerStepsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderHistoryDtoOutputOrdersInner object, {
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
    required CaptainOrderHistoryDtoOutputOrdersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'day':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.day = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'neighbourhood':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.neighbourhood = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum,
                    ),
                  )
                  as CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'testOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.testOrder = valueDes;
          break;
        case r'redelivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.redelivery = valueDes;
          break;
        case r'handedOver':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.handedOver = valueDes;
          break;
        case r'pay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.pay = valueDes;
          break;
        case r'paidToRestaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner
                  >;
          result.paidToRestaurant.replace(valueDes);
          break;
        case r'collected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner
                  >;
          result.collected.replace(valueDes);
          break;
        case r'change':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainOrderHistoryDtoOutputOrdersInnerPaidToRestaurantInner
                  >;
          result.change.replace(valueDes);
          break;
        case r'steps':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainOrderHistoryDtoOutputOrdersInnerStepsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainOrderHistoryDtoOutputOrdersInnerStepsInner
                  >;
          result.steps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderHistoryDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderHistoryDtoOutputOrdersInnerBuilder();
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

class CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum placed =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum accepted =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum ready =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum pickedUp =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum arrived =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum delivered =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum rejected =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum cancelled =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum failed =
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get serializer =>
      _$captainOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer;

  const CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get values => _$captainOrderHistoryDtoOutputOrdersInnerStatusEnumValues;
  static CaptainOrderHistoryDtoOutputOrdersInnerStatusEnum valueOf(
    String name,
  ) => _$captainOrderHistoryDtoOutputOrdersInnerStatusEnumValueOf(name);
}

/// How it ended (AP Appendix C); null when not delivered or failed.
class CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'normal')
  static const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum normal =
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnum_normal;
  @BuiltValueEnumConst(wireName: r'free')
  static const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum free =
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum fake =
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum damaged =
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum wrongRefused =
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum failedOther =
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnum_failedOther;

  static Serializer<CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum>
  get serializer =>
      _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnumSerializer;

  const CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum>
  get values => _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnumValues;
  static CaptainOrderHistoryDtoOutputOrdersInnerOutcomeEnum valueOf(
    String name,
  ) => _$captainOrderHistoryDtoOutputOrdersInnerOutcomeEnumValueOf(name);
}
