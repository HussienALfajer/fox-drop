//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_dispatch_state_dto_output_order_offer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dispatch_state_dto_output_order.g.dart';

/// AdminDispatchStateDtoOutputOrder
///
/// Properties:
/// * [id] 
/// * [number] 
/// * [status] 
/// * [version] 
/// * [captainTrack] - AP §8.2; searching is «بحاجة لتعيين» in manual mode.
/// * [captainId] - From assignment.
/// * [offer] 
@BuiltValue()
abstract class AdminDispatchStateDtoOutputOrder implements Built<AdminDispatchStateDtoOutputOrder, AdminDispatchStateDtoOutputOrderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  AdminDispatchStateDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'version')
  int get version;

  /// AP §8.2; searching is «بحاجة لتعيين» in manual mode.
  @BuiltValueField(wireName: r'captainTrack')
  AdminDispatchStateDtoOutputOrderCaptainTrackEnum? get captainTrack;
  // enum captainTrackEnum {  searching,  offered,  assigned,  at_merchant,  pickup_pending,  picked_up,  at_customer,  done,  };

  /// From assignment.
  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  @BuiltValueField(wireName: r'offer')
  AdminDispatchStateDtoOutputOrderOffer? get offer;

  AdminDispatchStateDtoOutputOrder._();

  factory AdminDispatchStateDtoOutputOrder([void updates(AdminDispatchStateDtoOutputOrderBuilder b)]) = _$AdminDispatchStateDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDispatchStateDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDispatchStateDtoOutputOrder> get serializer => _$AdminDispatchStateDtoOutputOrderSerializer();
}

class _$AdminDispatchStateDtoOutputOrderSerializer implements PrimitiveSerializer<AdminDispatchStateDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [AdminDispatchStateDtoOutputOrder, _$AdminDispatchStateDtoOutputOrder];

  @override
  final String wireName = r'AdminDispatchStateDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDispatchStateDtoOutputOrder object, {
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
      specifiedType: const FullType(AdminDispatchStateDtoOutputOrderStatusEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'captainTrack';
    yield object.captainTrack == null ? null : serializers.serialize(
      object.captainTrack,
      specifiedType: const FullType.nullable(AdminDispatchStateDtoOutputOrderCaptainTrackEnum),
    );
    yield r'captainId';
    yield object.captainId == null ? null : serializers.serialize(
      object.captainId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'offer';
    yield object.offer == null ? null : serializers.serialize(
      object.offer,
      specifiedType: const FullType.nullable(AdminDispatchStateDtoOutputOrderOffer),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDispatchStateDtoOutputOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDispatchStateDtoOutputOrderBuilder result,
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
            specifiedType: const FullType(AdminDispatchStateDtoOutputOrderStatusEnum),
          ) as AdminDispatchStateDtoOutputOrderStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'captainTrack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminDispatchStateDtoOutputOrderCaptainTrackEnum),
          ) as AdminDispatchStateDtoOutputOrderCaptainTrackEnum?;
          if (valueDes == null) continue;
          result.captainTrack = valueDes;
          break;
        case r'captainId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.captainId = valueDes;
          break;
        case r'offer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminDispatchStateDtoOutputOrderOffer),
          ) as AdminDispatchStateDtoOutputOrderOffer?;
          if (valueDes == null) continue;
          result.offer.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDispatchStateDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDispatchStateDtoOutputOrderBuilder();
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


class AdminDispatchStateDtoOutputOrderStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminDispatchStateDtoOutputOrderStatusEnum placed = _$adminDispatchStateDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminDispatchStateDtoOutputOrderStatusEnum accepted = _$adminDispatchStateDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminDispatchStateDtoOutputOrderStatusEnum ready = _$adminDispatchStateDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminDispatchStateDtoOutputOrderStatusEnum pickedUp = _$adminDispatchStateDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminDispatchStateDtoOutputOrderStatusEnum arrived = _$adminDispatchStateDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminDispatchStateDtoOutputOrderStatusEnum delivered = _$adminDispatchStateDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminDispatchStateDtoOutputOrderStatusEnum rejected = _$adminDispatchStateDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminDispatchStateDtoOutputOrderStatusEnum cancelled = _$adminDispatchStateDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminDispatchStateDtoOutputOrderStatusEnum failed = _$adminDispatchStateDtoOutputOrderStatusEnum_failed;

  static Serializer<AdminDispatchStateDtoOutputOrderStatusEnum> get serializer => _$adminDispatchStateDtoOutputOrderStatusEnumSerializer;

  const AdminDispatchStateDtoOutputOrderStatusEnum._(String name): super(name);

  static BuiltSet<AdminDispatchStateDtoOutputOrderStatusEnum> get values => _$adminDispatchStateDtoOutputOrderStatusEnumValues;
  static AdminDispatchStateDtoOutputOrderStatusEnum valueOf(String name) => _$adminDispatchStateDtoOutputOrderStatusEnumValueOf(name);
}

/// AP §8.2; searching is «بحاجة لتعيين» in manual mode.
class AdminDispatchStateDtoOutputOrderCaptainTrackEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'searching')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum searching = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_searching;
  @BuiltValueEnumConst(wireName: r'offered')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum offered = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_offered;
  @BuiltValueEnumConst(wireName: r'assigned')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum assigned = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_assigned;
  @BuiltValueEnumConst(wireName: r'at_merchant')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum atMerchant = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_atMerchant;
  @BuiltValueEnumConst(wireName: r'pickup_pending')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum pickupPending = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_pickupPending;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum pickedUp = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'at_customer')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum atCustomer = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_atCustomer;
  @BuiltValueEnumConst(wireName: r'done')
  static const AdminDispatchStateDtoOutputOrderCaptainTrackEnum done = _$adminDispatchStateDtoOutputOrderCaptainTrackEnum_done;

  static Serializer<AdminDispatchStateDtoOutputOrderCaptainTrackEnum> get serializer => _$adminDispatchStateDtoOutputOrderCaptainTrackEnumSerializer;

  const AdminDispatchStateDtoOutputOrderCaptainTrackEnum._(String name): super(name);

  static BuiltSet<AdminDispatchStateDtoOutputOrderCaptainTrackEnum> get values => _$adminDispatchStateDtoOutputOrderCaptainTrackEnumValues;
  static AdminDispatchStateDtoOutputOrderCaptainTrackEnum valueOf(String name) => _$adminDispatchStateDtoOutputOrderCaptainTrackEnumValueOf(name);
}

