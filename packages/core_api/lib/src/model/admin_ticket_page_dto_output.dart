//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_closure.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_report.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_pickup_dispute.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_redeliveries_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_notes_inner.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_sla.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output.g.dart';

/// AdminTicketPageDtoOutput
///
/// Properties:
/// * [id]
/// * [number] - Shown as `T-{number}` (AP §4.8).
/// * [source_] - Where the ticket came from (AP §9.9.1): manual, pickup_dispute, customer_report, price_report, merchant_report, order_problem, captain_report, captain_problem so far.
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
/// * [notes] - Oldest first.
/// * [pickupDispute]
/// * [order]
/// * [redeliveries] - «إعادة توصيل مجانية» orders placed for it, newest first (AP §9.9.3).
/// * [report]
@BuiltValue()
abstract class AdminTicketPageDtoOutput
    implements
        Built<AdminTicketPageDtoOutput, AdminTicketPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as `T-{number}` (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// Where the ticket came from (AP §9.9.1): manual, pickup_dispute, customer_report, price_report, merchant_report, order_problem, captain_report, captain_problem so far.
  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'party')
  AdminTicketPageDtoOutputPartyEnum get party;
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
  AdminTicketPageDtoOutputKindEnum get kind;
  // enum kindEnum {  general,  price_difference,  pickup_dispute,  };

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
  AdminTicketPageDtoOutputStatusEnum get status;
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

  /// Oldest first.
  @BuiltValueField(wireName: r'notes')
  BuiltList<AdminCustomerDtoOutputNotesInner> get notes;

  @BuiltValueField(wireName: r'pickupDispute')
  AdminTicketPageDtoOutputPickupDispute? get pickupDispute;

  @BuiltValueField(wireName: r'order')
  AdminTicketPageDtoOutputOrder? get order;

  /// «إعادة توصيل مجانية» orders placed for it, newest first (AP §9.9.3).
  @BuiltValueField(wireName: r'redeliveries')
  BuiltList<AdminTicketPageDtoOutputRedeliveriesInner> get redeliveries;

  @BuiltValueField(wireName: r'report')
  AdminTicketPageDtoOutputReport? get report;

  AdminTicketPageDtoOutput._();

  factory AdminTicketPageDtoOutput([
    void updates(AdminTicketPageDtoOutputBuilder b),
  ]) = _$AdminTicketPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutput> get serializer =>
      _$AdminTicketPageDtoOutputSerializer();
}

class _$AdminTicketPageDtoOutputSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutput,
    _$AdminTicketPageDtoOutput,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutput object, {
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
      specifiedType: const FullType(AdminTicketPageDtoOutputPartyEnum),
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
      specifiedType: const FullType(AdminTicketPageDtoOutputKindEnum),
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
      specifiedType: const FullType(AdminTicketPageDtoOutputStatusEnum),
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
    yield r'notes';
    yield serializers.serialize(
      object.notes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputNotesInner),
      ]),
    );
    yield r'pickupDispute';
    yield object.pickupDispute == null
        ? null
        : serializers.serialize(
            object.pickupDispute,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputPickupDispute,
            ),
          );
    yield r'order';
    yield object.order == null
        ? null
        : serializers.serialize(
            object.order,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputOrder,
            ),
          );
    yield r'redeliveries';
    yield serializers.serialize(
      object.redeliveries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminTicketPageDtoOutputRedeliveriesInner),
      ]),
    );
    yield r'report';
    yield object.report == null
        ? null
        : serializers.serialize(
            object.report,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputReport,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutput object, {
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
    required AdminTicketPageDtoOutputBuilder result,
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
                      AdminTicketPageDtoOutputPartyEnum,
                    ),
                  )
                  as AdminTicketPageDtoOutputPartyEnum;
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
                    specifiedType: const FullType(
                      AdminTicketPageDtoOutputKindEnum,
                    ),
                  )
                  as AdminTicketPageDtoOutputKindEnum;
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
                      AdminTicketPageDtoOutputStatusEnum,
                    ),
                  )
                  as AdminTicketPageDtoOutputStatusEnum;
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
        case r'notes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputNotesInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputNotesInner>;
          result.notes.replace(valueDes);
          break;
        case r'pickupDispute':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputPickupDispute,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDispute?;
          if (valueDes == null) continue;
          result.pickupDispute.replace(valueDes);
          break;
        case r'order':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputOrder,
                    ),
                  )
                  as AdminTicketPageDtoOutputOrder?;
          if (valueDes == null) continue;
          result.order.replace(valueDes);
          break;
        case r'redeliveries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminTicketPageDtoOutputRedeliveriesInner),
                    ]),
                  )
                  as BuiltList<AdminTicketPageDtoOutputRedeliveriesInner>;
          result.redeliveries.replace(valueDes);
          break;
        case r'report':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputReport,
                    ),
                  )
                  as AdminTicketPageDtoOutputReport?;
          if (valueDes == null) continue;
          result.report.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputBuilder();
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

class AdminTicketPageDtoOutputPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminTicketPageDtoOutputPartyEnum customer =
      _$adminTicketPageDtoOutputPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketPageDtoOutputPartyEnum restaurant =
      _$adminTicketPageDtoOutputPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminTicketPageDtoOutputPartyEnum captain =
      _$adminTicketPageDtoOutputPartyEnum_captain;

  static Serializer<AdminTicketPageDtoOutputPartyEnum> get serializer =>
      _$adminTicketPageDtoOutputPartyEnumSerializer;

  const AdminTicketPageDtoOutputPartyEnum._(String name) : super(name);

  static BuiltSet<AdminTicketPageDtoOutputPartyEnum> get values =>
      _$adminTicketPageDtoOutputPartyEnumValues;
  static AdminTicketPageDtoOutputPartyEnum valueOf(String name) =>
      _$adminTicketPageDtoOutputPartyEnumValueOf(name);
}

/// Which resolutions it takes (AP §9.9.3): general, price_difference, pickup_dispute.
class AdminTicketPageDtoOutputKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'general')
  static const AdminTicketPageDtoOutputKindEnum general =
      _$adminTicketPageDtoOutputKindEnum_general;
  @BuiltValueEnumConst(wireName: r'price_difference')
  static const AdminTicketPageDtoOutputKindEnum priceDifference =
      _$adminTicketPageDtoOutputKindEnum_priceDifference;
  @BuiltValueEnumConst(wireName: r'pickup_dispute')
  static const AdminTicketPageDtoOutputKindEnum pickupDispute =
      _$adminTicketPageDtoOutputKindEnum_pickupDispute;

  static Serializer<AdminTicketPageDtoOutputKindEnum> get serializer =>
      _$adminTicketPageDtoOutputKindEnumSerializer;

  const AdminTicketPageDtoOutputKindEnum._(String name) : super(name);

  static BuiltSet<AdminTicketPageDtoOutputKindEnum> get values =>
      _$adminTicketPageDtoOutputKindEnumValues;
  static AdminTicketPageDtoOutputKindEnum valueOf(String name) =>
      _$adminTicketPageDtoOutputKindEnumValueOf(name);
}

class AdminTicketPageDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminTicketPageDtoOutputStatusEnum new_ =
      _$adminTicketPageDtoOutputStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const AdminTicketPageDtoOutputStatusEnum inProgress =
      _$adminTicketPageDtoOutputStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminTicketPageDtoOutputStatusEnum waiting =
      _$adminTicketPageDtoOutputStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const AdminTicketPageDtoOutputStatusEnum resolved =
      _$adminTicketPageDtoOutputStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminTicketPageDtoOutputStatusEnum closed =
      _$adminTicketPageDtoOutputStatusEnum_closed;

  static Serializer<AdminTicketPageDtoOutputStatusEnum> get serializer =>
      _$adminTicketPageDtoOutputStatusEnumSerializer;

  const AdminTicketPageDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminTicketPageDtoOutputStatusEnum> get values =>
      _$adminTicketPageDtoOutputStatusEnumValues;
  static AdminTicketPageDtoOutputStatusEnum valueOf(String name) =>
      _$adminTicketPageDtoOutputStatusEnumValueOf(name);
}
