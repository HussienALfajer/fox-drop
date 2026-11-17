//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_note.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_compensations_dto_output_compensations_inner.g.dart';

/// AdminOrderCompensationsDtoOutputCompensationsInner
///
/// Properties:
/// * [id]
/// * [orderId]
/// * [orderNumber]
/// * [kind]
/// * [amount]
/// * [percentBp]
/// * [maxDiscount]
/// * [currency]
/// * [reason]
/// * [note]
/// * [status] - issued: the customer has the code; waiting: in «طلبات الموافقة»; rejected by OWN.
/// * [requestedBy] - The admin's name, null when they have none.
/// * [requestedAt]
/// * [decidedBy]
/// * [decidedAt]
/// * [code] - The personal code once issued.
/// * [codeValidTo]
@BuiltValue()
abstract class AdminOrderCompensationsDtoOutputCompensationsInner
    implements
        Built<
          AdminOrderCompensationsDtoOutputCompensationsInner,
          AdminOrderCompensationsDtoOutputCompensationsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String get orderNumber;

  @BuiltValueField(wireName: r'kind')
  AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum get kind;
  // enum kindEnum {  fixed_amount,  percentage,  };

  @BuiltValueField(wireName: r'amount')
  String? get amount;

  @BuiltValueField(wireName: r'percentBp')
  int? get percentBp;

  @BuiltValueField(wireName: r'maxDiscount')
  String? get maxDiscount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'reason')
  MerchantOrdersDtoOutputOrdersInnerItemReportNote? get reason;

  @BuiltValueField(wireName: r'note')
  String? get note;

  /// issued: the customer has the code; waiting: in «طلبات الموافقة»; rejected by OWN.
  @BuiltValueField(wireName: r'status')
  AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum get status;
  // enum statusEnum {  issued,  waiting,  rejected,  };

  /// The admin's name, null when they have none.
  @BuiltValueField(wireName: r'requestedBy')
  String? get requestedBy;

  @BuiltValueField(wireName: r'requestedAt')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'decidedBy')
  String? get decidedBy;

  @BuiltValueField(wireName: r'decidedAt')
  DateTime? get decidedAt;

  /// The personal code once issued.
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'codeValidTo')
  DateTime? get codeValidTo;

  AdminOrderCompensationsDtoOutputCompensationsInner._();

  factory AdminOrderCompensationsDtoOutputCompensationsInner([
    void updates(AdminOrderCompensationsDtoOutputCompensationsInnerBuilder b),
  ]) = _$AdminOrderCompensationsDtoOutputCompensationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderCompensationsDtoOutputCompensationsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCompensationsDtoOutputCompensationsInner>
  get serializer =>
      _$AdminOrderCompensationsDtoOutputCompensationsInnerSerializer();
}

class _$AdminOrderCompensationsDtoOutputCompensationsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminOrderCompensationsDtoOutputCompensationsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminOrderCompensationsDtoOutputCompensationsInner,
    _$AdminOrderCompensationsDtoOutputCompensationsInner,
  ];

  @override
  final String wireName = r'AdminOrderCompensationsDtoOutputCompensationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCompensationsDtoOutputCompensationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'orderId';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'orderNumber';
    yield serializers.serialize(
      object.orderNumber,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum,
      ),
    );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'percentBp';
    yield object.percentBp == null
        ? null
        : serializers.serialize(
            object.percentBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'maxDiscount';
    yield object.maxDiscount == null
        ? null
        : serializers.serialize(
            object.maxDiscount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(
              MerchantOrdersDtoOutputOrdersInnerItemReportNote,
            ),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum,
      ),
    );
    yield r'requestedBy';
    yield object.requestedBy == null
        ? null
        : serializers.serialize(
            object.requestedBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'requestedAt';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'decidedBy';
    yield object.decidedBy == null
        ? null
        : serializers.serialize(
            object.decidedBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'decidedAt';
    yield object.decidedAt == null
        ? null
        : serializers.serialize(
            object.decidedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
    yield r'codeValidTo';
    yield object.codeValidTo == null
        ? null
        : serializers.serialize(
            object.codeValidTo,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCompensationsDtoOutputCompensationsInner object, {
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
    required AdminOrderCompensationsDtoOutputCompensationsInnerBuilder result,
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
        case r'orderId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderId = valueDes;
          break;
        case r'orderNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.orderNumber = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum,
                    ),
                  )
                  as AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum;
          result.kind = valueDes;
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
        case r'percentBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.percentBp = valueDes;
          break;
        case r'maxDiscount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantOrdersDtoOutputOrdersInnerItemReportNote,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInnerItemReportNote?;
          if (valueDes == null) continue;
          result.reason.replace(valueDes);
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum,
                    ),
                  )
                  as AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'requestedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.requestedBy = valueDes;
          break;
        case r'requestedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'decidedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.decidedBy = valueDes;
          break;
        case r'decidedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
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
        case r'codeValidTo':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.codeValidTo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCompensationsDtoOutputCompensationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCompensationsDtoOutputCompensationsInnerBuilder();
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

class AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
  fixedAmount =
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum
  percentage =
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnum_percentage;

  static Serializer<AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum>
  get serializer =>
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnumSerializer;

  const AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum>
  get values =>
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnumValues;
  static AdminOrderCompensationsDtoOutputCompensationsInnerKindEnum valueOf(
    String name,
  ) =>
      _$adminOrderCompensationsDtoOutputCompensationsInnerKindEnumValueOf(name);
}

/// issued: the customer has the code; waiting: in «طلبات الموافقة»; rejected by OWN.
class AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'issued')
  static const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
  issued =
      _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_issued;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
  waiting =
      _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
  rejected =
      _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnum_rejected;

  static Serializer<
    AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum
  >
  get serializer =>
      _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnumSerializer;

  const AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum>
  get values =>
      _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnumValues;
  static AdminOrderCompensationsDtoOutputCompensationsInnerStatusEnum valueOf(
    String name,
  ) => _$adminOrderCompensationsDtoOutputCompensationsInnerStatusEnumValueOf(
    name,
  );
}
