//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_arrive_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_arrive_dto.g.dart';

/// CaptainArriveDto
///
/// Properties:
/// * [location]
@BuiltValue()
abstract class CaptainArriveDto
    implements Built<CaptainArriveDto, CaptainArriveDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  CaptainArriveDtoLocation get location;

  CaptainArriveDto._();

  factory CaptainArriveDto([void updates(CaptainArriveDtoBuilder b)]) =
      _$CaptainArriveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainArriveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainArriveDto> get serializer =>
      _$CaptainArriveDtoSerializer();
}

class _$CaptainArriveDtoSerializer
    implements PrimitiveSerializer<CaptainArriveDto> {
  @override
  final Iterable<Type> types = const [CaptainArriveDto, _$CaptainArriveDto];

  @override
  final String wireName = r'CaptainArriveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainArriveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CaptainArriveDtoLocation),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainArriveDto object, {
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
    required CaptainArriveDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainArriveDtoLocation),
                  )
                  as CaptainArriveDtoLocation;
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
  CaptainArriveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainArriveDtoBuilder();
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
