//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account_dto_output_week_lines_inner.g.dart';

/// MerchantAccountDtoOutputWeekLinesInner
///
/// Properties:
/// * [day] - The business day on the city's clock.
/// * [kind]
/// * [at]
/// * [orderId]
/// * [orderNumber]
/// * [itemsValue] - Integer minor units of the city's base currency (AP §8.6).
/// * [commission] - Integer minor units of the city's base currency (AP §8.6).
/// * [discountShare] - Integer minor units of the city's base currency (AP §8.6).
/// * [cause] - An exception: what it is (RA §12.5).
/// * [amount] - Integer minor units of the city's base currency (AP §8.6).
/// * [reason]
/// * [decidedBy] - «من قرّر» on an exception (RA §12.5): who posted it.
/// * [decidedByName] - The FOX DROP staff member, by name.
@BuiltValue()
abstract class MerchantAccountDtoOutputWeekLinesInner
    implements
        Built<
          MerchantAccountDtoOutputWeekLinesInner,
          MerchantAccountDtoOutputWeekLinesInnerBuilder
        > {
  /// The business day on the city's clock.
  @BuiltValueField(wireName: r'day')
  Date get day;

  @BuiltValueField(wireName: r'kind')
  MerchantAccountDtoOutputWeekLinesInnerKindEnum get kind;
  // enum kindEnum {  order,  exception,  payment,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'orderId')
  String? get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String? get orderNumber;

  /// Integer minor units of the city's base currency (AP §8.6).
  @BuiltValueField(wireName: r'itemsValue')
  String? get itemsValue;

  /// Integer minor units of the city's base currency (AP §8.6).
  @BuiltValueField(wireName: r'commission')
  String? get commission;

  /// Integer minor units of the city's base currency (AP §8.6).
  @BuiltValueField(wireName: r'discountShare')
  String? get discountShare;

  /// An exception: what it is (RA §12.5).
  @BuiltValueField(wireName: r'cause')
  MerchantAccountDtoOutputWeekLinesInnerCauseEnum? get cause;
  // enum causeEnum {  food_credit,  credit,  pickup_refund,  pickup_kept,  items_removed,  fee_lowered,  fee_cut_returned,  debit,  commission_reversal,  commission_restored,  discount_reversal,  outcome_changed,  adjustment,  };

  /// Integer minor units of the city's base currency (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// «من قرّر» on an exception (RA §12.5): who posted it.
  @BuiltValueField(wireName: r'decidedBy')
  MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum? get decidedBy;
  // enum decidedByEnum {  admin,  merchant,  captain,  customer,  system,  };

  /// The FOX DROP staff member, by name.
  @BuiltValueField(wireName: r'decidedByName')
  String? get decidedByName;

  MerchantAccountDtoOutputWeekLinesInner._();

  factory MerchantAccountDtoOutputWeekLinesInner([
    void updates(MerchantAccountDtoOutputWeekLinesInnerBuilder b),
  ]) = _$MerchantAccountDtoOutputWeekLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountDtoOutputWeekLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccountDtoOutputWeekLinesInner> get serializer =>
      _$MerchantAccountDtoOutputWeekLinesInnerSerializer();
}

class _$MerchantAccountDtoOutputWeekLinesInnerSerializer
    implements PrimitiveSerializer<MerchantAccountDtoOutputWeekLinesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantAccountDtoOutputWeekLinesInner,
    _$MerchantAccountDtoOutputWeekLinesInner,
  ];

  @override
  final String wireName = r'MerchantAccountDtoOutputWeekLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccountDtoOutputWeekLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(Date),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        MerchantAccountDtoOutputWeekLinesInnerKindEnum,
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
              MerchantAccountDtoOutputWeekLinesInnerCauseEnum,
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
              MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum,
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
    MerchantAccountDtoOutputWeekLinesInner object, {
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
    required MerchantAccountDtoOutputWeekLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'day':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.day = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantAccountDtoOutputWeekLinesInnerKindEnum,
                    ),
                  )
                  as MerchantAccountDtoOutputWeekLinesInnerKindEnum;
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
                      MerchantAccountDtoOutputWeekLinesInnerCauseEnum,
                    ),
                  )
                  as MerchantAccountDtoOutputWeekLinesInnerCauseEnum?;
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
                      MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum,
                    ),
                  )
                  as MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum?;
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
  MerchantAccountDtoOutputWeekLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountDtoOutputWeekLinesInnerBuilder();
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

class MerchantAccountDtoOutputWeekLinesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'order')
  static const MerchantAccountDtoOutputWeekLinesInnerKindEnum order =
      _$merchantAccountDtoOutputWeekLinesInnerKindEnum_order;
  @BuiltValueEnumConst(wireName: r'exception')
  static const MerchantAccountDtoOutputWeekLinesInnerKindEnum exception =
      _$merchantAccountDtoOutputWeekLinesInnerKindEnum_exception;
  @BuiltValueEnumConst(wireName: r'payment')
  static const MerchantAccountDtoOutputWeekLinesInnerKindEnum payment =
      _$merchantAccountDtoOutputWeekLinesInnerKindEnum_payment;

  static Serializer<MerchantAccountDtoOutputWeekLinesInnerKindEnum>
  get serializer => _$merchantAccountDtoOutputWeekLinesInnerKindEnumSerializer;

  const MerchantAccountDtoOutputWeekLinesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<MerchantAccountDtoOutputWeekLinesInnerKindEnum> get values =>
      _$merchantAccountDtoOutputWeekLinesInnerKindEnumValues;
  static MerchantAccountDtoOutputWeekLinesInnerKindEnum valueOf(String name) =>
      _$merchantAccountDtoOutputWeekLinesInnerKindEnumValueOf(name);
}

/// An exception: what it is (RA §12.5).
class MerchantAccountDtoOutputWeekLinesInnerCauseEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'food_credit')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum foodCredit =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_foodCredit;
  @BuiltValueEnumConst(wireName: r'credit')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum credit =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_credit;
  @BuiltValueEnumConst(wireName: r'pickup_refund')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum pickupRefund =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_pickupRefund;
  @BuiltValueEnumConst(wireName: r'pickup_kept')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum pickupKept =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_pickupKept;
  @BuiltValueEnumConst(wireName: r'items_removed')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum itemsRemoved =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_itemsRemoved;
  @BuiltValueEnumConst(wireName: r'fee_lowered')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum feeLowered =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_feeLowered;
  @BuiltValueEnumConst(wireName: r'fee_cut_returned')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum feeCutReturned =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_feeCutReturned;
  @BuiltValueEnumConst(wireName: r'debit')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum debit =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_debit;
  @BuiltValueEnumConst(wireName: r'commission_reversal')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum
  commissionReversal =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_commissionReversal;
  @BuiltValueEnumConst(wireName: r'commission_restored')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum
  commissionRestored =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_commissionRestored;
  @BuiltValueEnumConst(wireName: r'discount_reversal')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum
  discountReversal =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_discountReversal;
  @BuiltValueEnumConst(wireName: r'outcome_changed')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum outcomeChanged =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_outcomeChanged;
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const MerchantAccountDtoOutputWeekLinesInnerCauseEnum adjustment =
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnum_adjustment;

  static Serializer<MerchantAccountDtoOutputWeekLinesInnerCauseEnum>
  get serializer => _$merchantAccountDtoOutputWeekLinesInnerCauseEnumSerializer;

  const MerchantAccountDtoOutputWeekLinesInnerCauseEnum._(String name)
    : super(name);

  static BuiltSet<MerchantAccountDtoOutputWeekLinesInnerCauseEnum> get values =>
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnumValues;
  static MerchantAccountDtoOutputWeekLinesInnerCauseEnum valueOf(String name) =>
      _$merchantAccountDtoOutputWeekLinesInnerCauseEnumValueOf(name);
}

/// «من قرّر» on an exception (RA §12.5): who posted it.
class MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum admin =
      _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnum_admin;
  @BuiltValueEnumConst(wireName: r'merchant')
  static const MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum merchant =
      _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnum_merchant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum captain =
      _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum customer =
      _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnum_customer;
  @BuiltValueEnumConst(wireName: r'system')
  static const MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum system =
      _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnum_system;

  static Serializer<MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum>
  get serializer =>
      _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnumSerializer;

  const MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum._(String name)
    : super(name);

  static BuiltSet<MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum>
  get values => _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnumValues;
  static MerchantAccountDtoOutputWeekLinesInnerDecidedByEnum valueOf(
    String name,
  ) => _$merchantAccountDtoOutputWeekLinesInnerDecidedByEnumValueOf(name);
}
