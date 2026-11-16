//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_code_request_dto.g.dart';

/// CaptainCodeRequestDto
///
/// Properties:
/// * [phone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [deviceId] - The app installation, generated once by the app and kept until it is removed.
@BuiltValue()
abstract class CaptainCodeRequestDto implements Built<CaptainCodeRequestDto, CaptainCodeRequestDtoBuilder> {
  /// The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  /// The app installation, generated once by the app and kept until it is removed.
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  CaptainCodeRequestDto._();

  factory CaptainCodeRequestDto([void updates(CaptainCodeRequestDtoBuilder b)]) = _$CaptainCodeRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCodeRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCodeRequestDto> get serializer => _$CaptainCodeRequestDtoSerializer();
}

class _$CaptainCodeRequestDtoSerializer implements PrimitiveSerializer<CaptainCodeRequestDto> {
  @override
  final Iterable<Type> types = const [CaptainCodeRequestDto, _$CaptainCodeRequestDto];

  @override
  final String wireName = r'CaptainCodeRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCodeRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainCodeRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCodeRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCodeRequestDtoBuilder();
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


