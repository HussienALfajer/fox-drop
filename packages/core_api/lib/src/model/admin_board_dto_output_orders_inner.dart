//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_total.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_badges.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_moments.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_captain.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_dispatch.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_board_dto_output_orders_inner.g.dart';

/// AdminBoardDtoOutputOrdersInner
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
/// * [dispatch]
/// * [badges]
/// * [moments]
/// * [alerts] - AP §9.1.3, open now by their conditions (GET /v1/admin/alerts holds the records, with who took each); «تسليم بعيد عن العنوان» only while the order is active.
@BuiltValue()
abstract class AdminBoardDtoOutputOrdersInner
    implements
        Built<
          AdminBoardDtoOutputOrdersInner,
          AdminBoardDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// The board column (AP §9.2.1).
  @BuiltValueField(wireName: r'status')
  AdminBoardDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3).
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  @BuiltValueField(wireName: r'restaurant')
  CaptainPeakBonusDtoOutputWindowsInnerZonesInner get restaurant;

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
  AdminBoardDtoOutputOrdersInnerCaptainTrackEnum? get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  @BuiltValueField(wireName: r'captain')
  AdminOrderCardDtoOutputOrderCaptain? get captain;

  @BuiltValueField(wireName: r'total')
  AdminOrderCardDtoOutputOrderTotal get total;

  @BuiltValueField(wireName: r'dispatch')
  AdminOrderCardDtoOutputOrderDispatch get dispatch;

  @BuiltValueField(wireName: r'badges')
  AdminOrderCardDtoOutputOrderBadges get badges;

  @BuiltValueField(wireName: r'moments')
  AdminOrderCardDtoOutputOrderMoments get moments;

  /// AP §9.1.3, open now by their conditions (GET /v1/admin/alerts holds the records, with who took each); «تسليم بعيد عن العنوان» only while the order is active.
  @BuiltValueField(wireName: r'alerts')
  BuiltList<AdminBoardDtoOutputOrdersInnerAlertsEnum> get alerts;
  // enum alertsEnum {  restaurant_not_accepted,  no_captain,  no_captain_after_ready,  captain_gps_lost,  pickup_disputed,  prep_late,  captain_waiting,  delivery_late,  collection_shortfall,  away_from_address,  item_unavailable,  edit_unacknowledged,  captain_cannot_complete,  captain_emergency,  customer_not_answering,  };

  AdminBoardDtoOutputOrdersInner._();

  factory AdminBoardDtoOutputOrdersInner([
    void updates(AdminBoardDtoOutputOrdersInnerBuilder b),
  ]) = _$AdminBoardDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBoardDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBoardDtoOutputOrdersInner> get serializer =>
      _$AdminBoardDtoOutputOrdersInnerSerializer();
}

class _$AdminBoardDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<AdminBoardDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    AdminBoardDtoOutputOrdersInner,
    _$AdminBoardDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'AdminBoardDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInner object, {
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
      specifiedType: const FullType(AdminBoardDtoOutputOrdersInnerStatusEnum),
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
      specifiedType: const FullType(
        CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
      ),
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
              AdminBoardDtoOutputOrdersInnerCaptainTrackEnum,
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
    yield r'dispatch';
    yield serializers.serialize(
      object.dispatch,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrderDispatch),
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
        FullType(AdminBoardDtoOutputOrdersInnerAlertsEnum),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInner object, {
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
    required AdminBoardDtoOutputOrdersInnerBuilder result,
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
                      AdminBoardDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerStatusEnum;
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
                      CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
                    ),
                  )
                  as CaptainPeakBonusDtoOutputWindowsInnerZonesInner;
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
                      AdminBoardDtoOutputOrdersInnerCaptainTrackEnum,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerCaptainTrackEnum?;
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
        case r'dispatch':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderDispatch,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderDispatch;
          result.dispatch.replace(valueDes);
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
                      FullType(AdminBoardDtoOutputOrdersInnerAlertsEnum),
                    ]),
                  )
                  as BuiltList<AdminBoardDtoOutputOrdersInnerAlertsEnum>;
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
  AdminBoardDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBoardDtoOutputOrdersInnerBuilder();
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
class AdminBoardDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum placed =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum accepted =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum ready =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum pickedUp =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum arrived =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum delivered =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum rejected =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum cancelled =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminBoardDtoOutputOrdersInnerStatusEnum failed =
      _$adminBoardDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<AdminBoardDtoOutputOrdersInnerStatusEnum> get serializer =>
      _$adminBoardDtoOutputOrdersInnerStatusEnumSerializer;

  const AdminBoardDtoOutputOrdersInnerStatusEnum._(String name) : super(name);

  static BuiltSet<AdminBoardDtoOutputOrdersInnerStatusEnum> get values =>
      _$adminBoardDtoOutputOrdersInnerStatusEnumValues;
  static AdminBoardDtoOutputOrdersInnerStatusEnum valueOf(String name) =>
      _$adminBoardDtoOutputOrdersInnerStatusEnumValueOf(name);
}

