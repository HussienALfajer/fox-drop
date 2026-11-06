//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_preparation.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_collect.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_pickup_payment.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_lines_inner.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_pickup.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_restaurant.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_arrival.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order.g.dart';

/// The active order (CA §9); the customer block joins with the delivery slice.
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status]
/// * [version] - Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown.
/// * [captainTrack] - The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم».
/// * [restaurant]
/// * [preparation]
/// * [arrival]
/// * [itemCount]
/// * [lines] - The item check (C7): one tick box per line.
/// * [note] - The customer's note.
/// * [pickupPayment]
/// * [collect]
/// * [pickup]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrder
    implements
        Built<
          CaptainActiveOrderDtoOutputOrder,
          CaptainActiveOrderDtoOutputOrderBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  CaptainActiveOrderDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown.
  @BuiltValueField(wireName: r'version')
  int get version;

  /// The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم».
  @BuiltValueField(wireName: r'captainTrack')
  CaptainActiveOrderDtoOutputOrderCaptainTrackEnum get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  @BuiltValueField(wireName: r'restaurant')
  CaptainActiveOrderDtoOutputOrderRestaurant get restaurant;

  @BuiltValueField(wireName: r'preparation')
  CaptainActiveOrderDtoOutputOrderPreparation get preparation;

  @BuiltValueField(wireName: r'arrival')
  CaptainActiveOrderDtoOutputOrderArrival? get arrival;

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
  CaptainActiveOrderDtoOutputOrderPickup get pickup;

  CaptainActiveOrderDtoOutputOrder._();

  factory CaptainActiveOrderDtoOutputOrder([
    void updates(CaptainActiveOrderDtoOutputOrderBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrder> get serializer =>
      _$CaptainActiveOrderDtoOutputOrderSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrder,
    _$CaptainActiveOrderDtoOutputOrder,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrder object, {
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
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderStatusEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'captainTrack';
    yield serializers.serialize(
      object.captainTrack,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderCaptainTrackEnum,
      ),
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
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderPickup),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrder object, {
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
    required CaptainActiveOrderDtoOutputOrderBuilder result,
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
                      CaptainActiveOrderDtoOutputOrderStatusEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderStatusEnum;
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
                      CaptainActiveOrderDtoOutputOrderCaptainTrackEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderCaptainTrackEnum;
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
                      CaptainActiveOrderDtoOutputOrderPickup,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderPickup;
          result.pickup.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderBuilder();
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

class CaptainActiveOrderDtoOutputOrderStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum placed =
      _$captainActiveOrderDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum accepted =
      _$captainActiveOrderDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum ready =
      _$captainActiveOrderDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum pickedUp =
      _$captainActiveOrderDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum arrived =
      _$captainActiveOrderDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum delivered =
      _$captainActiveOrderDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum rejected =
      _$captainActiveOrderDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum cancelled =
      _$captainActiveOrderDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CaptainActiveOrderDtoOutputOrderStatusEnum failed =
      _$captainActiveOrderDtoOutputOrderStatusEnum_failed;

  static Serializer<CaptainActiveOrderDtoOutputOrderStatusEnum>
  get serializer => _$captainActiveOrderDtoOutputOrderStatusEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderStatusEnum._(String name) : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderStatusEnum> get values =>
      _$captainActiveOrderDtoOutputOrderStatusEnumValues;
  static CaptainActiveOrderDtoOutputOrderStatusEnum valueOf(String name) =>
      _$captainActiveOrderDtoOutputOrderStatusEnumValueOf(name);
}

/// The step (CA §9.1): assigned «إلى المطعم», at_merchant and pickup_pending «عند المطعم».
class CaptainActiveOrderDtoOutputOrderCaptainTrackEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'searching')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum searching =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum offered =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum assigned =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum atMerchant =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum pickupPending =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum pickedUp =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum atCustomer =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum done =
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnum_done;

  static Serializer<CaptainActiveOrderDtoOutputOrderCaptainTrackEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderCaptainTrackEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderCaptainTrackEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderCaptainTrackEnum>
  get values => _$captainActiveOrderDtoOutputOrderCaptainTrackEnumValues;
  static CaptainActiveOrderDtoOutputOrderCaptainTrackEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderCaptainTrackEnumValueOf(name);
}
