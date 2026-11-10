//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_preparation.dart';
import 'package:core_api/src/model/captain_order_dto_output_order_pickup.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_collect.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_order_dto_output_order_customer.dart';
import 'package:core_api/src/model/captain_order_dto_output_order_outcome_to_collect.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_pickup_payment.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_lines_inner.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_restaurant.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_arrival.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_radii.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output_order.g.dart';

/// The active order (CA §9).
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status]
/// * [version] - Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown.
/// * [captainTrack] - The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم», picked_up «إلى الزبون», at_customer «عند الزبون».
/// * [restaurant]
/// * [preparation]
/// * [arrival]
/// * [itemReportOpen] - The restaurant reported an item unavailable (RA §8.12): the screen shows «بانتظار تعديل الطلب من العمليات» and the pickup request waits (409 item_report_open) until operations edit, cancel or close the report (CA §9 step 2).
/// * [editUnacknowledged] - Operations added items and the restaurant has not pressed «اطلعت على التعديل» (RA §8.13): the screen shows «بانتظار تأكيد المطعم للتعديل» and the pickup request waits (409 edit_unacknowledged) (CA §9 step 2).
/// * [outcomeToCollect]
/// * [itemCount]
/// * [lines] - The item check (C7): one tick box per line.
/// * [note] - The customer's note.
/// * [pickupPayment]
/// * [collect]
/// * [pickup]
/// * [customer]
/// * [radii]
@BuiltValue()
abstract class CaptainOrderDtoOutputOrder
    implements
        Built<CaptainOrderDtoOutputOrder, CaptainOrderDtoOutputOrderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  CaptainOrderDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown.
  @BuiltValueField(wireName: r'version')
  int get version;

  /// The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم», picked_up «إلى الزبون», at_customer «عند الزبون».
  @BuiltValueField(wireName: r'captainTrack')
  CaptainOrderDtoOutputOrderCaptainTrackEnum get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  @BuiltValueField(wireName: r'restaurant')
  CaptainActiveOrderDtoOutputOrderRestaurant get restaurant;

  @BuiltValueField(wireName: r'preparation')
  CaptainActiveOrderDtoOutputOrderPreparation get preparation;

  @BuiltValueField(wireName: r'arrival')
  CaptainActiveOrderDtoOutputOrderArrival? get arrival;

  /// The restaurant reported an item unavailable (RA §8.12): the screen shows «بانتظار تعديل الطلب من العمليات» and the pickup request waits (409 item_report_open) until operations edit, cancel or close the report (CA §9 step 2).
  @BuiltValueField(wireName: r'itemReportOpen')
  bool get itemReportOpen;

  /// Operations added items and the restaurant has not pressed «اطلعت على التعديل» (RA §8.13): the screen shows «بانتظار تأكيد المطعم للتعديل» and the pickup request waits (409 edit_unacknowledged) (CA §9 step 2).
  @BuiltValueField(wireName: r'editUnacknowledged')
  bool get editUnacknowledged;

  @BuiltValueField(wireName: r'outcomeToCollect')
  CaptainOrderDtoOutputOrderOutcomeToCollect? get outcomeToCollect;

  @BuiltValueField(wireName: r'itemCount')
  int get itemCount;

  /// The item check (C7): one tick box per line.
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainActiveOrderDtoOutputOrderLinesInner> get lines;

  /// The customer's note.
  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'pickupPayment')
  CaptainActiveOrderDtoOutputOrderPickupPayment get pickupPayment;

  @BuiltValueField(wireName: r'collect')
  CaptainActiveOrderDtoOutputOrderCollect get collect;

  @BuiltValueField(wireName: r'pickup')
  CaptainOrderDtoOutputOrderPickup get pickup;

  @BuiltValueField(wireName: r'customer')
  CaptainOrderDtoOutputOrderCustomer get customer;

  @BuiltValueField(wireName: r'radii')
  CaptainActiveOrderDtoOutputOrderRadii get radii;

  CaptainOrderDtoOutputOrder._();

  factory CaptainOrderDtoOutputOrder([
    void updates(CaptainOrderDtoOutputOrderBuilder b),
  ]) = _$CaptainOrderDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutputOrder> get serializer =>
      _$CaptainOrderDtoOutputOrderSerializer();
}

