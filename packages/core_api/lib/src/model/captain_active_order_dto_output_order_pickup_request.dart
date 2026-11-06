//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_pickup_request_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_pickup_request.g.dart';

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
abstract class CaptainActiveOrderDtoOutputOrderPickupRequest
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderPickupRequest,
          CaptainActiveOrderDtoOutputOrderPickupRequestBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum get status;
  // enum statusEnum {  open,  confirmed,  rejected,  voided,  };

  /// confirmed: «تم الاستلام», or «أكّدت العمليات الاستلام» for operations; rejected: amount_incorrect «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.», incomplete «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»
  @BuiltValueField(wireName: r'outcome')
  CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum? get outcome;
  // enum outcomeEnum {  restaurant,  automatic,  operations,  amount_incorrect,  incomplete,  cancelled,  };

  @BuiltValueField(wireName: r'amount')
  CaptainActiveOrderDtoOutputOrderPickupRequestAmount get amount;

  /// The lines the captain paid.
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get lines;

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

  CaptainActiveOrderDtoOutputOrderPickupRequest._();

  factory CaptainActiveOrderDtoOutputOrderPickupRequest([
    void updates(CaptainActiveOrderDtoOutputOrderPickupRequestBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderPickupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderPickupRequestBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderPickupRequest>
  get serializer => _$CaptainActiveOrderDtoOutputOrderPickupRequestSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderPickupRequestSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderPickupRequest> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderPickupRequest,
    _$CaptainActiveOrderDtoOutputOrderPickupRequest,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderPickupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickupRequest object, {
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
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum,
      ),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum,
            ),
          );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderPickupRequestAmount,
      ),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
      ]),
    );
    yield r'receivedLines';
    yield object.receivedLines == null
        ? null
        : serializers.serialize(
            object.receivedLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
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
    yield object.closedAt == null
        ? null
        : serializers.serialize(
            object.closedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickupRequest object, {
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
    required CaptainActiveOrderDtoOutputOrderPickupRequestBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderPickupRequestAmount,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderPickupRequestAmount;
          result.amount.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
                    ]),
                  )
                  as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.lines.replace(valueDes);
          break;
        case r'receivedLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(CaptainAvailabilityDtoOutputCustodyLimit),
                    ]),
                  )
                  as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>?;
          if (valueDes == null) continue;
          result.receivedLines.replace(valueDes);
          break;
        case r'openedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.openedAt = valueDes;
          break;
        case r'confirmBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.confirmBy = valueDes;
          break;
        case r'closedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
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
  CaptainActiveOrderDtoOutputOrderPickupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderPickupRequestBuilder();
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

class CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum open =
      _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
  confirmed =
      _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum
  rejected = _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'voided')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum voided =
      _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnum_voided;

  static Serializer<CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum>
  get values => _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnumValues;
  static CaptainActiveOrderDtoOutputOrderPickupRequestStatusEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderPickupRequestStatusEnumValueOf(name);
}

/// confirmed: «تم الاستلام», or «أكّدت العمليات الاستلام» for operations; rejected: amount_incorrect «المطعم يفيد بأنه استلم {المبلغ}. أكمل المبلغ ثم أعد التأكيد.», incomplete «المطعم يفيد بأن الطلب غير مكتمل. راجع الأصناف معه.»
class CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
  restaurant =
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
  automatic =
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
  operations =
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_operations;
  @BuiltValueEnumConst(wireName: r'amount_incorrect')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
  amountIncorrect =
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
  @BuiltValueEnumConst(wireName: r'incomplete')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
  incomplete =
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum
  cancelled =
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled;

  static Serializer<CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum>
  get values =>
      _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumValues;
  static CaptainActiveOrderDtoOutputOrderPickupRequestOutcomeEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderPickupRequestOutcomeEnumValueOf(name);
}
