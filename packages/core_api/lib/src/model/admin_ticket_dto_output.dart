//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_closure.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_sla.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_dto_output.g.dart';

/// AdminTicketDtoOutput
///
/// Properties:
/// * [id]
/// * [number] - Shown as `T-{number}` (AP §4.8).
/// * [source_] - Where the ticket came from (AP §9.9.1): manual, pickup_dispute, customer_report, price_report, merchant_report, order_problem, captain_report, captain_problem, captain_appeal so far.
/// * [party]
/// * [partyId]
/// * [partyName]
/// * [orderId]
/// * [orderNumber]
/// * [urgent] - «عاجلة»: open, on an order still active, or a pickup dispute while open.
/// * [kind] - Which resolutions it takes (AP §9.9.3): general, price_difference, pickup_dispute.
/// * [restaurantId] - «سعر مختلف عن المحل»: the restaurant.
/// * [restaurantName]
/// * [typeCode]
/// * [typeLabel]
/// * [description]
/// * [status]
/// * [assigneeId]
/// * [assigneeName]
/// * [sla]
/// * [openedByName]
/// * [openedAt]
/// * [updatedAt]
/// * [resolution]
/// * [closure]
@BuiltValue()
abstract class AdminTicketDtoOutput
    implements Built<AdminTicketDtoOutput, AdminTicketDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as `T-{number}` (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// Where the ticket came from (AP §9.9.1): manual, pickup_dispute, customer_report, price_report, merchant_report, order_problem, captain_report, captain_problem, captain_appeal so far.
  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'party')
  AdminTicketDtoOutputPartyEnum get party;
  // enum partyEnum {  customer,  restaurant,  captain,  };

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'partyName')
  String get partyName;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// «عاجلة»: open, on an order still active, or a pickup dispute while open.
  @BuiltValueField(wireName: r'urgent')
  bool get urgent;

  /// Which resolutions it takes (AP §9.9.3): general, price_difference, pickup_dispute.
  @BuiltValueField(wireName: r'kind')
  AdminTicketDtoOutputKindEnum get kind;
  // enum kindEnum {  general,  price_difference,  pickup_dispute,  appeal,  };

  /// «سعر مختلف عن المحل»: the restaurant.
  @BuiltValueField(wireName: r'restaurantId')
  String? get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String? get restaurantName;

  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  @BuiltValueField(wireName: r'typeLabel')
  String get typeLabel;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'status')
  AdminTicketDtoOutputStatusEnum get status;
  // enum statusEnum {  new,  in_progress,  waiting,  resolved,  closed,  };

  @BuiltValueField(wireName: r'assigneeId')
  String? get assigneeId;

  @BuiltValueField(wireName: r'assigneeName')
  String? get assigneeName;

  @BuiltValueField(wireName: r'sla')
  AdminOrderTicketsDtoOutputTicketsInnerSla get sla;

  @BuiltValueField(wireName: r'openedByName')
  String? get openedByName;

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'resolution')
  AdminOrderTicketsDtoOutputTicketsInnerResolution? get resolution;

  @BuiltValueField(wireName: r'closure')
  AdminOrderTicketsDtoOutputTicketsInnerClosure? get closure;

  AdminTicketDtoOutput._();

  factory AdminTicketDtoOutput([void updates(AdminTicketDtoOutputBuilder b)]) =
      _$AdminTicketDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketDtoOutput> get serializer =>
      _$AdminTicketDtoOutputSerializer();
}

