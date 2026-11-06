//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_go_online_dto.g.dart';

/// CaptainGoOnlineDto
///
/// Properties:
/// * [appVersion]
/// * [simulatedLocation] - A mock-location app is active (Android) or isSimulatedBySoftware (iOS).
@BuiltValue()
abstract class CaptainGoOnlineDto
    implements Built<CaptainGoOnlineDto, CaptainGoOnlineDtoBuilder> {
  @BuiltValueField(wireName: r'appVersion')
  String get appVersion;

  /// A mock-location app is active (Android) or isSimulatedBySoftware (iOS).
  @BuiltValueField(wireName: r'simulatedLocation')
  bool get simulatedLocation;

  CaptainGoOnlineDto._();

  factory CaptainGoOnlineDto([void updates(CaptainGoOnlineDtoBuilder b)]) =
      _$CaptainGoOnlineDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainGoOnlineDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainGoOnlineDto> get serializer =>
      _$CaptainGoOnlineDtoSerializer();
}

class _$CaptainGoOnlineDtoSerializer
    implements PrimitiveSerializer<CaptainGoOnlineDto> {
  @override
  final Iterable<Type> types = const [CaptainGoOnlineDto, _$CaptainGoOnlineDto];

  @override
  final String wireName = r'CaptainGoOnlineDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainGoOnlineDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'appVersion';
    yield serializers.serialize(
      object.appVersion,
      specifiedType: const FullType(String),
    );
    yield r'simulatedLocation';
    yield serializers.serialize(
      object.simulatedLocation,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainGoOnlineDto object, {
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
    required CaptainGoOnlineDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'appVersion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.appVersion = valueDes;
          break;
        case r'simulatedLocation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.simulatedLocation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainGoOnlineDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainGoOnlineDtoBuilder();
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
