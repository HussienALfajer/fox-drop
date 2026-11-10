//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_current_offer_dto_output_offer_handover_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_handover.g.dart';

/// «استلام من كابتن» (CA §9.10.1): the order is taken from this captain; restaurant.distanceMetres is then to them. Null for an ordinary offer.
///
/// Properties:
/// * [fromCaptainName]
/// * [location]
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferHandover
    implements
        Built<
          CaptainCurrentOfferDtoOutputOfferHandover,
          CaptainCurrentOfferDtoOutputOfferHandoverBuilder
        > {
  @BuiltValueField(wireName: r'fromCaptainName')
  String get fromCaptainName;

  @BuiltValueField(wireName: r'location')
  CaptainCurrentOfferDtoOutputOfferHandoverLocation? get location;

  CaptainCurrentOfferDtoOutputOfferHandover._();

  factory CaptainCurrentOfferDtoOutputOfferHandover([
    void updates(CaptainCurrentOfferDtoOutputOfferHandoverBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutputOfferHandover;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputOfferHandoverBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferHandover> get serializer =>
      _$CaptainCurrentOfferDtoOutputOfferHandoverSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferHandoverSerializer
    implements PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferHandover> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutputOfferHandover,
    _$CaptainCurrentOfferDtoOutputOfferHandover,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferHandover';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferHandover object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromCaptainName';
    yield serializers.serialize(
      object.fromCaptainName,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield object.location == null
        ? null
        : serializers.serialize(
            object.location,
            specifiedType: const FullType.nullable(
              CaptainCurrentOfferDtoOutputOfferHandoverLocation,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferHandover object, {
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
    required CaptainCurrentOfferDtoOutputOfferHandoverBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromCaptainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fromCaptainName = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainCurrentOfferDtoOutputOfferHandoverLocation,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOfferHandoverLocation?;
          if (valueDes == null) continue;
          result.location.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutputOfferHandover deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferHandoverBuilder();
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
