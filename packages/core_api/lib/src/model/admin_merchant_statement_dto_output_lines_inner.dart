//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_usage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_merchant_statement_dto_output_lines_inner.g.dart';

/// AdminMerchantStatementDtoOutputLinesInner
///
/// Properties:
/// * [position]
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
@BuiltValue()
abstract class AdminMerchantStatementDtoOutputLinesInner
    implements
        Built<
          AdminMerchantStatementDtoOutputLinesInner,
          AdminMerchantStatementDtoOutputLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'kind')
  AdminMerchantStatementDtoOutputLinesInnerKindEnum get kind;
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
  BuiltList<AdminDeskCustodyDtoOutputUsage>? get pickupLines;

  @BuiltValueField(wireName: r'commission')
  String? get commission;

  @BuiltValueField(wireName: r'discountShare')
  String? get discountShare;

  @BuiltValueField(wireName: r'cause')
  AdminMerchantStatementDtoOutputLinesInnerCauseEnum? get cause;
  // enum causeEnum {  food_credit,  credit,  pickup_refund,  items_removed,  debit,  commission_reversal,  discount_reversal,  adjustment,  };

  @BuiltValueField(wireName: r'amount')
  String? get amount;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminMerchantStatementDtoOutputLinesInner._();

  factory AdminMerchantStatementDtoOutputLinesInner([
    void updates(AdminMerchantStatementDtoOutputLinesInnerBuilder b),
  ]) = _$AdminMerchantStatementDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMerchantStatementDtoOutputLinesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMerchantStatementDtoOutputLinesInner> get serializer =>
      _$AdminMerchantStatementDtoOutputLinesInnerSerializer();
}

class _$AdminMerchantStatementDtoOutputLinesInnerSerializer
    implements PrimitiveSerializer<AdminMerchantStatementDtoOutputLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminMerchantStatementDtoOutputLinesInner,
    _$AdminMerchantStatementDtoOutputLinesInner,
  ];

  @override
  final String wireName = r'AdminMerchantStatementDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMerchantStatementDtoOutputLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminMerchantStatementDtoOutputLinesInnerKindEnum,
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
              FullType(AdminDeskCustodyDtoOutputUsage),
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
              AdminMerchantStatementDtoOutputLinesInnerCauseEnum,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMerchantStatementDtoOutputLinesInner object, {
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
    required AdminMerchantStatementDtoOutputLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMerchantStatementDtoOutputLinesInnerKindEnum,
                    ),
                  )
                  as AdminMerchantStatementDtoOutputLinesInnerKindEnum;
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
                      FullType(AdminDeskCustodyDtoOutputUsage),
                    ]),
                  )
                  as BuiltList<AdminDeskCustodyDtoOutputUsage>?;
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
                      AdminMerchantStatementDtoOutputLinesInnerCauseEnum,
                    ),
                  )
                  as AdminMerchantStatementDtoOutputLinesInnerCauseEnum?;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMerchantStatementDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMerchantStatementDtoOutputLinesInnerBuilder();
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

class AdminMerchantStatementDtoOutputLinesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'order')
  static const AdminMerchantStatementDtoOutputLinesInnerKindEnum order =
      _$adminMerchantStatementDtoOutputLinesInnerKindEnum_order;
  @BuiltValueEnumConst(wireName: r'exception')
  static const AdminMerchantStatementDtoOutputLinesInnerKindEnum exception =
      _$adminMerchantStatementDtoOutputLinesInnerKindEnum_exception;
  @BuiltValueEnumConst(wireName: r'payment')
  static const AdminMerchantStatementDtoOutputLinesInnerKindEnum payment =
      _$adminMerchantStatementDtoOutputLinesInnerKindEnum_payment;

  static Serializer<AdminMerchantStatementDtoOutputLinesInnerKindEnum>
  get serializer =>
      _$adminMerchantStatementDtoOutputLinesInnerKindEnumSerializer;

  const AdminMerchantStatementDtoOutputLinesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminMerchantStatementDtoOutputLinesInnerKindEnum>
  get values => _$adminMerchantStatementDtoOutputLinesInnerKindEnumValues;
  static AdminMerchantStatementDtoOutputLinesInnerKindEnum valueOf(
    String name,
  ) => _$adminMerchantStatementDtoOutputLinesInnerKindEnumValueOf(name);
}

class AdminMerchantStatementDtoOutputLinesInnerCauseEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'food_credit')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum foodCredit =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_foodCredit;
  @BuiltValueEnumConst(wireName: r'credit')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum credit =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_credit;
  @BuiltValueEnumConst(wireName: r'pickup_refund')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum pickupRefund =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_pickupRefund;
  @BuiltValueEnumConst(wireName: r'items_removed')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum itemsRemoved =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_itemsRemoved;
  @BuiltValueEnumConst(wireName: r'debit')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum debit =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_debit;
  @BuiltValueEnumConst(wireName: r'commission_reversal')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum
  commissionReversal =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_commissionReversal;
  @BuiltValueEnumConst(wireName: r'discount_reversal')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum
  discountReversal =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_discountReversal;
  @BuiltValueEnumConst(wireName: r'adjustment')
  static const AdminMerchantStatementDtoOutputLinesInnerCauseEnum adjustment =
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnum_adjustment;

  static Serializer<AdminMerchantStatementDtoOutputLinesInnerCauseEnum>
  get serializer =>
      _$adminMerchantStatementDtoOutputLinesInnerCauseEnumSerializer;

  const AdminMerchantStatementDtoOutputLinesInnerCauseEnum._(String name)
    : super(name);

  static BuiltSet<AdminMerchantStatementDtoOutputLinesInnerCauseEnum>
  get values => _$adminMerchantStatementDtoOutputLinesInnerCauseEnumValues;
  static AdminMerchantStatementDtoOutputLinesInnerCauseEnum valueOf(
    String name,
  ) => _$adminMerchantStatementDtoOutputLinesInnerCauseEnumValueOf(name);
}
