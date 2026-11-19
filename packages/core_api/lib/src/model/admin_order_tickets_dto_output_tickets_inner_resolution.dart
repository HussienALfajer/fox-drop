//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_affected_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_tickets_dto_output_tickets_inner_resolution.g.dart';

/// «محلولة»
///
/// Properties:
/// * [code]
/// * [responsible]
/// * [message] - Sent to the ticket's party.
/// * [correctedLines] - «تصحيح في الحسابات»: what the restaurant received, as corrected.
/// * [resolvedAt]
/// * [resolvedByName]
/// * [affectedLines] - A problem after delivery (AP §8.10): the affected lines as chosen.
/// * [affectedValue] - V, in `moneyCurrency`.
/// * [shortAmount] - «مشكلة في المبلغ أو الباقي»: M, what the customer was short.
/// * [moneyCurrency]
/// * [compensationId] - «كود تعويض»: the compensation asked (issued, or waiting for OWN).
@BuiltValue()
abstract class AdminOrderTicketsDtoOutputTicketsInnerResolution
    implements
        Built<
          AdminOrderTicketsDtoOutputTicketsInnerResolution,
          AdminOrderTicketsDtoOutputTicketsInnerResolutionBuilder
        > {
  @BuiltValueField(wireName: r'code')
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum get code;
  // enum codeEnum {  none_explained,  compensation_code,  free_redelivery,  price_corrected,  price_correct,  captain_paid,  accounts_corrected,  payment_correct,  appeal_accepted,  appeal_rejected,  };

  @BuiltValueField(wireName: r'responsible')
  AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum?
  get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// Sent to the ticket's party.
  @BuiltValueField(wireName: r'message')
  String get message;

  /// «تصحيح في الحسابات»: what the restaurant received, as corrected.
  @BuiltValueField(wireName: r'correctedLines')
  BuiltList<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  >?
  get correctedLines;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime get resolvedAt;

  @BuiltValueField(wireName: r'resolvedByName')
  String? get resolvedByName;

  /// A problem after delivery (AP §8.10): the affected lines as chosen.
  @BuiltValueField(wireName: r'affectedLines')
  BuiltList<AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner>?
  get affectedLines;

  /// V, in `moneyCurrency`.
  @BuiltValueField(wireName: r'affectedValue')
  String? get affectedValue;

  /// «مشكلة في المبلغ أو الباقي»: M, what the customer was short.
  @BuiltValueField(wireName: r'shortAmount')
  String? get shortAmount;

  @BuiltValueField(wireName: r'moneyCurrency')
  String? get moneyCurrency;

  /// «كود تعويض»: the compensation asked (issued, or waiting for OWN).
  @BuiltValueField(wireName: r'compensationId')
  String? get compensationId;

  AdminOrderTicketsDtoOutputTicketsInnerResolution._();

  factory AdminOrderTicketsDtoOutputTicketsInnerResolution([
    void updates(AdminOrderTicketsDtoOutputTicketsInnerResolutionBuilder b),
  ]) = _$AdminOrderTicketsDtoOutputTicketsInnerResolution;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerResolution>
  get serializer =>
      _$AdminOrderTicketsDtoOutputTicketsInnerResolutionSerializer();
}

class _$AdminOrderTicketsDtoOutputTicketsInnerResolutionSerializer
    implements
        PrimitiveSerializer<AdminOrderTicketsDtoOutputTicketsInnerResolution> {
  @override
  final Iterable<Type> types = const [
    AdminOrderTicketsDtoOutputTicketsInnerResolution,
    _$AdminOrderTicketsDtoOutputTicketsInnerResolution,
  ];

  @override
  final String wireName = r'AdminOrderTicketsDtoOutputTicketsInnerResolution';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerResolution object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(
        AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum,
      ),
    );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum,
            ),
          );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'correctedLines';
    yield object.correctedLines == null
        ? null
        : serializers.serialize(
            object.correctedLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(
                AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
              ),
            ]),
          );
    yield r'resolvedAt';
    yield serializers.serialize(
      object.resolvedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resolvedByName';
    yield object.resolvedByName == null
        ? null
        : serializers.serialize(
            object.resolvedByName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'affectedLines';
    yield object.affectedLines == null
        ? null
        : serializers.serialize(
            object.affectedLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(
                AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner,
              ),
            ]),
          );
    yield r'affectedValue';
    yield object.affectedValue == null
        ? null
        : serializers.serialize(
            object.affectedValue,
            specifiedType: const FullType.nullable(String),
          );
    yield r'shortAmount';
    yield object.shortAmount == null
        ? null
        : serializers.serialize(
            object.shortAmount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'moneyCurrency';
    yield object.moneyCurrency == null
        ? null
        : serializers.serialize(
            object.moneyCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'compensationId';
    yield object.compensationId == null
        ? null
        : serializers.serialize(
            object.compensationId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderTicketsDtoOutputTicketsInnerResolution object, {
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
    required AdminOrderTicketsDtoOutputTicketsInnerResolutionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum;
          result.code = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum?;
          if (valueDes == null) continue;
          result.responsible = valueDes;
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.message = valueDes;
          break;
        case r'correctedLines':
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
          result.correctedLines.replace(valueDes);
          break;
        case r'resolvedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.resolvedAt = valueDes;
          break;
        case r'resolvedByName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.resolvedByName = valueDes;
          break;
        case r'affectedLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(
                        AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
                  >?;
          if (valueDes == null) continue;
          result.affectedLines.replace(valueDes);
          break;
        case r'affectedValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.affectedValue = valueDes;
          break;
        case r'shortAmount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.shortAmount = valueDes;
          break;
        case r'moneyCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.moneyCurrency = valueDes;
          break;
        case r'compensationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.compensationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolution deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderTicketsDtoOutputTicketsInnerResolutionBuilder();
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

class AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none_explained')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  noneExplained =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_noneExplained;
  @BuiltValueEnumConst(wireName: r'compensation_code')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  compensationCode =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_compensationCode;
  @BuiltValueEnumConst(wireName: r'free_redelivery')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  freeRedelivery =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_freeRedelivery;
  @BuiltValueEnumConst(wireName: r'price_corrected')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  priceCorrected =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_priceCorrected;
  @BuiltValueEnumConst(wireName: r'price_correct')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  priceCorrect =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_priceCorrect;
  @BuiltValueEnumConst(wireName: r'captain_paid')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  captainPaid =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_captainPaid;
  @BuiltValueEnumConst(wireName: r'accounts_corrected')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  accountsCorrected =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_accountsCorrected;
  @BuiltValueEnumConst(wireName: r'payment_correct')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  paymentCorrect =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_paymentCorrect;
  @BuiltValueEnumConst(wireName: r'appeal_accepted')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  appealAccepted =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_appealAccepted;
  @BuiltValueEnumConst(wireName: r'appeal_rejected')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum
  appealRejected =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum_appealRejected;

  static Serializer<AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum>
  get serializer =>
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnumSerializer;

  const AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum>
  get values =>
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnumValues;
  static AdminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnum valueOf(
    String name,
  ) => _$adminOrderTicketsDtoOutputTicketsInnerResolutionCodeEnumValueOf(name);
}

class AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  restaurant =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  captain =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  customer =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  platform =
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum_platform;

  static Serializer<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  >
  get serializer =>
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnumSerializer;

  const AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  >
  get values =>
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnumValues;
  static AdminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnum
  valueOf(String name) =>
      _$adminOrderTicketsDtoOutputTicketsInnerResolutionResponsibleEnumValueOf(
        name,
      );
}
