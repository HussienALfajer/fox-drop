//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_code_request_dto_device_signature.g.dart';

/// Windows only (slice 2.44): the registered PC's Ed25519 signature of `fox-drop/merchant-code-request\\n{deviceId}\\n{phone}\\n{signedAt}`, in place of App Check.
///
/// Properties:
/// * [signedAt]
/// * [signature]
@BuiltValue()
abstract class MerchantCodeRequestDtoDeviceSignature
    implements
        Built<
          MerchantCodeRequestDtoDeviceSignature,
          MerchantCodeRequestDtoDeviceSignatureBuilder
        > {
  @BuiltValueField(wireName: r'signedAt')
  DateTime get signedAt;

  @BuiltValueField(wireName: r'signature')
  String get signature;

  MerchantCodeRequestDtoDeviceSignature._();

  factory MerchantCodeRequestDtoDeviceSignature([
    void updates(MerchantCodeRequestDtoDeviceSignatureBuilder b),
  ]) = _$MerchantCodeRequestDtoDeviceSignature;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantCodeRequestDtoDeviceSignatureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantCodeRequestDtoDeviceSignature> get serializer =>
      _$MerchantCodeRequestDtoDeviceSignatureSerializer();
}

class _$MerchantCodeRequestDtoDeviceSignatureSerializer
    implements PrimitiveSerializer<MerchantCodeRequestDtoDeviceSignature> {
  @override
  final Iterable<Type> types = const [
    MerchantCodeRequestDtoDeviceSignature,
    _$MerchantCodeRequestDtoDeviceSignature,
  ];

  @override
  final String wireName = r'MerchantCodeRequestDtoDeviceSignature';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantCodeRequestDtoDeviceSignature object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedAt';
    yield serializers.serialize(
      object.signedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'signature';
    yield serializers.serialize(
      object.signature,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantCodeRequestDtoDeviceSignature object, {
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
    required MerchantCodeRequestDtoDeviceSignatureBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.signedAt = valueDes;
          break;
        case r'signature':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.signature = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantCodeRequestDtoDeviceSignature deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantCodeRequestDtoDeviceSignatureBuilder();
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
