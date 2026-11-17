//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_period_statement_dto_output_lines_inner.g.dart';

/// AdminRestaurantPeriodStatementDtoOutputLinesInner
///
/// Properties:
/// * [kind]
/// * [at]
/// * [orderId]
/// * [orderNumber]
/// * [itemsValue]
/// * [pickupLines]
/// * [commission]
/// * [discountShare]
/// * [cause]
/// * [amount]
/// * [reason]
/// * [receiptId]
/// * [receiptNumber]
@BuiltValue()
abstract class AdminRestaurantPeriodStatementDtoOutputLinesInner
    implements
        Built<
          AdminRestaurantPeriodStatementDtoOutputLinesInner,
          AdminRestaurantPeriodStatementDtoOutputLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum get kind;
  // enum kindEnum {  order,  exception,  payment,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  @BuiltValueField(wireName: r'itemsValue')
  String? get itemsValue;

  @BuiltValueField(wireName: r'pickupLines')
  BuiltList<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  >?
  get pickupLines;

  @BuiltValueField(wireName: r'commission')
  String? get commission;

  @BuiltValueField(wireName: r'discountShare')
  String? get discountShare;

  @BuiltValueField(wireName: r'cause')
  AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum? get cause;
  // enum causeEnum {  food_credit,  credit,  pickup_refund,  pickup_kept,  items_removed,  fee_lowered,  fee_cut_returned,  debit,  commission_reversal,  commission_restored,  discount_reversal,  outcome_changed,  adjustment,  };

  @BuiltValueField(wireName: r'amount')
  String? get amount;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'receiptId')
  String? get receiptId;

  @BuiltValueField(wireName: r'receiptNumber')
  String? get receiptNumber;

  AdminRestaurantPeriodStatementDtoOutputLinesInner._();

  factory AdminRestaurantPeriodStatementDtoOutputLinesInner([
    void updates(AdminRestaurantPeriodStatementDtoOutputLinesInnerBuilder b),
  ]) = _$AdminRestaurantPeriodStatementDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantPeriodStatementDtoOutputLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantPeriodStatementDtoOutputLinesInner>
  get serializer =>
      _$AdminRestaurantPeriodStatementDtoOutputLinesInnerSerializer();
}

class _$AdminRestaurantPeriodStatementDtoOutputLinesInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantPeriodStatementDtoOutputLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantPeriodStatementDtoOutputLinesInner,
    _$AdminRestaurantPeriodStatementDtoOutputLinesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantPeriodStatementDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantPeriodStatementDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum,
      ),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
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
    yield r'itemsValue';
    yield object.itemsValue == null
        ? null
        : serializers.serialize(
            object.itemsValue,
            specifiedType: const FullType.nullable(String),
          );
    yield r'pickupLines';
    yield object.pickupLines == null
        ? null
        : serializers.serialize(
            object.pickupLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(
                AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
              ),
            ]),
          );
    yield r'commission';
    yield object.commission == null
        ? null
        : serializers.serialize(
            object.commission,
            specifiedType: const FullType.nullable(String),
          );
    yield r'discountShare';
    yield object.discountShare == null
        ? null
        : serializers.serialize(
            object.discountShare,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cause';
    yield object.cause == null
        ? null
        : serializers.serialize(
            object.cause,
            specifiedType: const FullType.nullable(
              AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum,
            ),
          );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'receiptId';
    yield object.receiptId == null
        ? null
        : serializers.serialize(
            object.receiptId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'receiptNumber';
    yield object.receiptNumber == null
        ? null
        : serializers.serialize(
            object.receiptNumber,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantPeriodStatementDtoOutputLinesInner object, {
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
    required AdminRestaurantPeriodStatementDtoOutputLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum,
                    ),
                  )
                  as AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
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
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.itemsValue = valueDes;
          break;
        case r'pickupLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(
                        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
                  >?;
          if (valueDes == null) continue;
          result.pickupLines.replace(valueDes);
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.commission = valueDes;
          break;
        case r'discountShare':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.discountShare = valueDes;
          break;
        case r'cause':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum,
                    ),
                  )
                  as AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum?;
          if (valueDes == null) continue;
          result.cause = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'receiptId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.receiptId = valueDes;
          break;
        case r'receiptNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.receiptNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantPeriodStatementDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantPeriodStatementDtoOutputLinesInnerBuilder();
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

class AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'order')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum order =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum_order;
  @BuiltValueEnumConst(wireName: r'exception')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum
  exception =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum_exception;
  @BuiltValueEnumConst(wireName: r'payment')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum
  payment = _$adminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum_payment;

  static Serializer<AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum>
  get serializer =>
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerKindEnumSerializer;

  const AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum>
  get values =>
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerKindEnumValues;
  static AdminRestaurantPeriodStatementDtoOutputLinesInnerKindEnum valueOf(
    String name,
  ) => _$adminRestaurantPeriodStatementDtoOutputLinesInnerKindEnumValueOf(name);
}

class AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'food_credit')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  foodCredit =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_foodCredit;
  @BuiltValueEnumConst(wireName: r'credit')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  credit = _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_credit;
  @BuiltValueEnumConst(wireName: r'pickup_refund')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  pickupRefund =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_pickupRefund;
  @BuiltValueEnumConst(wireName: r'pickup_kept')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  pickupKept =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_pickupKept;
  @BuiltValueEnumConst(wireName: r'items_removed')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  itemsRemoved =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_itemsRemoved;
  @BuiltValueEnumConst(wireName: r'fee_lowered')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  feeLowered =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_feeLowered;
  @BuiltValueEnumConst(wireName: r'fee_cut_returned')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  feeCutReturned =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_feeCutReturned;
  @BuiltValueEnumConst(wireName: r'debit')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  debit = _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_debit;
  @BuiltValueEnumConst(wireName: r'commission_reversal')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  commissionReversal =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_commissionReversal;
  @BuiltValueEnumConst(wireName: r'commission_restored')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  commissionRestored =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_commissionRestored;
  @BuiltValueEnumConst(wireName: r'discount_reversal')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  discountReversal =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_discountReversal;
  @BuiltValueEnumConst(wireName: r'outcome_changed')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  outcomeChanged =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_outcomeChanged;
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum
  adjustment =
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum_adjustment;

  static Serializer<AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum>
  get serializer =>
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnumSerializer;

  const AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum>
  get values =>
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnumValues;
  static AdminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnum valueOf(
    String name,
  ) =>
      _$adminRestaurantPeriodStatementDtoOutputLinesInnerCauseEnumValueOf(name);
}
