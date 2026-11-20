//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_history_query_dto.g.dart';

/// AdminOrderHistoryQueryDto
///
/// Properties:
/// * [cityId]
/// * [number] - The order number, with or without #.
/// * [customerPhone] - The customer phone in any usual form; customers.reveal_phone (OWN, OPS, SUP).
/// * [restaurantId]
/// * [captainId] - The captain who held the order last.
/// * [from] - The first business day, YYYY-MM-DD on the city clock.
/// * [to] - The last business day, included.
/// * [status]
/// * [outcome]
/// * [responsible] - The outcome's party in force, or operations' cancellation's.
/// * [code] - The code used, any letter case.
/// * [zoneId]
/// * [kind] - all, real or test orders.
/// * [cursor] - The `next` of the page before; null for the first page.
@BuiltValue()
abstract class AdminOrderHistoryQueryDto
    implements
        Built<AdminOrderHistoryQueryDto, AdminOrderHistoryQueryDtoBuilder> {
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

  /// The first business day, YYYY-MM-DD on the city clock.
  @BuiltValueField(wireName: r'from')
  String? get from;

  /// The last business day, included.
  @BuiltValueField(wireName: r'to')
  String? get to;

  @BuiltValueField(wireName: r'status')
  AdminOrderHistoryQueryDtoStatusEnum? get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'outcome')
  AdminOrderHistoryQueryDtoOutcomeEnum? get outcome;
  // enum outcomeEnum {  normal,  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  /// The outcome's party in force, or operations' cancellation's.
  @BuiltValueField(wireName: r'responsible')
  AdminOrderHistoryQueryDtoResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// The code used, any letter case.
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'zoneId')
  String? get zoneId;

  /// all, real or test orders.
  @BuiltValueField(wireName: r'kind')
  AdminOrderHistoryQueryDtoKindEnum get kind;
  // enum kindEnum {  all,  real,  test,  };

  /// The `next` of the page before; null for the first page.
  @BuiltValueField(wireName: r'cursor')
  String? get cursor;

  AdminOrderHistoryQueryDto._();

  factory AdminOrderHistoryQueryDto([
    void updates(AdminOrderHistoryQueryDtoBuilder b),
  ]) = _$AdminOrderHistoryQueryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderHistoryQueryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderHistoryQueryDto> get serializer =>
      _$AdminOrderHistoryQueryDtoSerializer();
}

class _$AdminOrderHistoryQueryDtoSerializer
    implements PrimitiveSerializer<AdminOrderHistoryQueryDto> {
  @override
  final Iterable<Type> types = const [
    AdminOrderHistoryQueryDto,
    _$AdminOrderHistoryQueryDto,
  ];

  @override
  final String wireName = r'AdminOrderHistoryQueryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderHistoryQueryDto object, {
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
    yield object.from == null
        ? null
        : serializers.serialize(
            object.from,
            specifiedType: const FullType.nullable(String),
          );
    yield r'to';
    yield object.to == null
        ? null
        : serializers.serialize(
            object.to,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield object.status == null
        ? null
        : serializers.serialize(
            object.status,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryQueryDtoStatusEnum,
            ),
          );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryQueryDtoOutcomeEnum,
            ),
          );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryQueryDtoResponsibleEnum,
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
      specifiedType: const FullType(AdminOrderHistoryQueryDtoKindEnum),
    );
    yield r'cursor';
    yield object.cursor == null
        ? null
        : serializers.serialize(
            object.cursor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderHistoryQueryDto object, {
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
    required AdminOrderHistoryQueryDtoBuilder result,
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
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.to = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryQueryDtoStatusEnum,
                    ),
                  )
                  as AdminOrderHistoryQueryDtoStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryQueryDtoOutcomeEnum,
                    ),
                  )
                  as AdminOrderHistoryQueryDtoOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryQueryDtoResponsibleEnum,
                    ),
                  )
                  as AdminOrderHistoryQueryDtoResponsibleEnum?;
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
                      AdminOrderHistoryQueryDtoKindEnum,
                    ),
                  )
                  as AdminOrderHistoryQueryDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'cursor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderHistoryQueryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderHistoryQueryDtoBuilder();
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

class AdminOrderHistoryQueryDtoStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderHistoryQueryDtoStatusEnum placed =
      _$adminOrderHistoryQueryDtoStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderHistoryQueryDtoStatusEnum accepted =
      _$adminOrderHistoryQueryDtoStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderHistoryQueryDtoStatusEnum ready =
      _$adminOrderHistoryQueryDtoStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderHistoryQueryDtoStatusEnum pickedUp =
      _$adminOrderHistoryQueryDtoStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderHistoryQueryDtoStatusEnum arrived =
      _$adminOrderHistoryQueryDtoStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderHistoryQueryDtoStatusEnum delivered =
      _$adminOrderHistoryQueryDtoStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderHistoryQueryDtoStatusEnum rejected =
      _$adminOrderHistoryQueryDtoStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderHistoryQueryDtoStatusEnum cancelled =
      _$adminOrderHistoryQueryDtoStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderHistoryQueryDtoStatusEnum failed =
      _$adminOrderHistoryQueryDtoStatusEnum_failed;

  static Serializer<AdminOrderHistoryQueryDtoStatusEnum> get serializer =>
      _$adminOrderHistoryQueryDtoStatusEnumSerializer;

  const AdminOrderHistoryQueryDtoStatusEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryQueryDtoStatusEnum> get values =>
      _$adminOrderHistoryQueryDtoStatusEnumValues;
  static AdminOrderHistoryQueryDtoStatusEnum valueOf(String name) =>
      _$adminOrderHistoryQueryDtoStatusEnumValueOf(name);
}

class AdminOrderHistoryQueryDtoOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'normal')
  static const AdminOrderHistoryQueryDtoOutcomeEnum normal =
      _$adminOrderHistoryQueryDtoOutcomeEnum_normal;
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOrderHistoryQueryDtoOutcomeEnum free =
      _$adminOrderHistoryQueryDtoOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOrderHistoryQueryDtoOutcomeEnum fake =
      _$adminOrderHistoryQueryDtoOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOrderHistoryQueryDtoOutcomeEnum damaged =
      _$adminOrderHistoryQueryDtoOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOrderHistoryQueryDtoOutcomeEnum wrongRefused =
      _$adminOrderHistoryQueryDtoOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOrderHistoryQueryDtoOutcomeEnum failedOther =
      _$adminOrderHistoryQueryDtoOutcomeEnum_failedOther;

  static Serializer<AdminOrderHistoryQueryDtoOutcomeEnum> get serializer =>
      _$adminOrderHistoryQueryDtoOutcomeEnumSerializer;

  const AdminOrderHistoryQueryDtoOutcomeEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryQueryDtoOutcomeEnum> get values =>
      _$adminOrderHistoryQueryDtoOutcomeEnumValues;
  static AdminOrderHistoryQueryDtoOutcomeEnum valueOf(String name) =>
      _$adminOrderHistoryQueryDtoOutcomeEnumValueOf(name);
}

/// The outcome's party in force, or operations' cancellation's.
class AdminOrderHistoryQueryDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderHistoryQueryDtoResponsibleEnum restaurant =
      _$adminOrderHistoryQueryDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderHistoryQueryDtoResponsibleEnum captain =
      _$adminOrderHistoryQueryDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderHistoryQueryDtoResponsibleEnum customer =
      _$adminOrderHistoryQueryDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderHistoryQueryDtoResponsibleEnum platform =
      _$adminOrderHistoryQueryDtoResponsibleEnum_platform;

  static Serializer<AdminOrderHistoryQueryDtoResponsibleEnum> get serializer =>
      _$adminOrderHistoryQueryDtoResponsibleEnumSerializer;

  const AdminOrderHistoryQueryDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryQueryDtoResponsibleEnum> get values =>
      _$adminOrderHistoryQueryDtoResponsibleEnumValues;
  static AdminOrderHistoryQueryDtoResponsibleEnum valueOf(String name) =>
      _$adminOrderHistoryQueryDtoResponsibleEnumValueOf(name);
}

/// all, real or test orders.
class AdminOrderHistoryQueryDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'all')
  static const AdminOrderHistoryQueryDtoKindEnum all =
      _$adminOrderHistoryQueryDtoKindEnum_all;
  @BuiltValueEnumConst(wireName: r'real')
  static const AdminOrderHistoryQueryDtoKindEnum real =
      _$adminOrderHistoryQueryDtoKindEnum_real;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminOrderHistoryQueryDtoKindEnum test =
      _$adminOrderHistoryQueryDtoKindEnum_test;

  static Serializer<AdminOrderHistoryQueryDtoKindEnum> get serializer =>
      _$adminOrderHistoryQueryDtoKindEnumSerializer;

  const AdminOrderHistoryQueryDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminOrderHistoryQueryDtoKindEnum> get values =>
      _$adminOrderHistoryQueryDtoKindEnumValues;
  static AdminOrderHistoryQueryDtoKindEnum valueOf(String name) =>
      _$adminOrderHistoryQueryDtoKindEnumValueOf(name);
}
