//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_acceptance.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_order_dto_output_order_pickup.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_captain.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_lines_inner.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_customer.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_captain_arrival.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_dto_output_order.g.dart';

/// MerchantOrderDtoOutputOrder
///
/// Properties:
/// * [id] 
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status] - AP §8.1; the board column (RA §8.1–8.2).
/// * [version] - Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
/// * [placedAt] 
/// * [acceptAlertAt] - While placed from then: the card turns red and the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات» (RA §8.2–8.3).
/// * [autoCancelAt] - «يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).
/// * [acceptance] 
/// * [readyAt] - «الطلب جاهز» (RA §8.8).
/// * [customer] 
/// * [note] - The customer's note.
/// * [lines] 
/// * [currency] 
/// * [itemsValue] - «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).
/// * [captainTrack] - The captain line (RA §8.1): searching or offered «بانتظار كابتن», assigned «الكابتن {الاسم} في الطريق»; null before the search starts.
/// * [captain] 
/// * [captainArrival] 
/// * [pickup] 
@BuiltValue()
abstract class MerchantOrderDtoOutputOrder implements Built<MerchantOrderDtoOutputOrder, MerchantOrderDtoOutputOrderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// AP §8.1; the board column (RA §8.1–8.2).
  @BuiltValueField(wireName: r'status')
  MerchantOrderDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  /// While placed from then: the card turns red and the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات» (RA §8.2–8.3).
  @BuiltValueField(wireName: r'acceptAlertAt')
  DateTime? get acceptAlertAt;

  /// «يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).
  @BuiltValueField(wireName: r'autoCancelAt')
  DateTime? get autoCancelAt;

  @BuiltValueField(wireName: r'acceptance')
  MerchantOrdersDtoOutputOrdersInnerAcceptance? get acceptance;

  /// «الطلب جاهز» (RA §8.8).
  @BuiltValueField(wireName: r'readyAt')
  DateTime? get readyAt;

  @BuiltValueField(wireName: r'customer')
  MerchantOrdersDtoOutputOrdersInnerCustomer get customer;

  /// The customer's note.
  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'lines')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInner> get lines;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// «قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// The captain line (RA §8.1): searching or offered «بانتظار كابتن», assigned «الكابتن {الاسم} في الطريق»; null before the search starts.
  @BuiltValueField(wireName: r'captainTrack')
  MerchantOrderDtoOutputOrderCaptainTrackEnum? get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  @BuiltValueField(wireName: r'captain')
  MerchantOrdersDtoOutputOrdersInnerCaptain? get captain;

  @BuiltValueField(wireName: r'captainArrival')
  MerchantOrdersDtoOutputOrdersInnerCaptainArrival? get captainArrival;

  @BuiltValueField(wireName: r'pickup')
  MerchantOrderDtoOutputOrderPickup get pickup;

  MerchantOrderDtoOutputOrder._();

  factory MerchantOrderDtoOutputOrder([void updates(MerchantOrderDtoOutputOrderBuilder b)]) = _$MerchantOrderDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderDtoOutputOrder> get serializer => _$MerchantOrderDtoOutputOrderSerializer();
}

