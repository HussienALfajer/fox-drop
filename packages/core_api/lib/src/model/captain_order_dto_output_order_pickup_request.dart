//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_pickup_request_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output_order_pickup_request.g.dart';

/// A pickup request (RA §8.10).
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [outcome] - confirmed: «تم الاستلام», or «أكّدت العمليات الاستلام» for operations; rejected: amount_incorrect «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.», incomplete «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»
/// * [amount] 
/// * [lines] - The lines the captain paid.
/// * [receivedLines] - What the restaurant says it received, on «المبلغ غير صحيح».
/// * [openedAt] 
/// * [confirmBy] - «بانتظار تأكيد المطعم» counts down to it while open (CA §9.4).
/// * [closedAt] 
@BuiltValue()
abstract class CaptainOrderDtoOutputOrderPickupRequest implements Built<CaptainOrderDtoOutputOrderPickupRequest, CaptainOrderDtoOutputOrderPickupRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  CaptainOrderDtoOutputOrderPickupRequestStatusEnum get status;
  // enum statusEnum {  open,  confirmed,  rejected,  voided,  };

  /// confirmed: «تم الاستلام», or «أكّدت العمليات الاستلام» for operations; rejected: amount_incorrect «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.», incomplete «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»
  @BuiltValueField(wireName: r'outcome')
  CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum? get outcome;
  // enum outcomeEnum {  restaurant,  automatic,  operations,  amount_incorrect,  incomplete,  cancelled,  };

  @BuiltValueField(wireName: r'amount')
  CaptainActiveOrderDtoOutputOrderPickupRequestAmount get amount;

  /// The lines the captain paid.
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get lines;

  /// What the restaurant says it received, on «المبلغ غير صحيح».
  @BuiltValueField(wireName: r'receivedLines')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? get receivedLines;

  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  /// «بانتظار تأكيد المطعم» counts down to it while open (CA §9.4).
  @BuiltValueField(wireName: r'confirmBy')
  DateTime get confirmBy;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  CaptainOrderDtoOutputOrderPickupRequest._();

  factory CaptainOrderDtoOutputOrderPickupRequest([void updates(CaptainOrderDtoOutputOrderPickupRequestBuilder b)]) = _$CaptainOrderDtoOutputOrderPickupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputOrderPickupRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutputOrderPickupRequest> get serializer => _$CaptainOrderDtoOutputOrderPickupRequestSerializer();
}

class _$CaptainOrderDtoOutputOrderPickupRequestSerializer implements PrimitiveSerializer<CaptainOrderDtoOutputOrderPickupRequest> {
  @override
  final Iterable<Type> types = const [CaptainOrderDtoOutputOrderPickupRequest, _$CaptainOrderDtoOutputOrderPickupRequest];

  @override
  final String wireName = r'CaptainOrderDtoOutputOrderPickupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutputOrderPickupRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CaptainOrderDtoOutputOrderPickupRequestStatusEnum),
    );
    yield r'outcome';
    yield object.outcome == null ? null : serializers.serialize(
      object.outcome,
      specifiedType: const FullType.nullable(CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderPickupRequestAmount),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
    );
    yield r'receivedLines';
    yield object.receivedLines == null ? null : serializers.serialize(
      object.receivedLines,
      specifiedType: const FullType.nullable(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'confirmBy';
    yield serializers.serialize(
      object.confirmBy,
      specifiedType: const FullType(DateTime),
    );
    yield r'closedAt';
    yield object.closedAt == null ? null : serializers.serialize(
      object.closedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrderPickupRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainOrderDtoOutputOrderPickupRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainOrderDtoOutputOrderPickupRequestStatusEnum),
          ) as CaptainOrderDtoOutputOrderPickupRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum),
          ) as CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainActiveOrderDtoOutputOrderPickupRequestAmount),
          ) as CaptainActiveOrderDtoOutputOrderPickupRequestAmount;
          result.amount.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.lines.replace(valueDes);
          break;
        case r'receivedLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>?;
          if (valueDes == null) continue;
          result.receivedLines.replace(valueDes);
          break;
        case r'openedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.openedAt = valueDes;
          break;
        case r'confirmBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.confirmBy = valueDes;
          break;
        case r'closedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderDtoOutputOrderPickupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputOrderPickupRequestBuilder();
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


class CaptainOrderDtoOutputOrderPickupRequestStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'open')
  static const CaptainOrderDtoOutputOrderPickupRequestStatusEnum open = _$captainOrderDtoOutputOrderPickupRequestStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const CaptainOrderDtoOutputOrderPickupRequestStatusEnum confirmed = _$captainOrderDtoOutputOrderPickupRequestStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainOrderDtoOutputOrderPickupRequestStatusEnum rejected = _$captainOrderDtoOutputOrderPickupRequestStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'voided')
  static const CaptainOrderDtoOutputOrderPickupRequestStatusEnum voided = _$captainOrderDtoOutputOrderPickupRequestStatusEnum_voided;

  static Serializer<CaptainOrderDtoOutputOrderPickupRequestStatusEnum> get serializer => _$captainOrderDtoOutputOrderPickupRequestStatusEnumSerializer;

  const CaptainOrderDtoOutputOrderPickupRequestStatusEnum._(String name): super(name);

  static BuiltSet<CaptainOrderDtoOutputOrderPickupRequestStatusEnum> get values => _$captainOrderDtoOutputOrderPickupRequestStatusEnumValues;
  static CaptainOrderDtoOutputOrderPickupRequestStatusEnum valueOf(String name) => _$captainOrderDtoOutputOrderPickupRequestStatusEnumValueOf(name);
}

/// confirmed: «تم الاستلام», or «أكّدت العمليات الاستلام» for operations; rejected: amount_incorrect «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.», incomplete «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»
class CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'restaurant')
  static const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum restaurant = _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum automatic = _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum operations = _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_operations;
  @BuiltValueEnumConst(wireName: r'amount_incorrect')
  static const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum amountIncorrect = _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
  @BuiltValueEnumConst(wireName: r'incomplete')
  static const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum incomplete = _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum cancelled = _$captainOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled;

  static Serializer<CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum> get serializer => _$captainOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer;

  const CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum._(String name): super(name);

  static BuiltSet<CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum> get values => _$captainOrderDtoOutputOrderPickupRequestOutcomeEnumValues;
  static CaptainOrderDtoOutputOrderPickupRequestOutcomeEnum valueOf(String name) => _$captainOrderDtoOutputOrderPickupRequestOutcomeEnumValueOf(name);
}

