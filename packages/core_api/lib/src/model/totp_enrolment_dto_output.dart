//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'totp_enrolment_dto_output.g.dart';

/// TotpEnrolmentDtoOutput
///
/// Properties:
/// * [secret] - The TOTP secret in base32, for typing it in by hand.
/// * [otpauthUri] - The otpauth:// URI the panel shows as a QR code.
@BuiltValue()
abstract class TotpEnrolmentDtoOutput
    implements Built<TotpEnrolmentDtoOutput, TotpEnrolmentDtoOutputBuilder> {
  /// The TOTP secret in base32, for typing it in by hand.
  @BuiltValueField(wireName: r'secret')
  String get secret;

  /// The otpauth:// URI the panel shows as a QR code.
  @BuiltValueField(wireName: r'otpauthUri')
  String get otpauthUri;

  TotpEnrolmentDtoOutput._();

  factory TotpEnrolmentDtoOutput([
    void updates(TotpEnrolmentDtoOutputBuilder b),
  ]) = _$TotpEnrolmentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TotpEnrolmentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TotpEnrolmentDtoOutput> get serializer =>
      _$TotpEnrolmentDtoOutputSerializer();
}

class _$TotpEnrolmentDtoOutputSerializer
    implements PrimitiveSerializer<TotpEnrolmentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    TotpEnrolmentDtoOutput,
    _$TotpEnrolmentDtoOutput,
  ];

  @override
  final String wireName = r'TotpEnrolmentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TotpEnrolmentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'secret';
    yield serializers.serialize(
      object.secret,
      specifiedType: const FullType(String),
    );
    yield r'otpauthUri';
    yield serializers.serialize(
      object.otpauthUri,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TotpEnrolmentDtoOutput object, {
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
    required TotpEnrolmentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'secret':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.secret = valueDes;
          break;
        case r'otpauthUri':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.otpauthUri = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TotpEnrolmentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TotpEnrolmentDtoOutputBuilder();
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
