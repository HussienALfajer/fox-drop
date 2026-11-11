//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_emergency_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_emergency_dto.g.dart';

/// CaptainEmergencyDto
///
/// Properties:
/// * [location]
@BuiltValue()
abstract class CaptainEmergencyDto
    implements Built<CaptainEmergencyDto, CaptainEmergencyDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  CaptainEmergencyDtoLocation? get location;

  CaptainEmergencyDto._();

  factory CaptainEmergencyDto([void updates(CaptainEmergencyDtoBuilder b)]) =
      _$CaptainEmergencyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEmergencyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEmergencyDto> get serializer =>
      _$CaptainEmergencyDtoSerializer();
}

class _$CaptainEmergencyDtoSerializer
    implements PrimitiveSerializer<CaptainEmergencyDto> {
  @override
  final Iterable<Type> types = const [
    CaptainEmergencyDto,
    _$CaptainEmergencyDto,
  ];

  @override
  final String wireName = r'CaptainEmergencyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEmergencyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield object.location == null
        ? null
        : serializers.serialize(
            object.location,
            specifiedType: const FullType.nullable(CaptainEmergencyDtoLocation),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEmergencyDto object, {
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
    required CaptainEmergencyDtoBuilder result,
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
                    specifiedType: const FullType.nullable(
                      CaptainEmergencyDtoLocation,
                    ),
                  )
                  as CaptainEmergencyDtoLocation?;
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
  CaptainEmergencyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEmergencyDtoBuilder();
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
