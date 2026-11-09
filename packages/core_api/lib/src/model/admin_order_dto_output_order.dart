//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_customer.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_acceptance.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_rejection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_lines_inner.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_delivery.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_timeline_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_total.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_cancellation.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_badges.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_moments.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_money.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_captain.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_restaurant.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_pickup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order.g.dart';

/// AdminOrderDtoOutputOrder
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status] - The board column (AP §9.2.1).
/// * [version] - Increases with every change (architecture §5.3).
/// * [placedAt]
/// * [restaurant]
/// * [neighbourhood]
/// * [statusSince] - The time in the current state counts from it.
/// * [limitAt] - The column's limit (AP §9.2.1): green before 80% of it, amber from 80%, red past it; null where it is not built yet.
/// * [captainTrack] - AP §8.2; null before the search starts and before any offer.
/// * [captain]
/// * [total]
/// * [badges]
/// * [moments]
/// * [alerts] - AP §9.1.3, open now by their conditions (GET /v1/admin/alerts holds the records, with who took each); «تسليم بعيد عن العنوان» only while the order is active.
/// * [promisedAt]
/// * [acceptance]
/// * [readyAt]
/// * [cancellation]
/// * [rejection]
/// * [customer]
/// * [note]
/// * [lines]
/// * [money]
/// * [pickup]
/// * [delivery]
/// * [timeline]
@BuiltValue()
abstract class AdminOrderDtoOutputOrder
    implements
        Built<AdminOrderDtoOutputOrder, AdminOrderDtoOutputOrderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// The board column (AP §9.2.1).
  @BuiltValueField(wireName: r'status')
  AdminOrderDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3).
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  @BuiltValueField(wireName: r'restaurant')
  AdminOrderCardDtoOutputOrderRestaurant get restaurant;

  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  /// The time in the current state counts from it.
  @BuiltValueField(wireName: r'statusSince')
  DateTime get statusSince;

  /// The column's limit (AP §9.2.1): green before 80% of it, amber from 80%, red past it; null where it is not built yet.
  @BuiltValueField(wireName: r'limitAt')
  DateTime? get limitAt;

  /// AP §8.2; null before the search starts and before any offer.
  @BuiltValueField(wireName: r'captainTrack')
  AdminOrderDtoOutputOrderCaptainTrackEnum? get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  @BuiltValueField(wireName: r'captain')
  AdminOrderCardDtoOutputOrderCaptain? get captain;

  @BuiltValueField(wireName: r'total')
  AdminOrderCardDtoOutputOrderTotal get total;

  @BuiltValueField(wireName: r'badges')
  AdminOrderCardDtoOutputOrderBadges get badges;

  @BuiltValueField(wireName: r'moments')
  AdminOrderCardDtoOutputOrderMoments get moments;

  /// AP §9.1.3, open now by their conditions (GET /v1/admin/alerts holds the records, with who took each); «تسليم بعيد عن العنوان» only while the order is active.
  @BuiltValueField(wireName: r'alerts')
  BuiltList<AdminOrderDtoOutputOrderAlertsEnum> get alerts;
  // enum alertsEnum {  restaurant_not_accepted,  no_captain,  no_captain_after_ready,  captain_gps_lost,  pickup_disputed,  prep_late,  captain_waiting,  delivery_late,  collection_shortfall,  away_from_address,  };

  @BuiltValueField(wireName: r'promisedAt')
  DateTime? get promisedAt;

  @BuiltValueField(wireName: r'acceptance')
  AdminOrderDtoOutputOrderAcceptance? get acceptance;

  @BuiltValueField(wireName: r'readyAt')
  DateTime? get readyAt;

  @BuiltValueField(wireName: r'cancellation')
  AdminOrderDtoOutputOrderCancellation? get cancellation;

  @BuiltValueField(wireName: r'rejection')
  AdminOrderDtoOutputOrderRejection? get rejection;

  @BuiltValueField(wireName: r'customer')
  AdminOrderDtoOutputOrderCustomer get customer;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminOrderDtoOutputOrderLinesInner> get lines;

  @BuiltValueField(wireName: r'money')
  AdminOrderDtoOutputOrderMoney get money;

  @BuiltValueField(wireName: r'pickup')
  AdminOrderDtoOutputOrderPickup get pickup;

  @BuiltValueField(wireName: r'delivery')
  AdminOrderDtoOutputOrderDelivery? get delivery;

  @BuiltValueField(wireName: r'timeline')
  BuiltList<AdminOrderDtoOutputOrderTimelineInner> get timeline;

  AdminOrderDtoOutputOrder._();

  factory AdminOrderDtoOutputOrder([
    void updates(AdminOrderDtoOutputOrderBuilder b),
  ]) = _$AdminOrderDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrder> get serializer =>
      _$AdminOrderDtoOutputOrderSerializer();
}

class _$AdminOrderDtoOutputOrderSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrder,
    _$AdminOrderDtoOutputOrder,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrder object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOrderDtoOutputOrderStatusEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderRestaurant),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
    yield r'statusSince';
    yield serializers.serialize(
      object.statusSince,
      specifiedType: const FullType(DateTime),
    );
    yield r'limitAt';
    yield object.limitAt == null
        ? null
        : serializers.serialize(
            object.limitAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'captainTrack';
    yield object.captainTrack == null
        ? null
        : serializers.serialize(
            object.captainTrack,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderCaptainTrackEnum,
            ),
          );
    yield r'captain';
    yield object.captain == null
        ? null
        : serializers.serialize(
            object.captain,
            specifiedType: const FullType.nullable(
              AdminOrderCardDtoOutputOrderCaptain,
            ),
          );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderTotal),
    );
    yield r'badges';
    yield serializers.serialize(
      object.badges,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderBadges),
    );
    yield r'moments';
    yield serializers.serialize(
      object.moments,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderMoments),
    );
    yield r'alerts';
    yield serializers.serialize(
      object.alerts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderAlertsEnum),
      ]),
    );
    yield r'promisedAt';
    yield object.promisedAt == null
        ? null
        : serializers.serialize(
            object.promisedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'acceptance';
    yield object.acceptance == null
        ? null
        : serializers.serialize(
            object.acceptance,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderAcceptance,
            ),
          );
    yield r'readyAt';
    yield object.readyAt == null
        ? null
        : serializers.serialize(
            object.readyAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'cancellation';
    yield object.cancellation == null
        ? null
        : serializers.serialize(
            object.cancellation,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderCancellation,
            ),
          );
    yield r'rejection';
    yield object.rejection == null
        ? null
        : serializers.serialize(
            object.rejection,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderRejection,
            ),
          );
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(AdminOrderDtoOutputOrderCustomer),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderLinesInner),
      ]),
    );
    yield r'money';
    yield serializers.serialize(
      object.money,
      specifiedType: const FullType(AdminOrderDtoOutputOrderMoney),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(AdminOrderDtoOutputOrderPickup),
    );
    yield r'delivery';
    yield object.delivery == null
        ? null
        : serializers.serialize(
            object.delivery,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderDelivery,
            ),
          );
    yield r'timeline';
    yield serializers.serialize(
      object.timeline,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderTimelineInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrder object, {
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
    required AdminOrderDtoOutputOrderBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderStatusEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
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
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderRestaurant,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderRestaurant;
          result.restaurant.replace(valueDes);
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
        case r'statusSince':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.statusSince = valueDes;
          break;
        case r'limitAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.limitAt = valueDes;
          break;
        case r'captainTrack':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderCaptainTrackEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCaptainTrackEnum?;
          if (valueDes == null) continue;
          result.captainTrack = valueDes;
          break;
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderCardDtoOutputOrderCaptain,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderTotal,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderTotal;
          result.total.replace(valueDes);
          break;
        case r'badges':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderBadges,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderBadges;
          result.badges.replace(valueDes);
          break;
        case r'moments':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderMoments,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderMoments;
          result.moments.replace(valueDes);
          break;
        case r'alerts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderAlertsEnum),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderAlertsEnum>;
          result.alerts.replace(valueDes);
          break;
        case r'promisedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.promisedAt = valueDes;
          break;
        case r'acceptance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderAcceptance,
                    ),
                  )
                  as AdminOrderDtoOutputOrderAcceptance?;
          if (valueDes == null) continue;
          result.acceptance.replace(valueDes);
          break;
        case r'readyAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.readyAt = valueDes;
          break;
        case r'cancellation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderCancellation,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCancellation?;
          if (valueDes == null) continue;
          result.cancellation.replace(valueDes);
          break;
        case r'rejection':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderRejection,
                    ),
                  )
                  as AdminOrderDtoOutputOrderRejection?;
          if (valueDes == null) continue;
          result.rejection.replace(valueDes);
          break;
        case r'customer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderCustomer,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCustomer;
          result.customer.replace(valueDes);
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderLinesInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'money':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderMoney,
                    ),
                  )
                  as AdminOrderDtoOutputOrderMoney;
          result.money.replace(valueDes);
          break;
        case r'pickup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderPickup,
                    ),
                  )
                  as AdminOrderDtoOutputOrderPickup;
          result.pickup.replace(valueDes);
          break;
        case r'delivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderDelivery,
                    ),
                  )
                  as AdminOrderDtoOutputOrderDelivery?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        case r'timeline':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderTimelineInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderTimelineInner>;
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
  AdminOrderDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderBuilder();
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