class _$CaptainOrderDtoOutputOrderSerializer
    implements PrimitiveSerializer<CaptainOrderDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderDtoOutputOrder,
    _$CaptainOrderDtoOutputOrder,
  ];

  @override
  final String wireName = r'CaptainOrderDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutputOrder object, {
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
      specifiedType: const FullType(CaptainOrderDtoOutputOrderStatusEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'captainTrack';
    yield serializers.serialize(
      object.captainTrack,
      specifiedType: const FullType(CaptainOrderDtoOutputOrderCaptainTrackEnum),
    );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderRestaurant),
    );
    yield r'preparation';
    yield serializers.serialize(
      object.preparation,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderPreparation,
      ),
    );
    yield r'arrival';
    yield object.arrival == null
        ? null
        : serializers.serialize(
            object.arrival,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputOrderArrival,
            ),
          );
    yield r'itemReportOpen';
    yield serializers.serialize(
      object.itemReportOpen,
      specifiedType: const FullType(bool),
    );
    yield r'editUnacknowledged';
    yield serializers.serialize(
      object.editUnacknowledged,
      specifiedType: const FullType(bool),
    );
    yield r'outcomeToCollect';
    yield object.outcomeToCollect == null
        ? null
        : serializers.serialize(
            object.outcomeToCollect,
            specifiedType: const FullType.nullable(
              CaptainOrderDtoOutputOrderOutcomeToCollect,
            ),
          );
    yield r'itemCount';
    yield serializers.serialize(
      object.itemCount,
      specifiedType: const FullType(int),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainActiveOrderDtoOutputOrderLinesInner),
      ]),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pickupPayment';
    yield serializers.serialize(
      object.pickupPayment,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderPickupPayment,
      ),
    );
    yield r'collect';
    yield serializers.serialize(
      object.collect,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderCollect),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(CaptainOrderDtoOutputOrderPickup),
    );
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(CaptainOrderDtoOutputOrderCustomer),
    );
    yield r'radii';
    yield serializers.serialize(
      object.radii,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderRadii),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrder object, {
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
    required CaptainOrderDtoOutputOrderBuilder result,
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
                      CaptainOrderDtoOutputOrderStatusEnum,
                    ),
                  )
                  as CaptainOrderDtoOutputOrderStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'captainTrack':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderDtoOutputOrderCaptainTrackEnum,
                    ),
                  )
                  as CaptainOrderDtoOutputOrderCaptainTrackEnum;
          result.captainTrack = valueDes;
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderRestaurant,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderRestaurant;
          result.restaurant.replace(valueDes);
          break;
        case r'preparation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderPreparation,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderPreparation;
          result.preparation.replace(valueDes);
          break;
        case r'arrival':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputOrderArrival,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderArrival?;
          if (valueDes == null) continue;
          result.arrival.replace(valueDes);
          break;
        case r'itemReportOpen':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.itemReportOpen = valueDes;
          break;
        case r'editUnacknowledged':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.editUnacknowledged = valueDes;
          break;
        case r'outcomeToCollect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainOrderDtoOutputOrderOutcomeToCollect,
                    ),
                  )
                  as CaptainOrderDtoOutputOrderOutcomeToCollect?;
          if (valueDes == null) continue;
          result.outcomeToCollect.replace(valueDes);
          break;
        case r'itemCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.itemCount = valueDes;
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainActiveOrderDtoOutputOrderLinesInner),
                    ]),
                  )
                  as BuiltList<CaptainActiveOrderDtoOutputOrderLinesInner>;
          result.lines.replace(valueDes);
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
        case r'pickupPayment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderPickupPayment,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderPickupPayment;
          result.pickupPayment.replace(valueDes);
          break;
        case r'collect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderCollect,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderCollect;
          result.collect.replace(valueDes);
          break;
        case r'pickup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderDtoOutputOrderPickup,
                    ),
                  )
                  as CaptainOrderDtoOutputOrderPickup;
          result.pickup.replace(valueDes);
          break;
        case r'customer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderDtoOutputOrderCustomer,
                    ),
                  )
                  as CaptainOrderDtoOutputOrderCustomer;
          result.customer.replace(valueDes);
          break;
        case r'radii':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderRadii,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderRadii;
          result.radii.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputOrderBuilder();
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

class CaptainOrderDtoOutputOrderStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CaptainOrderDtoOutputOrderStatusEnum placed =
      _$captainOrderDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainOrderDtoOutputOrderStatusEnum accepted =
      _$captainOrderDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CaptainOrderDtoOutputOrderStatusEnum ready =
      _$captainOrderDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CaptainOrderDtoOutputOrderStatusEnum pickedUp =
      _$captainOrderDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CaptainOrderDtoOutputOrderStatusEnum arrived =
      _$captainOrderDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CaptainOrderDtoOutputOrderStatusEnum delivered =
      _$captainOrderDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainOrderDtoOutputOrderStatusEnum rejected =
      _$captainOrderDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CaptainOrderDtoOutputOrderStatusEnum cancelled =
      _$captainOrderDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CaptainOrderDtoOutputOrderStatusEnum failed =
      _$captainOrderDtoOutputOrderStatusEnum_failed;

  static Serializer<CaptainOrderDtoOutputOrderStatusEnum> get serializer =>
      _$captainOrderDtoOutputOrderStatusEnumSerializer;

  const CaptainOrderDtoOutputOrderStatusEnum._(String name) : super(name);

  static BuiltSet<CaptainOrderDtoOutputOrderStatusEnum> get values =>
      _$captainOrderDtoOutputOrderStatusEnumValues;
  static CaptainOrderDtoOutputOrderStatusEnum valueOf(String name) =>
      _$captainOrderDtoOutputOrderStatusEnumValueOf(name);
}

/// The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم», picked_up «إلى الزبون», at_customer «عند الزبون».
class CaptainOrderDtoOutputOrderCaptainTrackEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'searching')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum searching =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum offered =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum assigned =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum atMerchant =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum pickupPending =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum pickedUp =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum atCustomer =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const CaptainOrderDtoOutputOrderCaptainTrackEnum done =
      _$captainOrderDtoOutputOrderCaptainTrackEnum_done;

  static Serializer<CaptainOrderDtoOutputOrderCaptainTrackEnum>
  get serializer => _$captainOrderDtoOutputOrderCaptainTrackEnumSerializer;

  const CaptainOrderDtoOutputOrderCaptainTrackEnum._(String name) : super(name);

  static BuiltSet<CaptainOrderDtoOutputOrderCaptainTrackEnum> get values =>
      _$captainOrderDtoOutputOrderCaptainTrackEnumValues;
  static CaptainOrderDtoOutputOrderCaptainTrackEnum valueOf(String name) =>
      _$captainOrderDtoOutputOrderCaptainTrackEnumValueOf(name);
}
