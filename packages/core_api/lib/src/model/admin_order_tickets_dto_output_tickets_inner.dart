//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_sla.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output_tickets_inner.g.dart';

/// AdminOrderTicketsDtoOutputTicketsInner
///
/// Properties:
/// * [id]
/// * [number] - Shown as `T-{number}` (AP §4.8).
/// * [source_] - Where the ticket came from (AP §9.9.1): manual so far.
/// * [party]
/// * [partyId]
/// * [partyName]
/// * [orderId]
/// * [orderNumber]
/// * [urgent] - «عاجلة»: open, on an order still active.
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
@BuiltValue()
abstract class AdminOrderTicketsDtoOutputTicketsInner
    implements
        Built<
          AdminOrderTicketsDtoOutputTicketsInner,
          AdminOrderTicketsDtoOutputTicketsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as `T-{number}` (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// Where the ticket came from (AP §9.9.1): manual so far.
  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'party')
  AdminOrderTicketsDtoOutputTicketsInnerPartyEnum get party;
  // enum partyEnum {  customer,  restaurant,  captain,  };

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'partyName')
  String get partyName;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// «عاجلة»: open, on an order still active.
  @BuiltValueField(wireName: r'urgent')
  bool get urgent;

  @BuiltValueField(wireName: r'typeCode')
  String get typeCode;

  @BuiltValueField(wireName: r'typeLabel')
  String get typeLabel;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'status')
  AdminOrderTicketsDtoOutputTicketsInnerStatusEnum get status;
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

  AdminOrderTicketsDtoOutputTicketsInner._();

  factory AdminOrderTicketsDtoOutputTicketsInner([
    void updates(AdminOrderTicketsDtoOutputTicketsInnerBuilder b),
  ]) = _$AdminOrderTicketsDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderTicketsDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderTicketsDtoOutputTicketsInner> get serializer =>
      _$AdminOrderTicketsDtoOutputTicketsInnerSerializer();
}

class _$AdminOrderTicketsDtoOutputTicketsInnerSerializer
    implements PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutputTicketsInner,
    _$AdminOrderTicketsDtoOutputTicketsInner,
  ];

  @override
  final String wireName = r'AdminOrderTicketsDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInner object, {
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
      specifiedType: const FullType(
        AdminOrderTicketsDtoOutputTicketsInnerPartyEnum,
      ),
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
      specifiedType: const FullType(
        AdminOrderTicketsDtoOutputTicketsInnerStatusEnum,
      ),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInner object, {
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
    required AdminOrderTicketsDtoOutputTicketsInnerBuilder result,
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
                      AdminOrderTicketsDtoOutputTicketsInnerPartyEnum,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerPartyEnum;
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
                      AdminOrderTicketsDtoOutputTicketsInnerStatusEnum,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderTicketsDtoOutputTicketsInnerBuilder();
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

class AdminOrderTicketsDtoOutputTicketsInnerPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum customer =
      _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_customer;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum restaurant =
      _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum captain =
      _$adminOrderTicketsDtoOutputTicketsInnerPartyEnum_captain;

  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerPartyEnum>
  get serializer => _$adminOrderTicketsDtoOutputTicketsInnerPartyEnumSerializer;

  const AdminOrderTicketsDtoOutputTicketsInnerPartyEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerPartyEnum> get values =>
      _$adminOrderTicketsDtoOutputTicketsInnerPartyEnumValues;
  static AdminOrderTicketsDtoOutputTicketsInnerPartyEnum valueOf(String name) =>
      _$adminOrderTicketsDtoOutputTicketsInnerPartyEnumValueOf(name);
}

class AdminOrderTicketsDtoOutputTicketsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum new_ =
      _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum inProgress =
      _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum waiting =
      _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum resolved =
      _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum closed =
      _$adminOrderTicketsDtoOutputTicketsInnerStatusEnum_closed;

  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerStatusEnum>
  get serializer =>
      _$adminOrderTicketsDtoOutputTicketsInnerStatusEnumSerializer;

  const AdminOrderTicketsDtoOutputTicketsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerStatusEnum>
  get values => _$adminOrderTicketsDtoOutputTicketsInnerStatusEnumValues;
  static AdminOrderTicketsDtoOutputTicketsInnerStatusEnum valueOf(
    String name,
  ) => _$adminOrderTicketsDtoOutputTicketsInnerStatusEnumValueOf(name);
}
