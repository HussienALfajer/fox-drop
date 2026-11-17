//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_ticket_correction_preview_dto_received_lines_inner.dart';
import 'package:core_api/src/model/admin_ticket_resolve_dto_code.dart';
import 'package:core_api/src/model/admin_ticket_money_preview_body_dto_affected_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_resolve_dto.g.dart';

/// AdminTicketResolveDto
///
/// Properties:
/// * [cityId]
/// * [resolution] - From the ticket kind's (AP §9.9.3).
/// * [responsible] - Required for a general ticket; none for a price difference or a pickup dispute.
/// * [message] - Sent to the ticket's party.
/// * [receivedLines] - The lines the restaurant received, one per currency.
/// * [affected] - A problem after delivery: the affected lines (V).
/// * [shortAmount] - «مشكلة في المبلغ أو الباقي»: M, what the customer was short.
/// * [code]
/// * [chargePay] - «إعادة توصيل مجانية»: its captain's pay charged to the responsible restaurant or captain.
@BuiltValue()
abstract class AdminTicketResolveDto
    implements Built<AdminTicketResolveDto, AdminTicketResolveDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// From the ticket kind's (AP §9.9.3).
  @BuiltValueField(wireName: r'resolution')
  AdminTicketResolveDtoResolutionEnum get resolution;
  // enum resolutionEnum {  none_explained,  compensation_code,  free_redelivery,  price_corrected,  price_correct,  captain_paid,  accounts_corrected,  payment_correct,  };

  /// Required for a general ticket; none for a price difference or a pickup dispute.
  @BuiltValueField(wireName: r'responsible')
  AdminTicketResolveDtoResponsibleEnum? get responsible;
  // enum responsibleEnum {  restaurant,  captain,  customer,  platform,  };

  /// Sent to the ticket's party.
  @BuiltValueField(wireName: r'message')
  String get message;

  /// The lines the restaurant received, one per currency.
  @BuiltValueField(wireName: r'receivedLines')
  BuiltList<AdminTicketCorrectionPreviewDtoReceivedLinesInner>?
  get receivedLines;

  /// A problem after delivery: the affected lines (V).
  @BuiltValueField(wireName: r'affected')
  BuiltList<AdminTicketMoneyPreviewBodyDtoAffectedInner>? get affected;

  /// «مشكلة في المبلغ أو الباقي»: M, what the customer was short.
  @BuiltValueField(wireName: r'shortAmount')
  String? get shortAmount;

  @BuiltValueField(wireName: r'code')
  AdminTicketResolveDtoCode? get code;

  /// «إعادة توصيل مجانية»: its captain's pay charged to the responsible restaurant or captain.
  @BuiltValueField(wireName: r'chargePay')
  bool? get chargePay;

  AdminTicketResolveDto._();

  factory AdminTicketResolveDto([
    void updates(AdminTicketResolveDtoBuilder b),
  ]) = _$AdminTicketResolveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketResolveDtoBuilder b) => b
    ..affected = ListBuilder()
    ..chargePay = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketResolveDto> get serializer =>
      _$AdminTicketResolveDtoSerializer();
}

class _$AdminTicketResolveDtoSerializer
    implements PrimitiveSerializer<AdminTicketResolveDto> {
  @override
  final Iterable<Type> types = const [
    AdminTicketResolveDto,
    _$AdminTicketResolveDto,
  ];

  @override
  final String wireName = r'AdminTicketResolveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketResolveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'resolution';
    yield serializers.serialize(
      object.resolution,
      specifiedType: const FullType(AdminTicketResolveDtoResolutionEnum),
    );
    yield r'responsible';
    yield object.responsible == null
        ? null
        : serializers.serialize(
            object.responsible,
            specifiedType: const FullType.nullable(
              AdminTicketResolveDtoResponsibleEnum,
            ),
          );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'receivedLines';
    yield object.receivedLines == null
        ? null
        : serializers.serialize(
            object.receivedLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(AdminTicketCorrectionPreviewDtoReceivedLinesInner),
            ]),
          );
    if (object.affected != null) {
      yield r'affected';
      yield serializers.serialize(
        object.affected,
        specifiedType: const FullType(BuiltList, [
          FullType(AdminTicketMoneyPreviewBodyDtoAffectedInner),
        ]),
      );
    }
    if (object.shortAmount != null) {
      yield r'shortAmount';
      yield serializers.serialize(
        object.shortAmount,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(AdminTicketResolveDtoCode),
      );
    }
    if (object.chargePay != null) {
      yield r'chargePay';
      yield serializers.serialize(
        object.chargePay,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketResolveDto object, {
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
    required AdminTicketResolveDtoBuilder result,
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
        case r'resolution':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminTicketResolveDtoResolutionEnum,
                    ),
                  )
                  as AdminTicketResolveDtoResolutionEnum;
          result.resolution = valueDes;
          break;
        case r'responsible':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketResolveDtoResponsibleEnum,
                    ),
                  )
                  as AdminTicketResolveDtoResponsibleEnum?;
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
        case r'receivedLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(
                        AdminTicketCorrectionPreviewDtoReceivedLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminTicketCorrectionPreviewDtoReceivedLinesInner
                  >?;
          if (valueDes == null) continue;
          result.receivedLines.replace(valueDes);
          break;
        case r'affected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(AdminTicketMoneyPreviewBodyDtoAffectedInner),
                    ]),
                  )
                  as BuiltList<AdminTicketMoneyPreviewBodyDtoAffectedInner>?;
          if (valueDes == null) continue;
          result.affected.replace(valueDes);
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketResolveDtoCode,
                    ),
                  )
                  as AdminTicketResolveDtoCode?;
          if (valueDes == null) continue;
          result.code.replace(valueDes);
          break;
        case r'chargePay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.chargePay = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketResolveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketResolveDtoBuilder();
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

