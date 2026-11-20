//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_order_with_timeline_dto_output_order_pickup_request.g.dart';

/// The latest request; while open every device rings with the pickup prompt (RA §8.10 item 3).
///
/// Properties:
/// * [id]
/// * [status]
/// * [outcome] - automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام».
/// * [amount]
/// * [lines] - «400 ₺» or «5 $ + 195 ₺».
/// * [baseEquivalent] - The lines in the base currency, by the order rates.
/// * [confirmBy] - «يُؤكَّد تلقائياً خلال {ث} ث» counts down to it.
/// * [closedAt]
/// * [closedByUserName] - The other devices close the prompt with «أكّد {اسم المستخدم} الاستلام» or «أبلغ {اسم المستخدم} أن المبلغ غير صحيح» (RA §8.10).
/// * [closedByDeviceName]
@BuiltValue()
abstract class MerchantOrderWithTimelineDtoOutputOrderPickupRequest
    implements
        Built<
          MerchantOrderWithTimelineDtoOutputOrderPickupRequest,
          MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum get status;
  // enum statusEnum {  open,  confirmed,  rejected,  voided,  };

  /// automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام».
  @BuiltValueField(wireName: r'outcome')
  MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum? get outcome;
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

  /// The other devices close the prompt with «أكّد {اسم المستخدم} الاستلام» or «أبلغ {اسم المستخدم} أن المبلغ غير صحيح» (RA §8.10).
  @BuiltValueField(wireName: r'closedByUserName')
  String? get closedByUserName;

  @BuiltValueField(wireName: r'closedByDeviceName')
  String? get closedByDeviceName;

  MerchantOrderWithTimelineDtoOutputOrderPickupRequest._();

  factory MerchantOrderWithTimelineDtoOutputOrderPickupRequest([
    void updates(MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder b),
  ]) = _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrderWithTimelineDtoOutputOrderPickupRequest>
  get serializer =>
      _$MerchantOrderWithTimelineDtoOutputOrderPickupRequestSerializer();
}

class _$MerchantOrderWithTimelineDtoOutputOrderPickupRequestSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderWithTimelineDtoOutputOrderPickupRequest
        > {
  @override
  final Iterable<Type> types = const [
    MerchantOrderWithTimelineDtoOutputOrderPickupRequest,
    _$MerchantOrderWithTimelineDtoOutputOrderPickupRequest,
  ];

  @override
  final String wireName =
      r'MerchantOrderWithTimelineDtoOutputOrderPickupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrderWithTimelineDtoOutputOrderPickupRequest object, {
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
        MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum,
      ),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum,
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
    yield r'closedByUserName';
    yield object.closedByUserName == null
        ? null
        : serializers.serialize(
            object.closedByUserName,
            specifiedType: const FullType.nullable(String),
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
    MerchantOrderWithTimelineDtoOutputOrderPickupRequest object, {
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
    required MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder result,
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
                      MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum,
                    ),
                  )
                  as MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum,
                    ),
                  )
                  as MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum?;
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
        case r'closedByUserName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.closedByUserName = valueDes;
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
  MerchantOrderWithTimelineDtoOutputOrderPickupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantOrderWithTimelineDtoOutputOrderPickupRequestBuilder();
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

class MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'open')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
  open = _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
  confirmed =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
  rejected =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'voided')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
  voided =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum_voided;

  static Serializer<
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
  >
  get serializer =>
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumSerializer;

  const MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum
  >
  get values =>
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumValues;
  static MerchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnum valueOf(
    String name,
  ) => _$merchantOrderWithTimelineDtoOutputOrderPickupRequestStatusEnumValueOf(
    name,
  );
}

/// automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام».
class MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  restaurant =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  automatic =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  operations =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_operations;
  @BuiltValueEnumConst(wireName: r'amount_incorrect')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  amountIncorrect =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_amountIncorrect;
  @BuiltValueEnumConst(wireName: r'incomplete')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  incomplete =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_incomplete;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  cancelled =
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum_cancelled;

  static Serializer<
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  >
  get serializer =>
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumSerializer;

  const MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  >
  get values =>
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumValues;
  static MerchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnum
  valueOf(String name) =>
      _$merchantOrderWithTimelineDtoOutputOrderPickupRequestOutcomeEnumValueOf(
        name,
      );
}
