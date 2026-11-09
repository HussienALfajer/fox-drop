//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_pickup_requests_inner_closed_by.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_pickup_requests_inner.g.dart';

/// AdminOrderDtoOutputOrderPickupRequestsInner
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [outcome] 
/// * [captainId] 
/// * [lines] - Paid by the captain.
/// * [bookedLines] - Booked at confirmation.
/// * [receivedLines] - What the restaurant says it received.
/// * [openedAt] 
/// * [closedAt] 
/// * [closedBy] 
@BuiltValue()
abstract class AdminOrderDtoOutputOrderPickupRequestsInner implements Built<AdminOrderDtoOutputOrderPickupRequestsInner, AdminOrderDtoOutputOrderPickupRequestsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum get status;
  // enum statusEnum {  open,  confirmed,  rejected,  voided,  };

  @BuiltValueField(wireName: r'outcome')
  AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum? get outcome;
  // enum outcomeEnum {  restaurant,  automatic,  operations,  amount_incorrect,  incomplete,  cancelled,  };

  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// Paid by the captain.
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get lines;

  /// Booked at confirmation.
  @BuiltValueField(wireName: r'bookedLines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?>? get bookedLines;

  /// What the restaurant says it received.
  @BuiltValueField(wireName: r'receivedLines')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? get receivedLines;

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closedBy')
  AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy? get closedBy;

  AdminOrderDtoOutputOrderPickupRequestsInner._();

  factory AdminOrderDtoOutputOrderPickupRequestsInner([void updates(AdminOrderDtoOutputOrderPickupRequestsInnerBuilder b)]) = _$AdminOrderDtoOutputOrderPickupRequestsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderPickupRequestsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderPickupRequestsInner> get serializer => _$AdminOrderDtoOutputOrderPickupRequestsInnerSerializer();
}

class _$AdminOrderDtoOutputOrderPickupRequestsInnerSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderPickupRequestsInner> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderPickupRequestsInner, _$AdminOrderDtoOutputOrderPickupRequestsInner];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderPickupRequestsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupRequestsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum),
    );
    yield r'outcome';
    yield object.outcome == null ? null : serializers.serialize(
      object.outcome,
      specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum),
    );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'bookedLines';
    yield object.bookedLines == null ? null : serializers.serialize(
      object.bookedLines,
      specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'receivedLines';
    yield object.receivedLines == null ? null : serializers.serialize(
      object.receivedLines,
      specifiedType: const FullType.nullable(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closedAt';
    yield object.closedAt == null ? null : serializers.serialize(
      object.closedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'closedBy';
    yield object.closedBy == null ? null : serializers.serialize(
      object.closedBy,
      specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderPickupRequestsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderPickupRequestsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum),
          ) as AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum),
          ) as AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'captainId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.captainId = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.lines.replace(valueDes);
          break;
        case r'bookedLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>?;
          if (valueDes == null) continue;
          result.bookedLines.replace(valueDes);
          break;
        case r'receivedLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>?;
          if (valueDes == null) continue;
          result.receivedLines.replace(valueDes);
          break;
        case r'openedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.openedAt = valueDes;
          break;
        case r'closedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'closedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy),
          ) as AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy?;
          if (valueDes == null) continue;
          result.closedBy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderPickupRequestsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderPickupRequestsInnerBuilder();
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


class AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'open')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum open = _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum confirmed = _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum rejected = _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'voided')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum voided = _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnum_voided;

  static Serializer<AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum> get serializer => _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnumSerializer;

  const AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum> get values => _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnumValues;
  static AdminOrderDtoOutputOrderPickupRequestsInnerStatusEnum valueOf(String name) => _$adminOrderDtoOutputOrderPickupRequestsInnerStatusEnumValueOf(name);
}

class AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum restaurant = _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum automatic = _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum operations = _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_operations;
  @BuiltValueEnumConst(wireName: r'amount_incorrect')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum amountIncorrect = _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_amountIncorrect;
  @BuiltValueEnumConst(wireName: r'incomplete')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum incomplete = _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_incomplete;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum cancelled = _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum_cancelled;

  static Serializer<AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum> get serializer => _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumSerializer;

  const AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum._(String name): super(name);

  static BuiltSet<AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum> get values => _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumValues;
  static AdminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnum valueOf(String name) => _$adminOrderDtoOutputOrderPickupRequestsInnerOutcomeEnumValueOf(name);
}