/// AP §8.2; null before the search starts and before any offer.
class AdminBoardDtoOutputOrdersInnerCaptainTrackEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'searching')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum searching =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum offered =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum assigned =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum atMerchant =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum pickupPending =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum pickedUp =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum atCustomer =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum done =
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnum_done;

  static Serializer<AdminBoardDtoOutputOrdersInnerCaptainTrackEnum>
  get serializer => _$adminBoardDtoOutputOrdersInnerCaptainTrackEnumSerializer;

  const AdminBoardDtoOutputOrdersInnerCaptainTrackEnum._(String name)
    : super(name);

  static BuiltSet<AdminBoardDtoOutputOrdersInnerCaptainTrackEnum> get values =>
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnumValues;
  static AdminBoardDtoOutputOrdersInnerCaptainTrackEnum valueOf(String name) =>
      _$adminBoardDtoOutputOrdersInnerCaptainTrackEnumValueOf(name);
}

class AdminBoardDtoOutputOrdersInnerAlertsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant_not_accepted')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum restaurantNotAccepted =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_restaurantNotAccepted;
  @BuiltValueEnumConst(wireName: r'no_captain')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum noCaptain =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_noCaptain;
  @BuiltValueEnumConst(wireName: r'no_captain_after_ready')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum noCaptainAfterReady =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_noCaptainAfterReady;
  @BuiltValueEnumConst(wireName: r'captain_gps_lost')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum captainGpsLost =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_captainGpsLost;
  @BuiltValueEnumConst(wireName: r'pickup_disputed')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum pickupDisputed =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_pickupDisputed;
  @BuiltValueEnumConst(wireName: r'prep_late')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum prepLate =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_prepLate;
  @BuiltValueEnumConst(wireName: r'captain_waiting')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum captainWaiting =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_captainWaiting;
  @BuiltValueEnumConst(wireName: r'delivery_late')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum deliveryLate =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_deliveryLate;
  @BuiltValueEnumConst(wireName: r'collection_shortfall')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum collectionShortfall =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_collectionShortfall;
  @BuiltValueEnumConst(wireName: r'away_from_address')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum awayFromAddress =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_awayFromAddress;
  @BuiltValueEnumConst(wireName: r'item_unavailable')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum itemUnavailable =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_itemUnavailable;
  @BuiltValueEnumConst(wireName: r'edit_unacknowledged')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum editUnacknowledged =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_editUnacknowledged;
  @BuiltValueEnumConst(wireName: r'captain_cannot_complete')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum captainCannotComplete =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_captainCannotComplete;
  @BuiltValueEnumConst(wireName: r'captain_emergency')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum captainEmergency =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_captainEmergency;
  @BuiltValueEnumConst(wireName: r'customer_not_answering')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum customerNotAnswering =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_customerNotAnswering;

  static Serializer<AdminBoardDtoOutputOrdersInnerAlertsEnum> get serializer =>
      _$adminBoardDtoOutputOrdersInnerAlertsEnumSerializer;

  const AdminBoardDtoOutputOrdersInnerAlertsEnum._(String name) : super(name);

  static BuiltSet<AdminBoardDtoOutputOrdersInnerAlertsEnum> get values =>
      _$adminBoardDtoOutputOrdersInnerAlertsEnumValues;
  static AdminBoardDtoOutputOrdersInnerAlertsEnum valueOf(String name) =>
      _$adminBoardDtoOutputOrdersInnerAlertsEnumValueOf(name);
}
