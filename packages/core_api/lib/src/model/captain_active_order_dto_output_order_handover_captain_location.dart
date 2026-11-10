//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_handover_captain_location.g.dart';

/// Their latest point, read again with the order; null without one.
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [recordedAt]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation,
          CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation._();

  factory CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation([
    void updates(
      CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder b,
    ),
  ]) = _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation
        > {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation,
    _$CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation,
  ];

  @override
  final String wireName =
      r'CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation object, {
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
    CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation object, {
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
    required CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder
    result,
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
  CaptainActiveOrderDtoOutputOrderHandoverCaptainLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CaptainActiveOrderDtoOutputOrderHandoverCaptainLocationBuilder();
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
