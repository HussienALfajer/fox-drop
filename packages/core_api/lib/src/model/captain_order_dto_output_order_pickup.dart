//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_order_dto_output_order_pickup_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output_order_pickup.g.dart';

/// Step 2 and the pickup request (CA §9.3–9.4).
///
/// Properties:
/// * [proposedLines] - «ادفع للمطعم: {المبلغ}» proposes them (CA §10.5): the whole amount in the base currency in Phase 1.
/// * [request] 
/// * [pickedUpAt] 
/// * [disputedAt] - «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات».
@BuiltValue()
abstract class CaptainOrderDtoOutputOrderPickup implements Built<CaptainOrderDtoOutputOrderPickup, CaptainOrderDtoOutputOrderPickupBuilder> {
  /// «ادفع للمطعم: {المبلغ}» proposes them (CA §10.5): the whole amount in the base currency in Phase 1.
  @BuiltValueField(wireName: r'proposedLines')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get proposedLines;

  @BuiltValueField(wireName: r'request')
  CaptainOrderDtoOutputOrderPickupRequest? get request;

  @BuiltValueField(wireName: r'pickedUpAt')
  DateTime? get pickedUpAt;

  /// «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات».
  @BuiltValueField(wireName: r'disputedAt')
  DateTime? get disputedAt;

  CaptainOrderDtoOutputOrderPickup._();

  factory CaptainOrderDtoOutputOrderPickup([void updates(CaptainOrderDtoOutputOrderPickupBuilder b)]) = _$CaptainOrderDtoOutputOrderPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputOrderPickupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutputOrderPickup> get serializer => _$CaptainOrderDtoOutputOrderPickupSerializer();
}

class _$CaptainOrderDtoOutputOrderPickupSerializer implements PrimitiveSerializer<CaptainOrderDtoOutputOrderPickup> {
  @override
  final Iterable<Type> types = const [CaptainOrderDtoOutputOrderPickup, _$CaptainOrderDtoOutputOrderPickup];

  @override
  final String wireName = r'CaptainOrderDtoOutputOrderPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutputOrderPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'proposedLines';
    yield serializers.serialize(
      object.proposedLines,
      specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
    );
    yield r'request';
    yield object.request == null ? null : serializers.serialize(
      object.request,
      specifiedType: const FullType.nullable(CaptainOrderDtoOutputOrderPickupRequest),
    );
    yield r'pickedUpAt';
    yield object.pickedUpAt == null ? null : serializers.serialize(
      object.pickedUpAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'disputedAt';
    yield object.disputedAt == null ? null : serializers.serialize(
      object.disputedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutputOrderPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainOrderDtoOutputOrderPickupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'proposedLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CaptainAvailabilityDtoOutputCustodyLimit)]),
          ) as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.proposedLines.replace(valueDes);
          break;
        case r'request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainOrderDtoOutputOrderPickupRequest),
          ) as CaptainOrderDtoOutputOrderPickupRequest?;
          if (valueDes == null) continue;
          result.request.replace(valueDes);
          break;
        case r'pickedUpAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.pickedUpAt = valueDes;
          break;
        case r'disputedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.disputedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainOrderDtoOutputOrderPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputOrderPickupBuilder();
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


