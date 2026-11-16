//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_statement_dto_output_lines_inner_pickup_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_statement_dto_output_lines_inner.g.dart';

/// MerchantStatementDtoOutputLinesInner
///
/// Properties:
/// * [kind]
/// * [at]
/// * [orderId]
/// * [orderNumber]
/// * [itemsValue] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [pickupLines] - An order: the currency lines the captain paid.
/// * [commission] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [discountShare] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [cause] - An exception (RA §12.5).
/// * [amount] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [reason]
/// * [decidedBy] - «من قرّر» on an exception (RA §12.5): who posted it.
/// * [decidedByName] - The FOX DROP staff member, by name.
@BuiltValue()
abstract class MerchantStatementDtoOutputLinesInner
    implements
        Built<
          MerchantStatementDtoOutputLinesInner,
          MerchantStatementDtoOutputLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  MerchantStatementDtoOutputLinesInnerKindEnum get kind;
  // enum kindEnum {  order,  exception,  payment,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'itemsValue')
  String? get itemsValue;

  /// An order: the currency lines the captain paid.
  @BuiltValueField(wireName: r'pickupLines')
  BuiltList<MerchantStatementDtoOutputLinesInnerPickupLinesInner>?
  get pickupLines;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'commission')
  String? get commission;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'discountShare')
  String? get discountShare;

  /// An exception (RA §12.5).
  @BuiltValueField(wireName: r'cause')
  MerchantStatementDtoOutputLinesInnerCauseEnum? get cause;
  // enum causeEnum {  food_credit,  credit,  pickup_refund,  pickup_kept,  items_removed,  fee_lowered,  fee_cut_returned,  debit,  commission_reversal,  commission_restored,  discount_reversal,  outcome_changed,  adjustment,  };

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// «من قرّر» on an exception (RA §12.5): who posted it.
  @BuiltValueField(wireName: r'decidedBy')
  MerchantStatementDtoOutputLinesInnerDecidedByEnum? get decidedBy;
  // enum decidedByEnum {  admin,  merchant,  captain,  customer,  system,  };

  /// The FOX DROP staff member, by name.
  @BuiltValueField(wireName: r'decidedByName')
  String? get decidedByName;

  MerchantStatementDtoOutputLinesInner._();

  factory MerchantStatementDtoOutputLinesInner([
    void updates(MerchantStatementDtoOutputLinesInnerBuilder b),
  ]) = _$MerchantStatementDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatementDtoOutputLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatementDtoOutputLinesInner> get serializer =>
      _$MerchantStatementDtoOutputLinesInnerSerializer();
}

class _$MerchantStatementDtoOutputLinesInnerSerializer
    implements PrimitiveSerializer<MerchantStatementDtoOutputLinesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantStatementDtoOutputLinesInner,
    _$MerchantStatementDtoOutputLinesInner,
  ];

  @override
  final String wireName = r'MerchantStatementDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatementDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        MerchantStatementDtoOutputLinesInnerKindEnum,
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
              FullType(MerchantStatementDtoOutputLinesInnerPickupLinesInner),
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
              MerchantStatementDtoOutputLinesInnerCauseEnum,
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
    yield r'decidedBy';
    yield object.decidedBy == null
        ? null
        : serializers.serialize(
            object.decidedBy,
            specifiedType: const FullType.nullable(
              MerchantStatementDtoOutputLinesInnerDecidedByEnum,
            ),
          );
    yield r'decidedByName';
    yield object.decidedByName == null
        ? null
        : serializers.serialize(
            object.decidedByName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementDtoOutputLinesInner object, {
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
    required MerchantStatementDtoOutputLinesInnerBuilder result,
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
                      MerchantStatementDtoOutputLinesInnerKindEnum,
                    ),
                  )
                  as MerchantStatementDtoOutputLinesInnerKindEnum;
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
                        MerchantStatementDtoOutputLinesInnerPickupLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantStatementDtoOutputLinesInnerPickupLinesInner
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
                      MerchantStatementDtoOutputLinesInnerCauseEnum,
                    ),
                  )
                  as MerchantStatementDtoOutputLinesInnerCauseEnum?;
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
        case r'decidedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatementDtoOutputLinesInnerDecidedByEnum,
                    ),
                  )
                  as MerchantStatementDtoOutputLinesInnerDecidedByEnum?;
          if (valueDes == null) continue;
          result.decidedBy = valueDes;
          break;
        case r'decidedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.decidedByName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatementDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatementDtoOutputLinesInnerBuilder();
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

class MerchantStatementDtoOutputLinesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'order')
  static const MerchantStatementDtoOutputLinesInnerKindEnum order =
      _$merchantStatementDtoOutputLinesInnerKindEnum_order;
  @BuiltValueEnumConst(wireName: r'exception')
  static const MerchantStatementDtoOutputLinesInnerKindEnum exception =
      _$merchantStatementDtoOutputLinesInnerKindEnum_exception;
  @BuiltValueEnumConst(wireName: r'payment')
  static const MerchantStatementDtoOutputLinesInnerKindEnum payment =
      _$merchantStatementDtoOutputLinesInnerKindEnum_payment;

  static Serializer<MerchantStatementDtoOutputLinesInnerKindEnum>
  get serializer => _$merchantStatementDtoOutputLinesInnerKindEnumSerializer;

  const MerchantStatementDtoOutputLinesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<MerchantStatementDtoOutputLinesInnerKindEnum> get values =>
      _$merchantStatementDtoOutputLinesInnerKindEnumValues;
  static MerchantStatementDtoOutputLinesInnerKindEnum valueOf(String name) =>
      _$merchantStatementDtoOutputLinesInnerKindEnumValueOf(name);
}

/// An exception (RA §12.5).
class MerchantStatementDtoOutputLinesInnerCauseEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'food_credit')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum foodCredit =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_foodCredit;
  @BuiltValueEnumConst(wireName: r'credit')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum credit =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_credit;
  @BuiltValueEnumConst(wireName: r'pickup_refund')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum pickupRefund =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_pickupRefund;
  @BuiltValueEnumConst(wireName: r'pickup_kept')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum pickupKept =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_pickupKept;
  @BuiltValueEnumConst(wireName: r'items_removed')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum itemsRemoved =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_itemsRemoved;
  @BuiltValueEnumConst(wireName: r'fee_lowered')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum feeLowered =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_feeLowered;
  @BuiltValueEnumConst(wireName: r'fee_cut_returned')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum feeCutReturned =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_feeCutReturned;
  @BuiltValueEnumConst(wireName: r'debit')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum debit =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_debit;
  @BuiltValueEnumConst(wireName: r'commission_reversal')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum
  commissionReversal =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_commissionReversal;
  @BuiltValueEnumConst(wireName: r'commission_restored')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum
  commissionRestored =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_commissionRestored;
  @BuiltValueEnumConst(wireName: r'discount_reversal')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum discountReversal =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_discountReversal;
  @BuiltValueEnumConst(wireName: r'outcome_changed')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum outcomeChanged =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_outcomeChanged;
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const MerchantStatementDtoOutputLinesInnerCauseEnum adjustment =
      _$merchantStatementDtoOutputLinesInnerCauseEnum_adjustment;

  static Serializer<MerchantStatementDtoOutputLinesInnerCauseEnum>
  get serializer => _$merchantStatementDtoOutputLinesInnerCauseEnumSerializer;

  const MerchantStatementDtoOutputLinesInnerCauseEnum._(String name)
    : super(name);

  static BuiltSet<MerchantStatementDtoOutputLinesInnerCauseEnum> get values =>
      _$merchantStatementDtoOutputLinesInnerCauseEnumValues;
  static MerchantStatementDtoOutputLinesInnerCauseEnum valueOf(String name) =>
      _$merchantStatementDtoOutputLinesInnerCauseEnumValueOf(name);
}

/// «من قرّر» on an exception (RA §12.5): who posted it.
class MerchantStatementDtoOutputLinesInnerDecidedByEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const MerchantStatementDtoOutputLinesInnerDecidedByEnum admin =
      _$merchantStatementDtoOutputLinesInnerDecidedByEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const MerchantStatementDtoOutputLinesInnerDecidedByEnum merchant =
      _$merchantStatementDtoOutputLinesInnerDecidedByEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const MerchantStatementDtoOutputLinesInnerDecidedByEnum captain =
      _$merchantStatementDtoOutputLinesInnerDecidedByEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const MerchantStatementDtoOutputLinesInnerDecidedByEnum customer =
      _$merchantStatementDtoOutputLinesInnerDecidedByEnum_customer;
  @BuiltValueEnumConst(wireName: r'system')
  static const MerchantStatementDtoOutputLinesInnerDecidedByEnum system =
      _$merchantStatementDtoOutputLinesInnerDecidedByEnum_system;

  static Serializer<MerchantStatementDtoOutputLinesInnerDecidedByEnum>
  get serializer =>
      _$merchantStatementDtoOutputLinesInnerDecidedByEnumSerializer;

  const MerchantStatementDtoOutputLinesInnerDecidedByEnum._(String name)
    : super(name);

  static BuiltSet<MerchantStatementDtoOutputLinesInnerDecidedByEnum>
  get values => _$merchantStatementDtoOutputLinesInnerDecidedByEnumValues;
  static MerchantStatementDtoOutputLinesInnerDecidedByEnum valueOf(
    String name,
  ) => _$merchantStatementDtoOutputLinesInnerDecidedByEnumValueOf(name);
}
