//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'emergency_sign_in_code_dto_output.g.dart';

/// EmergencySignInCodeDtoOutput
///
/// Properties:
/// * [code] - Shown once; read out to the person, who types it in the app.
/// * [expiresAt] 
/// * [accountId] - The captain or restaurant user account it signs in to.
@BuiltValue()
abstract class EmergencySignInCodeDtoOutput implements Built<EmergencySignInCodeDtoOutput, EmergencySignInCodeDtoOutputBuilder> {
  /// Shown once; read out to the person, who types it in the app.
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  /// The captain or restaurant user account it signs in to.
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  EmergencySignInCodeDtoOutput._();

  factory EmergencySignInCodeDtoOutput([void updates(EmergencySignInCodeDtoOutputBuilder b)]) = _$EmergencySignInCodeDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmergencySignInCodeDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmergencySignInCodeDtoOutput> get serializer => _$EmergencySignInCodeDtoOutputSerializer();
}

class _$EmergencySignInCodeDtoOutputSerializer implements PrimitiveSerializer<EmergencySignInCodeDtoOutput> {
  @override
  final Iterable<Type> types = const [EmergencySignInCodeDtoOutput, _$EmergencySignInCodeDtoOutput];

  @override
  final String wireName = r'EmergencySignInCodeDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmergencySignInCodeDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmergencySignInCodeDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmergencySignInCodeDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'accountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmergencySignInCodeDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmergencySignInCodeDtoOutputBuilder();
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


