//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/captain_active_order_dto_output_order_pickup_request.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_pickup.g.dart';

/// Step 2 and the pickup request (CA §9.3–9.4).
///
/// Properties:
/// * [proposedLines] - «ادفع للمطعم: {المبلغ}» proposes them (CA §10.5): the whole amount in the base currency in Phase 1.
/// * [request] 
/// * [pickedUpAt] 
/// * [disputedAt] - «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات».
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderPickup implements Built<CaptainActiveOrderDtoOutputOrderPickup, CaptainActiveOrderDtoOutputOrderPickupBuilder> {
  /// «ادفع للمطعم: {المبلغ}» proposes them (CA §10.5): the whole amount in the base currency in Phase 1.
  @BuiltValueField(wireName: r'proposedLines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get proposedLines;

  @BuiltValueField(wireName: r'request')
  CaptainActiveOrderDtoOutputOrderPickupRequest? get request;

  @BuiltValueField(wireName: r'pickedUpAt')
  DateTime? get pickedUpAt;

  /// «فتح المطعم بلاغاً عن مبلغ الاستلام — ستتواصل معك العمليات».
  @BuiltValueField(wireName: r'disputedAt')
  DateTime? get disputedAt;

  CaptainActiveOrderDtoOutputOrderPickup._();

  factory CaptainActiveOrderDtoOutputOrderPickup([void updates(CaptainActiveOrderDtoOutputOrderPickupBuilder b)]) = _$CaptainActiveOrderDtoOutputOrderPickup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderPickupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderPickup> get serializer => _$CaptainActiveOrderDtoOutputOrderPickupSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderPickupSerializer implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderPickup> {
  @override
  final Iterable<Type> types = const [CaptainActiveOrderDtoOutputOrderPickup, _$CaptainActiveOrderDtoOutputOrderPickup];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderPickup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'proposedLines';
    yield serializers.serialize(
      object.proposedLines,
      specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
    );
    yield r'request';
    yield object.request == null ? null : serializers.serialize(
      object.request,
      specifiedType: const FullType.nullable(CaptainActiveOrderDtoOutputOrderPickupRequest),
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
    CaptainActiveOrderDtoOutputOrderPickup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainActiveOrderDtoOutputOrderPickupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'proposedLines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(CaptainWentOfflineDtoOutputHandIn)]),
          ) as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.proposedLines.replace(valueDes);
          break;
        case r'request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainActiveOrderDtoOutputOrderPickupRequest),
          ) as CaptainActiveOrderDtoOutputOrderPickupRequest?;
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
  CaptainActiveOrderDtoOutputOrderPickup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderPickupBuilder();
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


