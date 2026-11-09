//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complete_setup_dto.g.dart';

/// CompleteSetupDto
///
/// Properties:
/// * [token]
/// * [password]
/// * [code] - A TOTP code from the secret just enrolled.
@BuiltValue()
abstract class CompleteSetupDto
    implements Built<CompleteSetupDto, CompleteSetupDtoBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'password')
  String get password;

  /// A TOTP code from the secret just enrolled.
  @BuiltValueField(wireName: r'code')
  String get code;

  CompleteSetupDto._();

  factory CompleteSetupDto([void updates(CompleteSetupDtoBuilder b)]) =
      _$CompleteSetupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompleteSetupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompleteSetupDto> get serializer =>
      _$CompleteSetupDtoSerializer();
}

class _$CompleteSetupDtoSerializer
    implements PrimitiveSerializer<CompleteSetupDto> {
  @override
  final Iterable<Type> types = const [CompleteSetupDto, _$CompleteSetupDto];

  @override
  final String wireName = r'CompleteSetupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompleteSetupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompleteSetupDto object, {
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
    required CompleteSetupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.token = valueDes;
          break;
        case r'password':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.password = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompleteSetupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompleteSetupDtoBuilder();
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
