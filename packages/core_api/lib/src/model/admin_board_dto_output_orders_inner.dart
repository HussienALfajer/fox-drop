//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_board_dto_output_orders_inner_moments.dart';
import 'package:core_api/src/model/admin_board_dto_output_orders_inner_badges.dart';
import 'package:core_api/src/model/admin_board_dto_output_orders_inner_restaurant.dart';
import 'package:core_api/src/model/admin_board_dto_output_orders_inner_captain.dart';
import 'package:core_api/src/model/admin_board_dto_output_orders_inner_total.dart';
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
/// * [badges]
/// * [moments]
/// * [alerts] - AP §9.1.3, §8.3, past their moment: «مطعم لم يقبل», «تحضير متأخر», «طلب بلا كابتن», no captain after ready.
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
  AdminBoardDtoOutputOrdersInnerRestaurant get restaurant;

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
  AdminBoardDtoOutputOrdersInnerCaptain? get captain;

  @BuiltValueField(wireName: r'total')
  AdminBoardDtoOutputOrdersInnerTotal get total;

  @BuiltValueField(wireName: r'badges')
  AdminBoardDtoOutputOrdersInnerBadges get badges;

  @BuiltValueField(wireName: r'moments')
  AdminBoardDtoOutputOrdersInnerMoments get moments;

  /// AP §9.1.3, §8.3, past their moment: «مطعم لم يقبل», «تحضير متأخر», «طلب بلا كابتن», no captain after ready.
  @BuiltValueField(wireName: r'alerts')
  BuiltList<AdminBoardDtoOutputOrdersInnerAlertsEnum> get alerts;
  // enum alertsEnum {  restaurant_not_accepted,  prep_late,  no_captain,  no_captain_after_ready,  };

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
      specifiedType: const FullType(AdminBoardDtoOutputOrdersInnerRestaurant),
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
              AdminBoardDtoOutputOrdersInnerCaptain,
            ),
          );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(AdminBoardDtoOutputOrdersInnerTotal),
    );
    yield r'badges';
    yield serializers.serialize(
      object.badges,
      specifiedType: const FullType(AdminBoardDtoOutputOrdersInnerBadges),
    );
    yield r'moments';
    yield serializers.serialize(
      object.moments,
      specifiedType: const FullType(AdminBoardDtoOutputOrdersInnerMoments),
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
                      AdminBoardDtoOutputOrdersInnerRestaurant,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerRestaurant;
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
                      AdminBoardDtoOutputOrdersInnerCaptain,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminBoardDtoOutputOrdersInnerTotal,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerTotal;
          result.total.replace(valueDes);
          break;
        case r'badges':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminBoardDtoOutputOrdersInnerBadges,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerBadges;
          result.badges.replace(valueDes);
          break;
        case r'moments':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminBoardDtoOutputOrdersInnerMoments,
                    ),
                  )
                  as AdminBoardDtoOutputOrdersInnerMoments;
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
  @BuiltValueEnumConst(wireName: r'prep_late')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum prepLate =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_prepLate;
  @BuiltValueEnumConst(wireName: r'no_captain')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum noCaptain =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_noCaptain;
  @BuiltValueEnumConst(wireName: r'no_captain_after_ready')
  static const AdminBoardDtoOutputOrdersInnerAlertsEnum noCaptainAfterReady =
      _$adminBoardDtoOutputOrdersInnerAlertsEnum_noCaptainAfterReady;

  static Serializer<AdminBoardDtoOutputOrdersInnerAlertsEnum> get serializer =>
      _$adminBoardDtoOutputOrdersInnerAlertsEnumSerializer;

  const AdminBoardDtoOutputOrdersInnerAlertsEnum._(String name) : super(name);

  static BuiltSet<AdminBoardDtoOutputOrdersInnerAlertsEnum> get values =>
      _$adminBoardDtoOutputOrdersInnerAlertsEnumValues;
  static AdminBoardDtoOutputOrdersInnerAlertsEnum valueOf(String name) =>
      _$adminBoardDtoOutputOrdersInnerAlertsEnumValueOf(name);
}
