//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_windows_registration_dto.g.dart';

/// MerchantWindowsRegistrationDto
///
/// Properties:
/// * [code] - The owner’s pairing code.
/// * [deviceId] - The device. The customer app's survives a reinstall (slice 2.25d: from Android ID on Android, a Keychain value on iOS), so a block follows the phone; the other apps' is the installation, kept until the app is removed.
/// * [publicKey] - The raw 32-byte Ed25519 public key, in base64.
@BuiltValue()
abstract class MerchantWindowsRegistrationDto
    implements
        Built<
          MerchantWindowsRegistrationDto,
          MerchantWindowsRegistrationDtoBuilder
        > {
  /// The owner’s pairing code.
  @BuiltValueField(wireName: r'code')
  String get code;

  /// The device. The customer app's survives a reinstall (slice 2.25d: from Android ID on Android, a Keychain value on iOS), so a block follows the phone; the other apps' is the installation, kept until the app is removed.
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  /// The raw 32-byte Ed25519 public key, in base64.
  @BuiltValueField(wireName: r'publicKey')
  String get publicKey;

  MerchantWindowsRegistrationDto._();

  factory MerchantWindowsRegistrationDto([
    void updates(MerchantWindowsRegistrationDtoBuilder b),
  ]) = _$MerchantWindowsRegistrationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantWindowsRegistrationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantWindowsRegistrationDto> get serializer =>
      _$MerchantWindowsRegistrationDtoSerializer();
}

class _$MerchantWindowsRegistrationDtoSerializer
    implements PrimitiveSerializer<MerchantWindowsRegistrationDto> {
  @override
  final Iterable<Type> types = const [
    MerchantWindowsRegistrationDto,
    _$MerchantWindowsRegistrationDto,
  ];

  @override
  final String wireName = r'MerchantWindowsRegistrationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantWindowsRegistrationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'publicKey';
    yield serializers.serialize(
      object.publicKey,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantWindowsRegistrationDto object, {
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
    required MerchantWindowsRegistrationDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'deviceId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deviceId = valueDes;
          break;
        case r'publicKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.publicKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantWindowsRegistrationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantWindowsRegistrationDtoBuilder();
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
