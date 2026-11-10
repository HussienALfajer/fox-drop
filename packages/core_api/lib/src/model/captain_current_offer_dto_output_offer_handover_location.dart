//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_handover_location.g.dart';

/// The first captain’s latest point; null without one.
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [recordedAt] - When the first captain’s app recorded it.
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferHandoverLocation
    implements
        Built<
          CaptainCurrentOfferDtoOutputOfferHandoverLocation,
          CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  /// When the first captain’s app recorded it.
  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  CaptainCurrentOfferDtoOutputOfferHandoverLocation._();

  factory CaptainCurrentOfferDtoOutputOfferHandoverLocation([
    void updates(CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutputOfferHandoverLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferHandoverLocation>
  get serializer =>
      _$CaptainCurrentOfferDtoOutputOfferHandoverLocationSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferHandoverLocationSerializer
    implements
        PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferHandoverLocation> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutputOfferHandoverLocation,
    _$CaptainCurrentOfferDtoOutputOfferHandoverLocation,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferHandoverLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferHandoverLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'recordedAt';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferHandoverLocation object, {
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
    required CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        case r'recordedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutputOfferHandoverLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder();
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
