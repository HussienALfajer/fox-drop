//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_sla.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_dto_output.g.dart';

/// AdminTicketDtoOutput
///
/// Properties:
/// * [id]
/// * [number] - Shown as `T-{number}` (AP §4.8).
/// * [source_]
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
abstract class AdminTicketDtoOutput
    implements Built<AdminTicketDtoOutput, AdminTicketDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as `T-{number}` (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'source')
  AdminTicketDtoOutputSource_Enum get source_;
  // enum source_Enum {  manual,  };

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
      specifiedType: const FullType(AdminTicketDtoOutputSource_Enum),
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
                    specifiedType: const FullType(
                      AdminTicketDtoOutputSource_Enum,
                    ),
                  )
                  as AdminTicketDtoOutputSource_Enum;
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

class AdminTicketDtoOutputSource_Enum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminTicketDtoOutputSource_Enum manual =
      _$adminTicketDtoOutputSourceEnum_manual;

  static Serializer<AdminTicketDtoOutputSource_Enum> get serializer =>
      _$adminTicketDtoOutputSourceEnumSerializer;

  const AdminTicketDtoOutputSource_Enum._(String name) : super(name);

  static BuiltSet<AdminTicketDtoOutputSource_Enum> get values =>
      _$adminTicketDtoOutputSourceEnumValues;
  static AdminTicketDtoOutputSource_Enum valueOf(String name) =>
      _$adminTicketDtoOutputSourceEnumValueOf(name);
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
