//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_current_offer_dto_output_offer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output.g.dart';

/// CaptainCurrentOfferDtoOutput
///
/// Properties:
/// * [offer]
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutput
    implements
        Built<
          CaptainCurrentOfferDtoOutput,
          CaptainCurrentOfferDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'offer')
  CaptainCurrentOfferDtoOutputOffer? get offer;

  CaptainCurrentOfferDtoOutput._();

  factory CaptainCurrentOfferDtoOutput([
    void updates(CaptainCurrentOfferDtoOutputBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutput> get serializer =>
      _$CaptainCurrentOfferDtoOutputSerializer();
}

class _$CaptainCurrentOfferDtoOutputSerializer
    implements PrimitiveSerializer<CaptainCurrentOfferDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutput,
    _$CaptainCurrentOfferDtoOutput,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'offer';
    yield object.offer == null
        ? null
        : serializers.serialize(
            object.offer,
            specifiedType: const FullType.nullable(
              CaptainCurrentOfferDtoOutputOffer,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutput object, {
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
    required CaptainCurrentOfferDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'offer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainCurrentOfferDtoOutputOffer,
                    ),
                  )
                  as CaptainCurrentOfferDtoOutputOffer?;
          if (valueDes == null) continue;
          result.offer.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputBuilder();
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
