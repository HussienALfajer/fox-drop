//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_block_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_compensation_requests_dto_output_requests_inner.g.dart';

/// AdminCompensationRequestsDtoOutputRequestsInner
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
abstract class AdminCompensationRequestsDtoOutputRequestsInner
    implements
        Built<
          AdminCompensationRequestsDtoOutputRequestsInner,
          AdminCompensationRequestsDtoOutputRequestsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'orderId')
  String get orderId;

  @BuiltValueField(wireName: r'orderNumber')
  String get orderNumber;

  @BuiltValueField(wireName: r'kind')
  AdminCompensationRequestsDtoOutputRequestsInnerKindEnum get kind;
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
  AdminCustomerDtoOutputBlockReasonsInner get reason;

  @BuiltValueField(wireName: r'note')
  String? get note;

  /// issued: the customer has the code; waiting: in «طلبات الموافقة»; rejected by OWN.
  @BuiltValueField(wireName: r'status')
  AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum get status;
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

  AdminCompensationRequestsDtoOutputRequestsInner._();

  factory AdminCompensationRequestsDtoOutputRequestsInner([
    void updates(AdminCompensationRequestsDtoOutputRequestsInnerBuilder b),
  ]) = _$AdminCompensationRequestsDtoOutputRequestsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCompensationRequestsDtoOutputRequestsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCompensationRequestsDtoOutputRequestsInner>
  get serializer =>
      _$AdminCompensationRequestsDtoOutputRequestsInnerSerializer();
}

class _$AdminCompensationRequestsDtoOutputRequestsInnerSerializer
    implements
        PrimitiveSerializer<AdminCompensationRequestsDtoOutputRequestsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCompensationRequestsDtoOutputRequestsInner,
    _$AdminCompensationRequestsDtoOutputRequestsInner,
  ];

  @override
  final String wireName = r'AdminCompensationRequestsDtoOutputRequestsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCompensationRequestsDtoOutputRequestsInner object, {
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
        AdminCompensationRequestsDtoOutputRequestsInnerKindEnum,
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
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(AdminCustomerDtoOutputBlockReasonsInner),
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
        AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum,
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
    AdminCompensationRequestsDtoOutputRequestsInner object, {
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
    required AdminCompensationRequestsDtoOutputRequestsInnerBuilder result,
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
                      AdminCompensationRequestsDtoOutputRequestsInnerKindEnum,
                    ),
                  )
                  as AdminCompensationRequestsDtoOutputRequestsInnerKindEnum;
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
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputBlockReasonsInner,
                    ),
                  )
                  as AdminCustomerDtoOutputBlockReasonsInner;
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
                      AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum,
                    ),
                  )
                  as AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum;
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
  AdminCompensationRequestsDtoOutputRequestsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCompensationRequestsDtoOutputRequestsInnerBuilder();
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

class AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
  fixedAmount =
      _$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum
  percentage =
      _$adminCompensationRequestsDtoOutputRequestsInnerKindEnum_percentage;

  static Serializer<AdminCompensationRequestsDtoOutputRequestsInnerKindEnum>
  get serializer =>
      _$adminCompensationRequestsDtoOutputRequestsInnerKindEnumSerializer;

  const AdminCompensationRequestsDtoOutputRequestsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCompensationRequestsDtoOutputRequestsInnerKindEnum>
  get values => _$adminCompensationRequestsDtoOutputRequestsInnerKindEnumValues;
  static AdminCompensationRequestsDtoOutputRequestsInnerKindEnum valueOf(
    String name,
  ) => _$adminCompensationRequestsDtoOutputRequestsInnerKindEnumValueOf(name);
}

/// issued: the customer has the code; waiting: in «طلبات الموافقة»; rejected by OWN.
class AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'issued')
  static const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
  issued = _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_issued;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
  waiting = _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum
  rejected =
      _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnum_rejected;

  static Serializer<AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum>
  get serializer =>
      _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnumSerializer;

  const AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum>
  get values =>
      _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnumValues;
  static AdminCompensationRequestsDtoOutputRequestsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCompensationRequestsDtoOutputRequestsInnerStatusEnumValueOf(name);
}
