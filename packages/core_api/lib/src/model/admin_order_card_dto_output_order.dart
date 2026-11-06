//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_total.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_badges.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_moments.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_captain.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_restaurant.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_card_dto_output_order.g.dart';

/// AdminOrderCardDtoOutputOrder
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
/// * [alerts] - AP §9.1.3, §8.3, past their moment: «مطعم لم يقبل», «تحضير متأخر», «طلب بلا كابتن», no captain after ready, «كابتن ينتظر عند المطعم».
@BuiltValue()
abstract class AdminOrderCardDtoOutputOrder
    implements
        Built<
          AdminOrderCardDtoOutputOrder,
          AdminOrderCardDtoOutputOrderBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// The board column (AP §9.2.1).
  @BuiltValueField(wireName: r'status')
  AdminOrderCardDtoOutputOrderStatusEnum get status;
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
  AdminOrderCardDtoOutputOrderCaptainTrackEnum? get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  @BuiltValueField(wireName: r'captain')
  AdminOrderCardDtoOutputOrderCaptain? get captain;

  @BuiltValueField(wireName: r'total')
  AdminOrderCardDtoOutputOrderTotal get total;

  @BuiltValueField(wireName: r'badges')
  AdminOrderCardDtoOutputOrderBadges get badges;

  @BuiltValueField(wireName: r'moments')
  AdminOrderCardDtoOutputOrderMoments get moments;

  /// AP §9.1.3, §8.3, past their moment: «مطعم لم يقبل», «تحضير متأخر», «طلب بلا كابتن», no captain after ready, «كابتن ينتظر عند المطعم».
  @BuiltValueField(wireName: r'alerts')
  BuiltList<AdminOrderCardDtoOutputOrderAlertsEnum> get alerts;
  // enum alertsEnum {  restaurant_not_accepted,  prep_late,  no_captain,  no_captain_after_ready,  captain_waiting,  };

  AdminOrderCardDtoOutputOrder._();

  factory AdminOrderCardDtoOutputOrder([
    void updates(AdminOrderCardDtoOutputOrderBuilder b),
  ]) = _$AdminOrderCardDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCardDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCardDtoOutputOrder> get serializer =>
      _$AdminOrderCardDtoOutputOrderSerializer();
}

class _$AdminOrderCardDtoOutputOrderSerializer
    implements PrimitiveSerializer<AdminOrderCardDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCardDtoOutputOrder,
    _$AdminOrderCardDtoOutputOrder,
  ];

  @override
  final String wireName = r'AdminOrderCardDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCardDtoOutputOrder object, {
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
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderStatusEnum),
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
              AdminOrderCardDtoOutputOrderCaptainTrackEnum,
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
        FullType(AdminOrderCardDtoOutputOrderAlertsEnum),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrder object, {
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
    required AdminOrderCardDtoOutputOrderBuilder result,
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
                      AdminOrderCardDtoOutputOrderStatusEnum,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderStatusEnum;
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
                      AdminOrderCardDtoOutputOrderCaptainTrackEnum,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderCaptainTrackEnum?;
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
                      FullType(AdminOrderCardDtoOutputOrderAlertsEnum),
                    ]),
                  )
                  as BuiltList<AdminOrderCardDtoOutputOrderAlertsEnum>;
          result.alerts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCardDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCardDtoOutputOrderBuilder();
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
class AdminOrderCardDtoOutputOrderStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderCardDtoOutputOrderStatusEnum placed =
      _$adminOrderCardDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderCardDtoOutputOrderStatusEnum accepted =
      _$adminOrderCardDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderCardDtoOutputOrderStatusEnum ready =
      _$adminOrderCardDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderCardDtoOutputOrderStatusEnum pickedUp =
      _$adminOrderCardDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderCardDtoOutputOrderStatusEnum arrived =
      _$adminOrderCardDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderCardDtoOutputOrderStatusEnum delivered =
      _$adminOrderCardDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderCardDtoOutputOrderStatusEnum rejected =
      _$adminOrderCardDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderCardDtoOutputOrderStatusEnum cancelled =
      _$adminOrderCardDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderCardDtoOutputOrderStatusEnum failed =
      _$adminOrderCardDtoOutputOrderStatusEnum_failed;

  static Serializer<AdminOrderCardDtoOutputOrderStatusEnum> get serializer =>
      _$adminOrderCardDtoOutputOrderStatusEnumSerializer;

  const AdminOrderCardDtoOutputOrderStatusEnum._(String name) : super(name);

  static BuiltSet<AdminOrderCardDtoOutputOrderStatusEnum> get values =>
      _$adminOrderCardDtoOutputOrderStatusEnumValues;
  static AdminOrderCardDtoOutputOrderStatusEnum valueOf(String name) =>
      _$adminOrderCardDtoOutputOrderStatusEnumValueOf(name);
}