/// From the ticket kind's (AP §9.9.3).
class AdminTicketResolveDtoResolutionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none_explained')
  static const AdminTicketResolveDtoResolutionEnum noneExplained =
      _$adminTicketResolveDtoResolutionEnum_noneExplained;
  @BuiltValueEnumConst(wireName: r'compensation_code')
  static const AdminTicketResolveDtoResolutionEnum compensationCode =
      _$adminTicketResolveDtoResolutionEnum_compensationCode;
  @BuiltValueEnumConst(wireName: r'free_redelivery')
  static const AdminTicketResolveDtoResolutionEnum freeRedelivery =
      _$adminTicketResolveDtoResolutionEnum_freeRedelivery;
  @BuiltValueEnumConst(wireName: r'price_corrected')
  static const AdminTicketResolveDtoResolutionEnum priceCorrected =
      _$adminTicketResolveDtoResolutionEnum_priceCorrected;
  @BuiltValueEnumConst(wireName: r'price_correct')
  static const AdminTicketResolveDtoResolutionEnum priceCorrect =
      _$adminTicketResolveDtoResolutionEnum_priceCorrect;
  @BuiltValueEnumConst(wireName: r'captain_paid')
  static const AdminTicketResolveDtoResolutionEnum captainPaid =
      _$adminTicketResolveDtoResolutionEnum_captainPaid;
  @BuiltValueEnumConst(wireName: r'accounts_corrected')
  static const AdminTicketResolveDtoResolutionEnum accountsCorrected =
      _$adminTicketResolveDtoResolutionEnum_accountsCorrected;
  @BuiltValueEnumConst(wireName: r'payment_correct')
  static const AdminTicketResolveDtoResolutionEnum paymentCorrect =
      _$adminTicketResolveDtoResolutionEnum_paymentCorrect;

  static Serializer<AdminTicketResolveDtoResolutionEnum> get serializer =>
      _$adminTicketResolveDtoResolutionEnumSerializer;

  const AdminTicketResolveDtoResolutionEnum._(String name) : super(name);

  static BuiltSet<AdminTicketResolveDtoResolutionEnum> get values =>
      _$adminTicketResolveDtoResolutionEnumValues;
  static AdminTicketResolveDtoResolutionEnum valueOf(String name) =>
      _$adminTicketResolveDtoResolutionEnumValueOf(name);
}

/// Required for a general ticket; none for a price difference or a pickup dispute.
class AdminTicketResolveDtoResponsibleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminTicketResolveDtoResponsibleEnum restaurant =
      _$adminTicketResolveDtoResponsibleEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminTicketResolveDtoResponsibleEnum captain =
      _$adminTicketResolveDtoResponsibleEnum_captain;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminTicketResolveDtoResponsibleEnum customer =
      _$adminTicketResolveDtoResponsibleEnum_customer;
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminTicketResolveDtoResponsibleEnum platform =
      _$adminTicketResolveDtoResponsibleEnum_platform;

  static Serializer<AdminTicketResolveDtoResponsibleEnum> get serializer =>
      _$adminTicketResolveDtoResponsibleEnumSerializer;

  const AdminTicketResolveDtoResponsibleEnum._(String name) : super(name);

  static BuiltSet<AdminTicketResolveDtoResponsibleEnum> get values =>
      _$adminTicketResolveDtoResponsibleEnumValues;
  static AdminTicketResolveDtoResponsibleEnum valueOf(String name) =>
      _$adminTicketResolveDtoResponsibleEnumValueOf(name);
}
