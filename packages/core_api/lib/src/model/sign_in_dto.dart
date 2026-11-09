//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sign_in_dto.g.dart';

/// SignInDto
///
/// Properties:
/// * [login] - The email, or the phone in international form.
/// * [password] 
/// * [code] - A 6-digit TOTP code or a backup code.
@BuiltValue()
abstract class SignInDto implements Built<SignInDto, SignInDtoBuilder> {
  /// The email, or the phone in international form.
  @BuiltValueField(wireName: r'login')
  String get login;

  @BuiltValueField(wireName: r'password')
  String get password;

  /// A 6-digit TOTP code or a backup code.
  @BuiltValueField(wireName: r'code')
  String get code;

  SignInDto._();

  factory SignInDto([void updates(SignInDtoBuilder b)]) = _$SignInDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignInDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignInDto> get serializer => _$SignInDtoSerializer();
}

class _$SignInDtoSerializer implements PrimitiveSerializer<SignInDto> {
  @override
  final Iterable<Type> types = const [SignInDto, _$SignInDto];

  @override
  final String wireName = r'SignInDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignInDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'login';
    yield serializers.serialize(
      object.login,
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
    SignInDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SignInDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'login':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.login = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  SignInDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignInDtoBuilder();
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