/// AP §8.2; null before the search starts and before any offer.
class AdminOrderCardDtoOutputOrderCaptainTrackEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'searching')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum searching =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum offered =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum assigned =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum atMerchant =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum pickupPending =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum pickedUp =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum atCustomer =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const AdminOrderCardDtoOutputOrderCaptainTrackEnum done =
      _$adminOrderCardDtoOutputOrderCaptainTrackEnum_done;

  static Serializer<AdminOrderCardDtoOutputOrderCaptainTrackEnum>
  get serializer => _$adminOrderCardDtoOutputOrderCaptainTrackEnumSerializer;

  const AdminOrderCardDtoOutputOrderCaptainTrackEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderCardDtoOutputOrderCaptainTrackEnum> get values =>
      _$adminOrderCardDtoOutputOrderCaptainTrackEnumValues;
  static AdminOrderCardDtoOutputOrderCaptainTrackEnum valueOf(String name) =>
      _$adminOrderCardDtoOutputOrderCaptainTrackEnumValueOf(name);
}

class AdminOrderCardDtoOutputOrderAlertsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_not_accepted')
  static const AdminOrderCardDtoOutputOrderAlertsEnum restaurantNotAccepted =
      _$adminOrderCardDtoOutputOrderAlertsEnum_restaurantNotAccepted;
  @BuiltValueEnumConst(wireName: r'prep_late')
  static const AdminOrderCardDtoOutputOrderAlertsEnum prepLate =
      _$adminOrderCardDtoOutputOrderAlertsEnum_prepLate;
  @BuiltValueEnumConst(wireName: r'no_captain')
  static const AdminOrderCardDtoOutputOrderAlertsEnum noCaptain =
      _$adminOrderCardDtoOutputOrderAlertsEnum_noCaptain;
  @BuiltValueEnumConst(wireName: r'no_captain_after_ready')
  static const AdminOrderCardDtoOutputOrderAlertsEnum noCaptainAfterReady =
      _$adminOrderCardDtoOutputOrderAlertsEnum_noCaptainAfterReady;
  @BuiltValueEnumConst(wireName: r'captain_waiting')
  static const AdminOrderCardDtoOutputOrderAlertsEnum captainWaiting =
      _$adminOrderCardDtoOutputOrderAlertsEnum_captainWaiting;

  static Serializer<AdminOrderCardDtoOutputOrderAlertsEnum> get serializer =>
      _$adminOrderCardDtoOutputOrderAlertsEnumSerializer;

  const AdminOrderCardDtoOutputOrderAlertsEnum._(String name) : super(name);

  static BuiltSet<AdminOrderCardDtoOutputOrderAlertsEnum> get values =>
      _$adminOrderCardDtoOutputOrderAlertsEnumValues;
  static AdminOrderCardDtoOutputOrderAlertsEnum valueOf(String name) =>
      _$adminOrderCardDtoOutputOrderAlertsEnumValueOf(name);
}
