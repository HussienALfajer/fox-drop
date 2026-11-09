//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_offer_dto_output_offer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_offer_dto_output.g.dart';

/// CaptainOfferDtoOutput
///
/// Properties:
/// * [offer] 
@BuiltValue()
abstract class CaptainOfferDtoOutput implements Built<CaptainOfferDtoOutput, CaptainOfferDtoOutputBuilder> {
  @BuiltValueField(wireName: r'offer')
  CaptainOfferDtoOutputOffer get offer;

  CaptainOfferDtoOutput._();

  factory CaptainOfferDtoOutput([void updates(CaptainOfferDtoOutputBuilder b)]) = _$CaptainOfferDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOfferDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOfferDtoOutput> get serializer => _$CaptainOfferDtoOutputSerializer();
}

class _$CaptainOfferDtoOutputSerializer implements PrimitiveSerializer<CaptainOfferDtoOutput> {
  @override
  final Iterable<Type> types = const [CaptainOfferDtoOutput, _$CaptainOfferDtoOutput];

  @override
  final String wireName = r'CaptainOfferDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOfferDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'offer';
    yield serializers.serialize(
      object.offer,
      specifiedType: const FullType(CaptainOfferDtoOutputOffer),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOfferDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainOfferDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'offer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainOfferDtoOutputOffer),
          ) as CaptainOfferDtoOutputOffer;
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
  CaptainOfferDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOfferDtoOutputBuilder();
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


