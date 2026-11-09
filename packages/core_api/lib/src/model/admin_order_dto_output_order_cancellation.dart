//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_cancellation_by.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_cancellation.g.dart';

/// AP §9.3.1 «cancellation (reason and party)».
///
/// Properties:
/// * [at]
/// * [reason] - The stored code (merchant_auto_cancel for the timer).
/// * [label] - The reason's label: operations' as chosen (ops_cancel), the customer's from Content (customer_cancel); null for the automatic cancellation.
/// * [note] - The customer's «سبب آخر» text, or operations' internal note.
/// * [customerText] - What the customer sees (CU Appendix C); null for their own cancellation.
/// * [by]
/// * [responsible] - Operations' cancellation only (docs/domain/09).
/// * [foodPrepared] - «تم تحضير الطعام؟».
/// * [cash] - «هل أعاد المطعم المبلغ للكابتن؟», when the captain had reached the restaurant.
/// * [merchantCredit]
/// * [captainCompensation]
/// * [acknowledgedAt] - A restaurant device's «حسناً».
/// * [captainSeenAt] - The captain's «حسناً».
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCancellation
    implements
        Built<
          AdminOrderDtoOutputOrderCancellation,
          AdminOrderDtoOutputOrderCancellationBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The stored code (merchant_auto_cancel for the timer).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The reason's label: operations' as chosen (ops_cancel), the customer's from Content (customer_cancel); null for the automatic cancellation.
  @BuiltValueField(wireName: r'label')
  String? get label;

  /// The customer's «سبب آخر» text, or operations' internal note.
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// What the customer sees (CU Appendix C); null for their own cancellation.
  @BuiltValueField(wireName: r'customerText')
  String? get customerText;

  @BuiltValueField(wireName: r'by')
  AdminOrderDtoOutputOrderCancellationBy get by;

  /// Operations' cancellation only (docs/domain/09).
  @BuiltValueField(wireName: r'responsible')
  AdminOrderDtoOutputOrderCancellationResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// «تم تحضير الطعام؟».
  @BuiltValueField(wireName: r'foodPrepared')
  bool get foodPrepared;

  /// «هل أعاد المطعم المبلغ للكابتن؟», when the captain had reached the restaurant.
  @BuiltValueField(wireName: r'cash')
  AdminOrderDtoOutputOrderCancellationCashEnum? get cash;
  // enum cashEnum {  returned,  not_returned,  not_paid,  };

  @BuiltValueField(wireName: r'merchantCredit')
  CaptainWentOfflineDtoOutputHandIn? get merchantCredit;

  @BuiltValueField(wireName: r'captainCompensation')
  CaptainWentOfflineDtoOutputHandIn? get captainCompensation;

  /// A restaurant device's «حسناً».
  @BuiltValueField(wireName: r'acknowledgedAt')
  DateTime? get acknowledgedAt;

  /// The captain's «حسناً».
  @BuiltValueField(wireName: r'captainSeenAt')
  DateTime? get captainSeenAt;

  AdminOrderDtoOutputOrderCancellation._();

  factory AdminOrderDtoOutputOrderCancellation([
    void updates(AdminOrderDtoOutputOrderCancellationBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCancellation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCancellationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCancellation> get serializer =>
      _$AdminOrderDtoOutputOrderCancellationSerializer();
}

class _$AdminOrderDtoOutputOrderCancellationSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderCancellation> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCancellation,
    _$AdminOrderDtoOutputOrderCancellation,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCancellation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null
        ? null
        : serializers.serialize(
            object.label,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'customerText';
    yield object.customerText == null
        ? null
        : serializers.serialize(
            object.customerText,
            specifiedType: const FullType.nullable(String),
          );
    yield r'by';
    yield serializers.serialize(
      object.by,
      specifiedType: const FullType(AdminOrderDtoOutputOrderCancellationBy),
    );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderCancellationResponsibleEnum,
            ),
          );
    yield r'foodPrepared';
    yield serializers.serialize(
      object.foodPrepared,
      specifiedType: const FullType(bool),
    );
    yield r'cash';
    yield object.cash == null
        ? null
        : serializers.serialize(
            object.cash,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderCancellationCashEnum,
            ),
          );
    yield r'merchantCredit';
    yield object.merchantCredit == null
        ? null
        : serializers.serialize(
            object.merchantCredit,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'captainCompensation';
    yield object.captainCompensation == null
        ? null
        : serializers.serialize(
            object.captainCompensation,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'acknowledgedAt';
    yield object.acknowledgedAt == null
        ? null
        : serializers.serialize(
            object.acknowledgedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'captainSeenAt';
    yield object.captainSeenAt == null
        ? null
        : serializers.serialize(
            object.captainSeenAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCancellation object, {
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
    required AdminOrderDtoOutputOrderCancellationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'customerText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customerText = valueDes;
          break;
        case r'by':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderCancellationBy,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCancellationBy;
          result.by.replace(valueDes);
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderCancellationResponsibleEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCancellationResponsibleEnum?;
          if (valueDes == null) continue;
          result.responsible = valueDes;
          break;
        case r'foodPrepared':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.foodPrepared = valueDes;
          break;
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderCancellationCashEnum,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCancellationCashEnum?;
          if (valueDes == null) continue;
          result.cash = valueDes;
          break;
        case r'merchantCredit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.merchantCredit.replace(valueDes);
          break;
        case r'captainCompensation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.captainCompensation.replace(valueDes);
          break;
        case r'acknowledgedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.acknowledgedAt = valueDes;
          break;
        case r'captainSeenAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.captainSeenAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderCancellation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCancellationBuilder();
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

/// Operations' cancellation only (docs/domain/09).
class AdminOrderDtoOutputOrderCancellationResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderDtoOutputOrderCancellationResponsibleEnum restaurant =
      _$adminOrderDtoOutputOrderCancellationResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderDtoOutputOrderCancellationResponsibleEnum captain =
      _$adminOrderDtoOutputOrderCancellationResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderDtoOutputOrderCancellationResponsibleEnum customer =
      _$adminOrderDtoOutputOrderCancellationResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderDtoOutputOrderCancellationResponsibleEnum platform =
      _$adminOrderDtoOutputOrderCancellationResponsibleEnum_platform;

  static Serializer<AdminOrderDtoOutputOrderCancellationResponsibleEnum>
  get serializer =>
      _$adminOrderDtoOutputOrderCancellationResponsibleEnumSerializer;

  const AdminOrderDtoOutputOrderCancellationResponsibleEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderCancellationResponsibleEnum>
  get values => _$adminOrderDtoOutputOrderCancellationResponsibleEnumValues;
  static AdminOrderDtoOutputOrderCancellationResponsibleEnum valueOf(
    String name,
  ) => _$adminOrderDtoOutputOrderCancellationResponsibleEnumValueOf(name);
}

/// «هل أعاد المطعم المبلغ للكابتن؟», when the captain had reached the restaurant.
class AdminOrderDtoOutputOrderCancellationCashEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'returned')
  static const AdminOrderDtoOutputOrderCancellationCashEnum returned =
      _$adminOrderDtoOutputOrderCancellationCashEnum_returned;
  @BuiltValueEnumConst(wireName: r'not_returned')
  static const AdminOrderDtoOutputOrderCancellationCashEnum notReturned =
      _$adminOrderDtoOutputOrderCancellationCashEnum_notReturned;
  @BuiltValueEnumConst(wireName: r'not_paid')
  static const AdminOrderDtoOutputOrderCancellationCashEnum notPaid =
      _$adminOrderDtoOutputOrderCancellationCashEnum_notPaid;

  static Serializer<AdminOrderDtoOutputOrderCancellationCashEnum>
  get serializer => _$adminOrderDtoOutputOrderCancellationCashEnumSerializer;

  const AdminOrderDtoOutputOrderCancellationCashEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderDtoOutputOrderCancellationCashEnum> get values =>
      _$adminOrderDtoOutputOrderCancellationCashEnumValues;
  static AdminOrderDtoOutputOrderCancellationCashEnum valueOf(String name) =>
      _$adminOrderDtoOutputOrderCancellationCashEnumValueOf(name);
}