class _$AdminTicketDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketDtoOutput,
    _$AdminTicketDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketDtoOutput object, {
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
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(AdminTicketDtoOutputPartyEnum),
    );
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    yield r'partyName';
    yield serializers.serialize(
      object.partyName,
      specifiedType: const FullType(String),
    );
    yield r'orderId';
    yield object.orderId == null
        ? null
        : serializers.serialize(
            object.orderId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'orderNumber';
    yield object.orderNumber == null
        ? null
        : serializers.serialize(
            object.orderNumber,
            specifiedType: const FullType.nullable(String),
          );
    yield r'urgent';
    yield serializers.serialize(
      object.urgent,
      specifiedType: const FullType(bool),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminTicketDtoOutputKindEnum),
    );
    yield r'restaurantId';
    yield object.restaurantId == null
        ? null
        : serializers.serialize(
            object.restaurantId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurantName';
    yield object.restaurantName == null
        ? null
        : serializers.serialize(
            object.restaurantName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'typeCode';
    yield serializers.serialize(
      object.typeCode,
      specifiedType: const FullType(String),
    );
    yield r'typeLabel';
    yield serializers.serialize(
      object.typeLabel,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminTicketDtoOutputStatusEnum),
    );
    yield r'assigneeId';
    yield object.assigneeId == null
        ? null
        : serializers.serialize(
            object.assigneeId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'assigneeName';
    yield object.assigneeName == null
        ? null
        : serializers.serialize(
            object.assigneeName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'sla';
    yield serializers.serialize(
      object.sla,
      specifiedType: const FullType(AdminOrderTicketsDtoOutputTicketsInnerSla),
    );
    yield r'openedByName';
    yield object.openedByName == null
        ? null
        : serializers.serialize(
            object.openedByName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resolution';
    yield object.resolution == null
        ? null
        : serializers.serialize(
            object.resolution,
            specifiedType: const FullType.nullable(
              AdminOrderTicketsDtoOutputTicketsInnerResolution,
            ),
          );
    yield r'closure';
    yield object.closure == null
        ? null
        : serializers.serialize(
            object.closure,
            specifiedType: const FullType.nullable(
              AdminOrderTicketsDtoOutputTicketsInnerClosure,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketDtoOutput object, {
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
    required AdminTicketDtoOutputBuilder result,
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
        case r'source':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.source_ = valueDes;
          break;
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketDtoOutputPartyEnum,
                    ),
                  )
                  as AdminTicketDtoOutputPartyEnum;
          result.party = valueDes;
          break;
        case r'partyId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyId = valueDes;
          break;
        case r'partyName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyName = valueDes;
          break;
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.orderNumber = valueDes;
          break;
        case r'urgent':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.urgent = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminTicketDtoOutputKindEnum),
                  )
                  as AdminTicketDtoOutputKindEnum;
          result.kind = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.restaurantName = valueDes;
          break;
        case r'typeCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeCode = valueDes;
          break;
        case r'typeLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.typeLabel = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.description = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketDtoOutputStatusEnum,
                    ),
                  )
                  as AdminTicketDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'assigneeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.assigneeId = valueDes;
          break;
        case r'assigneeName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.assigneeName = valueDes;
          break;
        case r'sla':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderTicketsDtoOutputTicketsInnerSla,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerSla;
          result.sla.replace(valueDes);
          break;
        case r'openedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.openedByName = valueDes;
          break;
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'resolution':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderTicketsDtoOutputTicketsInnerResolution,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerResolution?;
          if (valueDes == null) continue;
          result.resolution.replace(valueDes);
          break;
        case r'closure':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderTicketsDtoOutputTicketsInnerClosure,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerClosure?;
          if (valueDes == null) continue;
          result.closure.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketDtoOutputBuilder();
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

class AdminTicketDtoOutputPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminTicketDtoOutputPartyEnum customer =
      _$adminTicketDtoOutputPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketDtoOutputPartyEnum restaurant =
      _$adminTicketDtoOutputPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminTicketDtoOutputPartyEnum captain =
      _$adminTicketDtoOutputPartyEnum_captain;

  static Serializer<AdminTicketDtoOutputPartyEnum> get serializer =>
      _$adminTicketDtoOutputPartyEnumSerializer;

  const AdminTicketDtoOutputPartyEnum._(String name) : super(name);

  static BuiltSet<AdminTicketDtoOutputPartyEnum> get values =>
      _$adminTicketDtoOutputPartyEnumValues;
  static AdminTicketDtoOutputPartyEnum valueOf(String name) =>
      _$adminTicketDtoOutputPartyEnumValueOf(name);
}

/// Which resolutions it takes (AP §9.9.3): general, price_difference, pickup_dispute.
class AdminTicketDtoOutputKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'general')
  static const AdminTicketDtoOutputKindEnum general =
      _$adminTicketDtoOutputKindEnum_general;
  @BuiltValueEnumConst(wireName: r'price_difference')
  static const AdminTicketDtoOutputKindEnum priceDifference =
      _$adminTicketDtoOutputKindEnum_priceDifference;
  @BuiltValueEnumConst(wireName: r'pickup_dispute')
  static const AdminTicketDtoOutputKindEnum pickupDispute =
      _$adminTicketDtoOutputKindEnum_pickupDispute;
  @BuiltValueEnumConst(wireName: r'appeal')
  static const AdminTicketDtoOutputKindEnum appeal =
      _$adminTicketDtoOutputKindEnum_appeal;

  static Serializer<AdminTicketDtoOutputKindEnum> get serializer =>
      _$adminTicketDtoOutputKindEnumSerializer;

  const AdminTicketDtoOutputKindEnum._(String name) : super(name);

  static BuiltSet<AdminTicketDtoOutputKindEnum> get values =>
      _$adminTicketDtoOutputKindEnumValues;
  static AdminTicketDtoOutputKindEnum valueOf(String name) =>
      _$adminTicketDtoOutputKindEnumValueOf(name);
}

class AdminTicketDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminTicketDtoOutputStatusEnum new_ =
      _$adminTicketDtoOutputStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const AdminTicketDtoOutputStatusEnum inProgress =
      _$adminTicketDtoOutputStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminTicketDtoOutputStatusEnum waiting =
      _$adminTicketDtoOutputStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const AdminTicketDtoOutputStatusEnum resolved =
      _$adminTicketDtoOutputStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminTicketDtoOutputStatusEnum closed =
      _$adminTicketDtoOutputStatusEnum_closed;

  static Serializer<AdminTicketDtoOutputStatusEnum> get serializer =>
      _$adminTicketDtoOutputStatusEnumSerializer;

  const AdminTicketDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminTicketDtoOutputStatusEnum> get values =>
      _$adminTicketDtoOutputStatusEnumValues;
  static AdminTicketDtoOutputStatusEnum valueOf(String name) =>
      _$adminTicketDtoOutputStatusEnumValueOf(name);
}
