//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_pickup_request.g.dart';

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
abstract class MerchantOrdersDtoOutputOrdersInnerPickupRequest implements Built<MerchantOrdersDtoOutputOrdersInnerPickupRequest, MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum get status;
  // enum statusEnum {  open,  confirmed,  rejected,  voided,  };

  /// automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام».
  @BuiltValueField(wireName: r'outcome')
  MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum? get outcome;
  // enum outcomeEnum {  restaurant,  automatic,  operations,  amount_incorrect,  incomplete,  cancelled,  };

  @BuiltValueField(wireName: r'amount')
  CaptainWentOfflineDtoOutputHandIn? get amount;

  /// «400 ₺» or «5 $ + 195 ₺».
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get lines;

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

  MerchantOrdersDtoOutputOrdersInnerPickupRequest._();

  factory MerchantOrdersDtoOutputOrdersInnerPickupRequest([void updates(MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder b)]) = _$MerchantOrdersDtoOutputOrdersInnerPickupRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerPickupRequest> get serializer => _$MerchantOrdersDtoOutputOrdersInnerPickupRequestSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerPickupRequestSerializer implements PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerPickupRequest> {
  @override
  final Iterable<Type> types = const [MerchantOrdersDtoOutputOrdersInnerPickupRequest, _$MerchantOrdersDtoOutputOrdersInnerPickupRequest];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerPickupRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerPickupRequest object, {
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
      specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum),
    );
    yield r'outcome';
    yield object.outcome == null ? null : serializers.serialize(
      object.outcome,
      specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum),
    );
    yield r'amount';
    yield object.amount == null ? null : serializers.serialize(
      object.amount,
      specifiedType: const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
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
    yield object.closedAt == null ? null : serializers.serialize(
      object.closedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'closedByUserName';
    yield object.closedByUserName == null ? null : serializers.serialize(
      object.closedByUserName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'closedByDeviceName';
    yield object.closedByDeviceName == null ? null : serializers.serialize(
      object.closedByDeviceName,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerPickupRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder result,
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
            specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum),
          ) as MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum),
          ) as MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
          ) as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.amount.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.lines.replace(valueDes);
          break;
        case r'baseEquivalent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.baseEquivalent = valueDes;
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
        case r'closedByUserName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closedByUserName = valueDes;
          break;
        case r'closedByDeviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  MerchantOrdersDtoOutputOrdersInnerPickupRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerPickupRequestBuilder();
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


class MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'open')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum open = _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum confirmed = _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum rejected = _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'voided')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum voided = _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum_voided;

  static Serializer<MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum> get serializer => _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumSerializer;

  const MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum._(String name): super(name);

  static BuiltSet<MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum> get values => _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumValues;
  static MerchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnum valueOf(String name) => _$merchantOrdersDtoOutputOrdersInnerPickupRequestStatusEnumValueOf(name);
}

/// automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام».
class MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'restaurant')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum restaurant = _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'automatic')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum automatic = _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_automatic;
  @BuiltValueEnumConst(wireName: r'operations')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum operations = _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_operations;
  @BuiltValueEnumConst(wireName: r'amount_incorrect')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum amountIncorrect = _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_amountIncorrect;
  @BuiltValueEnumConst(wireName: r'incomplete')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum incomplete = _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_incomplete;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum cancelled = _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum_cancelled;

  static Serializer<MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum> get serializer => _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumSerializer;

  const MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum._(String name): super(name);

  static BuiltSet<MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum> get values => _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumValues;
  static MerchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnum valueOf(String name) => _$merchantOrdersDtoOutputOrdersInnerPickupRequestOutcomeEnumValueOf(name);
}

