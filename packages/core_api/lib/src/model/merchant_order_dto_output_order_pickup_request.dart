//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_dto_output_order_pickup_request.g.dart';

/// The latest request; while open every device rings with the pickup prompt (RA §8.10 item 3).
///
/// Properties:
/// * [id]
/// * [status]
/// * [outcome] - automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام»; the other devices close the prompt with «أكّد {اسم الجهاز} الاستلام» or «أبلغ … أن المبلغ غير صحيح».
/// * [amount]
/// * [lines] - «400 ₺» or «5 $ + 195 ₺».
/// * [baseEquivalent] - The lines in the base currency, by the order rates.
/// * [confirmBy] - «يُؤكَّد تلقائياً خلال {ث} ث» counts down to it.
/// * [closedAt]
/// * [closedByDeviceName]
@BuiltValue()
abstract class MerchantOrderDtoOutputOrderPickupRequest
    implements
        Built<
          MerchantOrderDtoOutputOrderPickupRequest,
          MerchantOrderDtoOutputOrderPickupRequestBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  MerchantOrderDtoOutputOrderPickupRequestStatusEnum get status;
  // enum statusEnum {  open,  confirmed,  rejected,  voided,  };

  /// automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام»; the other devices close the prompt with «أكّد {اسم الجهاز} الاستلام» or «أبلغ … أن المبلغ غير صحيح».
  @BuiltValueField(wireName: r'outcome')
  MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum? get outcome;
  // enum outcomeEnum {  restaurant,  automatic,  operations,  amount_incorrect,  incomplete,  cancelled,  };

  @BuiltValueField(wireName: r'amount')
  CaptainAvailabilityDtoOutputCustodyLimit get amount;

  /// «400 ₺» or «5 $ + 195 ₺».
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get lines;

  /// The lines in the base currency, by the order rates.
  @BuiltValueField(wireName: r'baseEquivalent')
  String get baseEquivalent;

  /// «يُؤكَّد تلقائياً خلال {ث} ث» counts down to it.
  @BuiltValueField(wireName: r'confirmBy')
  DateTime get confirmBy;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closedByDeviceName')
  String? get closedByDeviceName;

  MerchantOrderDtoOutputOrderPickupRequest._();

  factory MerchantOrderDtoOutputOrderPickupRequest([
    void updates(MerchantOrderDtoOutputOrderPickupRequestBuilder b),
  ]) = _$MerchantOrderDtoOutputOrderPickupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrderDtoOutputOrderPickupRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderDtoOutputOrderPickupRequest> get serializer =>
      _$MerchantOrderDtoOutputOrderPickupRequestSerializer();
}

class _$MerchantOrderDtoOutputOrderPickupRequestSerializer
    implements PrimitiveSerializer<MerchantOrderDtoOutputOrderPickupRequest> {
  @override
  final Iterable<Type> types = const [
    MerchantOrderDtoOutputOrderPickupRequest,
    _$MerchantOrderDtoOutputOrderPickupRequest,
  ];

  @override
  final String wireName = r'MerchantOrderDtoOutputOrderPickupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderDtoOutputOrderPickupRequest object, {
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
        MerchantOrderDtoOutputOrderPickupRequestStatusEnum,
      ),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum,
            ),
          );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainAvailabilityDtoOutputCustodyLimit),
      ]),
    );
    yield r'baseEquivalent';
    yield serializers.serialize(
      object.baseEquivalent,
      specifiedType: const FullType(String),
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
    yield r'closedByDeviceName';
    yield object.closedByDeviceName == null
        ? null
        : serializers.serialize(
            object.closedByDeviceName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderDtoOutputOrderPickupRequest object, {
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
    required MerchantOrderDtoOutputOrderPickupRequestBuilder result,
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
                      MerchantOrderDtoOutputOrderPickupRequestStatusEnum,
                    ),
                  )
                  as MerchantOrderDtoOutputOrderPickupRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum,
                    ),
                  )
                  as MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainAvailabilityDtoOutputCustodyLimit,
                    ),
                  )
                  as CaptainAvailabilityDtoOutputCustodyLimit;
          result.amount.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainAvailabilityDtoOutputCustodyLimit),
                    ]),
                  )
                  as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.lines.replace(valueDes);
          break;
        case r'baseEquivalent':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.baseEquivalent = valueDes;
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
        case r'closedByDeviceName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.closedByDeviceName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrderDtoOutputOrderPickupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrderDtoOutputOrderPickupRequestBuilder();
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

class MerchantOrderDtoOutputOrderPickupRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const MerchantOrderDtoOutputOrderPickupRequestStatusEnum open =
      _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const MerchantOrderDtoOutputOrderPickupRequestStatusEnum confirmed =
      _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrderDtoOutputOrderPickupRequestStatusEnum rejected =
      _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'voided')
  static const MerchantOrderDtoOutputOrderPickupRequestStatusEnum voided =
      _$merchantOrderDtoOutputOrderPickupRequestStatusEnum_voided;

  static Serializer<MerchantOrderDtoOutputOrderPickupRequestStatusEnum>
  get serializer =>
      _$merchantOrderDtoOutputOrderPickupRequestStatusEnumSerializer;

  const MerchantOrderDtoOutputOrderPickupRequestStatusEnum._(String name)
    : super(name);

  static BuiltSet<MerchantOrderDtoOutputOrderPickupRequestStatusEnum>
  get values => _$merchantOrderDtoOutputOrderPickupRequestStatusEnumValues;
  static MerchantOrderDtoOutputOrderPickupRequestStatusEnum valueOf(
    String name,
  ) => _$merchantOrderDtoOutputOrderPickupRequestStatusEnumValueOf(name);
}

/// automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام»; the other devices close the prompt with «أكّد {اسم الجهاز} الاستلام» or «أبلغ … أن المبلغ غير صحيح».
class MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum restaurant =
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum automatic =
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum operations =
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_operations;
  @BuiltValueEnumConst(wireName: r'amount_incorrect')
  static const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum
  amountIncorrect =
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
  @BuiltValueEnumConst(wireName: r'incomplete')
  static const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum incomplete =
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum cancelled =
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnum_cancelled;

  static Serializer<MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum>
  get serializer =>
      _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnumSerializer;

  const MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum._(String name)
    : super(name);

  static BuiltSet<MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum>
  get values => _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnumValues;
  static MerchantOrderDtoOutputOrderPickupRequestOutcomeEnum valueOf(
    String name,
  ) => _$merchantOrderDtoOutputOrderPickupRequestOutcomeEnumValueOf(name);
}
