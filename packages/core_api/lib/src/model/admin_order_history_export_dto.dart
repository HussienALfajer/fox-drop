//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_history_export_dto.g.dart';

/// AdminOrderHistoryExportDto
///
/// Properties:
/// * [cityId]
/// * [number] - The order number, with or without #.
/// * [customerPhone] - The customer phone in any usual form; customers.reveal_phone (OWN, OPS, SUP).
/// * [restaurantId]
/// * [captainId] - The captain who held the order last.
/// * [from] - The first business day; an export needs a period.
/// * [to] - The last business day, included; at most 366 days.
/// * [status]
/// * [outcome]
/// * [responsible] - The outcome's party in force, or operations' cancellation's.
/// * [code] - The code used, any letter case.
/// * [zoneId]
/// * [kind] - all, real or test orders.
@BuiltValue()
abstract class AdminOrderHistoryExportDto
    implements
        Built<AdminOrderHistoryExportDto, AdminOrderHistoryExportDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The order number, with or without #.
  @BuiltValueField(wireName: r'number')
  String? get number;

  /// The customer phone in any usual form; customers.reveal_phone (OWN, OPS, SUP).
  @BuiltValueField(wireName: r'customerPhone')
  String? get customerPhone;

  @BuiltValueField(wireName: r'restaurantId')
  String? get restaurantId;

  /// The captain who held the order last.
  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  /// The first business day; an export needs a period.
  @BuiltValueField(wireName: r'from')
  String get from;

  /// The last business day, included; at most 366 days.
  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'status')
  AdminOrderHistoryExportDtoStatusEnum? get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'outcome')
  AdminOrderHistoryExportDtoOutcomeEnum? get outcome;
  // enum outcomeEnum {  normal,  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  /// The outcome's party in force, or operations' cancellation's.
  @BuiltValueField(wireName: r'responsible')
  AdminOrderHistoryExportDtoResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// The code used, any letter case.
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'zoneId')
  String? get zoneId;

  /// all, real or test orders.
  @BuiltValueField(wireName: r'kind')
  AdminOrderHistoryExportDtoKindEnum get kind;
  // enum kindEnum {  all,  real,  test,  };

  AdminOrderHistoryExportDto._();

  factory AdminOrderHistoryExportDto([
    void updates(AdminOrderHistoryExportDtoBuilder b),
  ]) = _$AdminOrderHistoryExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderHistoryExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderHistoryExportDto> get serializer =>
      _$AdminOrderHistoryExportDtoSerializer();
}

class _$AdminOrderHistoryExportDtoSerializer
    implements PrimitiveSerializer<AdminOrderHistoryExportDto> {
  @override
  final Iterable<Type> types = const [
    AdminOrderHistoryExportDto,
    _$AdminOrderHistoryExportDto,
  ];

  @override
  final String wireName = r'AdminOrderHistoryExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderHistoryExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield object.number == null
        ? null
        : serializers.serialize(
            object.number,
            specifiedType: const FullType.nullable(String),
          );
    yield r'customerPhone';
    yield object.customerPhone == null
        ? null
        : serializers.serialize(
            object.customerPhone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurantId';
    yield object.restaurantId == null
        ? null
        : serializers.serialize(
            object.restaurantId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'captainId';
    yield object.captainId == null
        ? null
        : serializers.serialize(
            object.captainId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield object.status == null
        ? null
        : serializers.serialize(
            object.status,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryExportDtoStatusEnum,
            ),
          );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryExportDtoOutcomeEnum,
            ),
          );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryExportDtoResponsibleEnum,
            ),
          );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
    yield r'zoneId';
    yield object.zoneId == null
        ? null
        : serializers.serialize(
            object.zoneId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminOrderHistoryExportDtoKindEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderHistoryExportDto object, {
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
    required AdminOrderHistoryExportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.number = valueDes;
          break;
        case r'customerPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customerPhone = valueDes;
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
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainId = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryExportDtoStatusEnum,
                    ),
                  )
                  as AdminOrderHistoryExportDtoStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryExportDtoOutcomeEnum,
                    ),
                  )
                  as AdminOrderHistoryExportDtoOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryExportDtoResponsibleEnum,
                    ),
                  )
                  as AdminOrderHistoryExportDtoResponsibleEnum?;
          if (valueDes == null) continue;
          result.responsible = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'zoneId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneId = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderHistoryExportDtoKindEnum,
                    ),
                  )
                  as AdminOrderHistoryExportDtoKindEnum;
          result.kind = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderHistoryExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderHistoryExportDtoBuilder();
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

class AdminOrderHistoryExportDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderHistoryExportDtoStatusEnum placed =
      _$adminOrderHistoryExportDtoStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderHistoryExportDtoStatusEnum accepted =
      _$adminOrderHistoryExportDtoStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderHistoryExportDtoStatusEnum ready =
      _$adminOrderHistoryExportDtoStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderHistoryExportDtoStatusEnum pickedUp =
      _$adminOrderHistoryExportDtoStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderHistoryExportDtoStatusEnum arrived =
      _$adminOrderHistoryExportDtoStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderHistoryExportDtoStatusEnum delivered =
      _$adminOrderHistoryExportDtoStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderHistoryExportDtoStatusEnum rejected =
      _$adminOrderHistoryExportDtoStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderHistoryExportDtoStatusEnum cancelled =
      _$adminOrderHistoryExportDtoStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderHistoryExportDtoStatusEnum failed =
      _$adminOrderHistoryExportDtoStatusEnum_failed;

  static Serializer<AdminOrderHistoryExportDtoStatusEnum> get serializer =>
      _$adminOrderHistoryExportDtoStatusEnumSerializer;

  const AdminOrderHistoryExportDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryExportDtoStatusEnum> get values =>
      _$adminOrderHistoryExportDtoStatusEnumValues;
  static AdminOrderHistoryExportDtoStatusEnum valueOf(String name) =>
      _$adminOrderHistoryExportDtoStatusEnumValueOf(name);
}

class AdminOrderHistoryExportDtoOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'normal')
  static const AdminOrderHistoryExportDtoOutcomeEnum normal =
      _$adminOrderHistoryExportDtoOutcomeEnum_normal;
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOrderHistoryExportDtoOutcomeEnum free =
      _$adminOrderHistoryExportDtoOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOrderHistoryExportDtoOutcomeEnum fake =
      _$adminOrderHistoryExportDtoOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOrderHistoryExportDtoOutcomeEnum damaged =
      _$adminOrderHistoryExportDtoOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOrderHistoryExportDtoOutcomeEnum wrongRefused =
      _$adminOrderHistoryExportDtoOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOrderHistoryExportDtoOutcomeEnum failedOther =
      _$adminOrderHistoryExportDtoOutcomeEnum_failedOther;

  static Serializer<AdminOrderHistoryExportDtoOutcomeEnum> get serializer =>
      _$adminOrderHistoryExportDtoOutcomeEnumSerializer;

  const AdminOrderHistoryExportDtoOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryExportDtoOutcomeEnum> get values =>
      _$adminOrderHistoryExportDtoOutcomeEnumValues;
  static AdminOrderHistoryExportDtoOutcomeEnum valueOf(String name) =>
      _$adminOrderHistoryExportDtoOutcomeEnumValueOf(name);
}

/// The outcome's party in force, or operations' cancellation's.
class AdminOrderHistoryExportDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderHistoryExportDtoResponsibleEnum restaurant =
      _$adminOrderHistoryExportDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderHistoryExportDtoResponsibleEnum captain =
      _$adminOrderHistoryExportDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderHistoryExportDtoResponsibleEnum customer =
      _$adminOrderHistoryExportDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderHistoryExportDtoResponsibleEnum platform =
      _$adminOrderHistoryExportDtoResponsibleEnum_platform;

  static Serializer<AdminOrderHistoryExportDtoResponsibleEnum> get serializer =>
      _$adminOrderHistoryExportDtoResponsibleEnumSerializer;

  const AdminOrderHistoryExportDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryExportDtoResponsibleEnum> get values =>
      _$adminOrderHistoryExportDtoResponsibleEnumValues;
  static AdminOrderHistoryExportDtoResponsibleEnum valueOf(String name) =>
      _$adminOrderHistoryExportDtoResponsibleEnumValueOf(name);
}

/// all, real or test orders.
class AdminOrderHistoryExportDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'all')
  static const AdminOrderHistoryExportDtoKindEnum all =
      _$adminOrderHistoryExportDtoKindEnum_all;
  @BuiltValueEnumConst(wireName: r'real')
  static const AdminOrderHistoryExportDtoKindEnum real =
      _$adminOrderHistoryExportDtoKindEnum_real;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminOrderHistoryExportDtoKindEnum test =
      _$adminOrderHistoryExportDtoKindEnum_test;

  static Serializer<AdminOrderHistoryExportDtoKindEnum> get serializer =>
      _$adminOrderHistoryExportDtoKindEnumSerializer;

  const AdminOrderHistoryExportDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryExportDtoKindEnum> get values =>
      _$adminOrderHistoryExportDtoKindEnumValues;
  static AdminOrderHistoryExportDtoKindEnum valueOf(String name) =>
      _$adminOrderHistoryExportDtoKindEnumValueOf(name);
}