class _$MerchantOrderDtoOutputOrderSerializer implements PrimitiveSerializer<MerchantOrderDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [MerchantOrderDtoOutputOrder, _$MerchantOrderDtoOutputOrder];

  @override
  final String wireName = r'MerchantOrderDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderDtoOutputOrder object, {
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
      specifiedType: const FullType(MerchantOrderDtoOutputOrderStatusEnum),
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
    yield r'acceptAlertAt';
    yield object.acceptAlertAt == null ? null : serializers.serialize(
      object.acceptAlertAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'autoCancelAt';
    yield object.autoCancelAt == null ? null : serializers.serialize(
      object.autoCancelAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'acceptance';
    yield object.acceptance == null ? null : serializers.serialize(
      object.acceptance,
      specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerAcceptance),
    );
    yield r'readyAt';
    yield object.readyAt == null ? null : serializers.serialize(
      object.readyAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerCustomer),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(MerchantOrdersDtoOutputOrdersInnerLinesInner)]),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'captainTrack';
    yield object.captainTrack == null ? null : serializers.serialize(
      object.captainTrack,
      specifiedType: const FullType.nullable(MerchantOrderDtoOutputOrderCaptainTrackEnum),
    );
    yield r'captain';
    yield object.captain == null ? null : serializers.serialize(
      object.captain,
      specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerCaptain),
    );
    yield r'captainArrival';
    yield object.captainArrival == null ? null : serializers.serialize(
      object.captainArrival,
      specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerCaptainArrival),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(MerchantOrderDtoOutputOrderPickup),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderDtoOutputOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantOrderDtoOutputOrderBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantOrderDtoOutputOrderStatusEnum),
          ) as MerchantOrderDtoOutputOrderStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'placedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.placedAt = valueDes;
          break;
        case r'acceptAlertAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptAlertAt = valueDes;
          break;
        case r'autoCancelAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.autoCancelAt = valueDes;
          break;
        case r'acceptance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerAcceptance),
          ) as MerchantOrdersDtoOutputOrdersInnerAcceptance?;
          if (valueDes == null) continue;
          result.acceptance.replace(valueDes);
          break;
        case r'readyAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readyAt = valueDes;
          break;
        case r'customer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerCustomer),
          ) as MerchantOrdersDtoOutputOrdersInnerCustomer;
          result.customer.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantOrdersDtoOutputOrdersInnerLinesInner)]),
          ) as BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        case r'itemsValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.itemsValue = valueDes;
          break;
        case r'captainTrack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantOrderDtoOutputOrderCaptainTrackEnum),
          ) as MerchantOrderDtoOutputOrderCaptainTrackEnum?;
          if (valueDes == null) continue;
          result.captainTrack = valueDes;
          break;
        case r'captain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerCaptain),
          ) as MerchantOrdersDtoOutputOrdersInnerCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
          break;
        case r'captainArrival':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerCaptainArrival),
          ) as MerchantOrdersDtoOutputOrdersInnerCaptainArrival?;
          if (valueDes == null) continue;
          result.captainArrival.replace(valueDes);
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantOrderDtoOutputOrderPickup),
          ) as MerchantOrderDtoOutputOrderPickup;
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
  MerchantOrderDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderDtoOutputOrderBuilder();
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


/// AP §8.1; the board column (RA §8.1–8.2).
class MerchantOrderDtoOutputOrderStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'placed')
  static const MerchantOrderDtoOutputOrderStatusEnum placed = _$merchantOrderDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const MerchantOrderDtoOutputOrderStatusEnum accepted = _$merchantOrderDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const MerchantOrderDtoOutputOrderStatusEnum ready = _$merchantOrderDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const MerchantOrderDtoOutputOrderStatusEnum pickedUp = _$merchantOrderDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const MerchantOrderDtoOutputOrderStatusEnum arrived = _$merchantOrderDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const MerchantOrderDtoOutputOrderStatusEnum delivered = _$merchantOrderDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrderDtoOutputOrderStatusEnum rejected = _$merchantOrderDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrderDtoOutputOrderStatusEnum cancelled = _$merchantOrderDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const MerchantOrderDtoOutputOrderStatusEnum failed = _$merchantOrderDtoOutputOrderStatusEnum_failed;

  static Serializer<MerchantOrderDtoOutputOrderStatusEnum> get serializer => _$merchantOrderDtoOutputOrderStatusEnumSerializer;

  const MerchantOrderDtoOutputOrderStatusEnum._(String name): super(name);

  static BuiltSet<MerchantOrderDtoOutputOrderStatusEnum> get values => _$merchantOrderDtoOutputOrderStatusEnumValues;
  static MerchantOrderDtoOutputOrderStatusEnum valueOf(String name) => _$merchantOrderDtoOutputOrderStatusEnumValueOf(name);
}

/// The captain line (RA §8.1): searching or offered «بانتظار كابتن», assigned «الكابتن {الاسم} في الطريق»; null before the search starts.
class MerchantOrderDtoOutputOrderCaptainTrackEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'searching')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum searching = _$merchantOrderDtoOutputOrderCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum offered = _$merchantOrderDtoOutputOrderCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum assigned = _$merchantOrderDtoOutputOrderCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum atMerchant = _$merchantOrderDtoOutputOrderCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum pickupPending = _$merchantOrderDtoOutputOrderCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum pickedUp = _$merchantOrderDtoOutputOrderCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum atCustomer = _$merchantOrderDtoOutputOrderCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const MerchantOrderDtoOutputOrderCaptainTrackEnum done = _$merchantOrderDtoOutputOrderCaptainTrackEnum_done;

  static Serializer<MerchantOrderDtoOutputOrderCaptainTrackEnum> get serializer => _$merchantOrderDtoOutputOrderCaptainTrackEnumSerializer;

  const MerchantOrderDtoOutputOrderCaptainTrackEnum._(String name): super(name);

  static BuiltSet<MerchantOrderDtoOutputOrderCaptainTrackEnum> get values => _$merchantOrderDtoOutputOrderCaptainTrackEnumValues;
  static MerchantOrderDtoOutputOrderCaptainTrackEnum valueOf(String name) => _$merchantOrderDtoOutputOrderCaptainTrackEnumValueOf(name);
}

