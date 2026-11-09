//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_content_dto_output_reasons_merchant_rejection_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_content_dto_output_reasons.g.dart';

/// CaptainContentDtoOutputReasons
///
/// Properties:
/// * [captainCannotComplete] 
/// * [captainAway] 
/// * [shortfall] 
/// * [foodAfterFailed] 
/// * [captainTicketType] 
/// * [captainProblem] 
@BuiltValue()
abstract class CaptainContentDtoOutputReasons implements Built<CaptainContentDtoOutputReasons, CaptainContentDtoOutputReasonsBuilder> {
  @BuiltValueField(wireName: r'captain_cannot_complete')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner> get captainCannotComplete;

  @BuiltValueField(wireName: r'captain_away')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner> get captainAway;

  @BuiltValueField(wireName: r'shortfall')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner> get shortfall;

  @BuiltValueField(wireName: r'food_after_failed')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner> get foodAfterFailed;

  @BuiltValueField(wireName: r'captain_ticket_type')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner> get captainTicketType;

  @BuiltValueField(wireName: r'captain_problem')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner> get captainProblem;

  CaptainContentDtoOutputReasons._();

  factory CaptainContentDtoOutputReasons([void updates(CaptainContentDtoOutputReasonsBuilder b)]) = _$CaptainContentDtoOutputReasons;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContentDtoOutputReasonsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContentDtoOutputReasons> get serializer => _$CaptainContentDtoOutputReasonsSerializer();
}

class _$CaptainContentDtoOutputReasonsSerializer implements PrimitiveSerializer<CaptainContentDtoOutputReasons> {
  @override
  final Iterable<Type> types = const [CaptainContentDtoOutputReasons, _$CaptainContentDtoOutputReasons];

  @override
  final String wireName = r'CaptainContentDtoOutputReasons';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContentDtoOutputReasons object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captain_cannot_complete';
    yield serializers.serialize(
      object.captainCannotComplete,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
    );
    yield r'captain_away';
    yield serializers.serialize(
      object.captainAway,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
    );
    yield r'shortfall';
    yield serializers.serialize(
      object.shortfall,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
    );
    yield r'food_after_failed';
    yield serializers.serialize(
      object.foodAfterFailed,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
    );
    yield r'captain_ticket_type';
    yield serializers.serialize(
      object.captainTicketType,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
    );
    yield r'captain_problem';
    yield serializers.serialize(
      object.captainProblem,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainContentDtoOutputReasons object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainContentDtoOutputReasonsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captain_cannot_complete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
          ) as BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>;
          result.captainCannotComplete.replace(valueDes);
          break;
        case r'captain_away':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
          ) as BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>;
          result.captainAway.replace(valueDes);
          break;
        case r'shortfall':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
          ) as BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>;
          result.shortfall.replace(valueDes);
          break;
        case r'food_after_failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
          ) as BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>;
          result.foodAfterFailed.replace(valueDes);
          break;
        case r'captain_ticket_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
          ) as BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>;
          result.captainTicketType.replace(valueDes);
          break;
        case r'captain_problem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner)]),
          ) as BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>;
          result.captainProblem.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainContentDtoOutputReasons deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContentDtoOutputReasonsBuilder();
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