/// The board column (AP §9.2.1).
class AdminOrderDtoOutputOrderStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderDtoOutputOrderStatusEnum placed =
      _$adminOrderDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderDtoOutputOrderStatusEnum accepted =
      _$adminOrderDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderDtoOutputOrderStatusEnum ready =
      _$adminOrderDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderDtoOutputOrderStatusEnum pickedUp =
      _$adminOrderDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderDtoOutputOrderStatusEnum arrived =
      _$adminOrderDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderDtoOutputOrderStatusEnum delivered =
      _$adminOrderDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderDtoOutputOrderStatusEnum rejected =
      _$adminOrderDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderDtoOutputOrderStatusEnum cancelled =
      _$adminOrderDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderDtoOutputOrderStatusEnum failed =
      _$adminOrderDtoOutputOrderStatusEnum_failed;

  static Serializer<AdminOrderDtoOutputOrderStatusEnum> get serializer =>
      _$adminOrderDtoOutputOrderStatusEnumSerializer;

  const AdminOrderDtoOutputOrderStatusEnum._(String name) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderStatusEnum> get values =>
      _$adminOrderDtoOutputOrderStatusEnumValues;
  static AdminOrderDtoOutputOrderStatusEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderStatusEnumValueOf(name);
}

/// AP §8.2; null before the search starts and before any offer.
class AdminOrderDtoOutputOrderCaptainTrackEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'searching')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum searching =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum offered =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum assigned =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum atMerchant =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum pickupPending =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum pickedUp =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum atCustomer =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const AdminOrderDtoOutputOrderCaptainTrackEnum done =
      _$adminOrderDtoOutputOrderCaptainTrackEnum_done;

  static Serializer<AdminOrderDtoOutputOrderCaptainTrackEnum> get serializer =>
      _$adminOrderDtoOutputOrderCaptainTrackEnumSerializer;

  const AdminOrderDtoOutputOrderCaptainTrackEnum._(String name) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderCaptainTrackEnum> get values =>
      _$adminOrderDtoOutputOrderCaptainTrackEnumValues;
  static AdminOrderDtoOutputOrderCaptainTrackEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderCaptainTrackEnumValueOf(name);
}

class AdminOrderDtoOutputOrderAlertsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_not_accepted')
  static const AdminOrderDtoOutputOrderAlertsEnum restaurantNotAccepted =
      _$adminOrderDtoOutputOrderAlertsEnum_restaurantNotAccepted;
  @BuiltValueEnumConst(wireName: r'no_captain')
  static const AdminOrderDtoOutputOrderAlertsEnum noCaptain =
      _$adminOrderDtoOutputOrderAlertsEnum_noCaptain;
  @BuiltValueEnumConst(wireName: r'no_captain_after_ready')
  static const AdminOrderDtoOutputOrderAlertsEnum noCaptainAfterReady =
      _$adminOrderDtoOutputOrderAlertsEnum_noCaptainAfterReady;
  @BuiltValueEnumConst(wireName: r'captain_gps_lost')
  static const AdminOrderDtoOutputOrderAlertsEnum captainGpsLost =
      _$adminOrderDtoOutputOrderAlertsEnum_captainGpsLost;
  @BuiltValueEnumConst(wireName: r'pickup_disputed')
  static const AdminOrderDtoOutputOrderAlertsEnum pickupDisputed =
      _$adminOrderDtoOutputOrderAlertsEnum_pickupDisputed;
  @BuiltValueEnumConst(wireName: r'prep_late')
  static const AdminOrderDtoOutputOrderAlertsEnum prepLate =
      _$adminOrderDtoOutputOrderAlertsEnum_prepLate;
  @BuiltValueEnumConst(wireName: r'captain_waiting')
  static const AdminOrderDtoOutputOrderAlertsEnum captainWaiting =
      _$adminOrderDtoOutputOrderAlertsEnum_captainWaiting;
  @BuiltValueEnumConst(wireName: r'delivery_late')
  static const AdminOrderDtoOutputOrderAlertsEnum deliveryLate =
      _$adminOrderDtoOutputOrderAlertsEnum_deliveryLate;
  @BuiltValueEnumConst(wireName: r'collection_shortfall')
  static const AdminOrderDtoOutputOrderAlertsEnum collectionShortfall =
      _$adminOrderDtoOutputOrderAlertsEnum_collectionShortfall;
  @BuiltValueEnumConst(wireName: r'away_from_address')
  static const AdminOrderDtoOutputOrderAlertsEnum awayFromAddress =
      _$adminOrderDtoOutputOrderAlertsEnum_awayFromAddress;

  static Serializer<AdminOrderDtoOutputOrderAlertsEnum> get serializer =>
      _$adminOrderDtoOutputOrderAlertsEnumSerializer;

  const AdminOrderDtoOutputOrderAlertsEnum._(String name) : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderAlertsEnum> get values =>
      _$adminOrderDtoOutputOrderAlertsEnumValues;
  static AdminOrderDtoOutputOrderAlertsEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderAlertsEnumValueOf(name);
}
