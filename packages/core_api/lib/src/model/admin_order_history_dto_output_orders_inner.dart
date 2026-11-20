//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_pay_table_preview_dto_output_in_force_base.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_history_dto_output_orders_inner.g.dart';

/// AdminOrderHistoryDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [placedAt]
/// * [restaurantId]
/// * [restaurantName]
/// * [neighbourhood] - The customer's neighbourhood at placing.
/// * [captainId]
/// * [captainName]
/// * [status]
/// * [outcome]
/// * [responsible]
/// * [total]
/// * [deliveryMinutes] - From placing to delivery; null unless delivered.
/// * [code]
/// * [testOrder]
/// * [redelivery]
@BuiltValue()
abstract class AdminOrderHistoryDtoOutputOrdersInner
    implements
        Built<
          AdminOrderHistoryDtoOutputOrdersInner,
          AdminOrderHistoryDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  /// The customer's neighbourhood at placing.
  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  @BuiltValueField(wireName: r'captainId')
  String? get captainId;

  @BuiltValueField(wireName: r'captainName')
  String? get captainName;

  @BuiltValueField(wireName: r'status')
  AdminOrderHistoryDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'outcome')
  AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum? get outcome;
  // enum outcomeEnum {  normal,  free,  fake,  damaged,  wrong_refused,  failed_other,  };

  @BuiltValueField(wireName: r'responsible')
  AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  @BuiltValueField(wireName: r'total')
  AdminPayTablePreviewDtoOutputInForceBase get total;

  /// From placing to delivery; null unless delivered.
  @BuiltValueField(wireName: r'deliveryMinutes')
  int? get deliveryMinutes;

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'testOrder')
  bool get testOrder;

  @BuiltValueField(wireName: r'redelivery')
  bool get redelivery;

  AdminOrderHistoryDtoOutputOrdersInner._();

  factory AdminOrderHistoryDtoOutputOrdersInner([
    void updates(AdminOrderHistoryDtoOutputOrdersInnerBuilder b),
  ]) = _$AdminOrderHistoryDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderHistoryDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderHistoryDtoOutputOrdersInner> get serializer =>
      _$AdminOrderHistoryDtoOutputOrdersInnerSerializer();
}

class _$AdminOrderHistoryDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<AdminOrderHistoryDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderHistoryDtoOutputOrdersInner,
    _$AdminOrderHistoryDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'AdminOrderHistoryDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderHistoryDtoOutputOrdersInner object, {
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
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
    yield r'captainId';
    yield object.captainId == null
        ? null
        : serializers.serialize(
            object.captainId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'captainName';
    yield object.captainName == null
        ? null
        : serializers.serialize(
            object.captainName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOrderHistoryDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum,
            ),
          );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum,
            ),
          );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(AdminPayTablePreviewDtoOutputInForceBase),
    );
    yield r'deliveryMinutes';
    yield object.deliveryMinutes == null
        ? null
        : serializers.serialize(
            object.deliveryMinutes,
            specifiedType: const FullType.nullable(int),
          );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
    yield r'testOrder';
    yield serializers.serialize(
      object.testOrder,
      specifiedType: const FullType(bool),
    );
    yield r'redelivery';
    yield serializers.serialize(
      object.redelivery,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderHistoryDtoOutputOrdersInner object, {
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
    required AdminOrderHistoryDtoOutputOrdersInnerBuilder result,
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
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'neighbourhood':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.neighbourhood = valueDes;
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
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.captainName = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderHistoryDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as AdminOrderHistoryDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum,
                    ),
                  )
                  as AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum,
                    ),
                  )
                  as AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum?;
          if (valueDes == null) continue;
          result.responsible = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPayTablePreviewDtoOutputInForceBase,
                    ),
                  )
                  as AdminPayTablePreviewDtoOutputInForceBase;
          result.total.replace(valueDes);
          break;
        case r'deliveryMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.deliveryMinutes = valueDes;
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
        case r'testOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.testOrder = valueDes;
          break;
        case r'redelivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.redelivery = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderHistoryDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderHistoryDtoOutputOrdersInnerBuilder();
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

class AdminOrderHistoryDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum placed =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum accepted =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum ready =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum pickedUp =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum arrived =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum delivered =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum rejected =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum cancelled =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum failed =
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<AdminOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get serializer => _$adminOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer;

  const AdminOrderHistoryDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderHistoryDtoOutputOrdersInnerStatusEnum> get values =>
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnumValues;
  static AdminOrderHistoryDtoOutputOrdersInnerStatusEnum valueOf(String name) =>
      _$adminOrderHistoryDtoOutputOrdersInnerStatusEnumValueOf(name);
}

class AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'normal')
  static const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum normal =
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnum_normal;
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum free =
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum fake =
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum damaged =
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum wrongRefused =
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum failedOther =
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnum_failedOther;

  static Serializer<AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum>
  get serializer =>
      _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnumSerializer;

  const AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum>
  get values => _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnumValues;
  static AdminOrderHistoryDtoOutputOrdersInnerOutcomeEnum valueOf(
    String name,
  ) => _$adminOrderHistoryDtoOutputOrdersInnerOutcomeEnumValueOf(name);
}

class AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum restaurant =
      _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum captain =
      _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum customer =
      _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum platform =
      _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnum_platform;

  static Serializer<AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum>
  get serializer =>
      _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnumSerializer;

  const AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum>
  get values => _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnumValues;
  static AdminOrderHistoryDtoOutputOrdersInnerResponsibleEnum valueOf(
    String name,
  ) => _$adminOrderHistoryDtoOutputOrdersInnerResponsibleEnumValueOf(name);
}
