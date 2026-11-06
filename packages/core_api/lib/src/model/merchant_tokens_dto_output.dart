//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_tokens_dto_output.g.dart';

/// MerchantTokensDtoOutput
///
/// Properties:
/// * [accessToken] - A JWT for the Authorization header, valid 15 minutes.
/// * [accessTokenExpiresAt]
/// * [refreshToken] - Used once at /refresh for a new pair; using it twice signs the device out.
@BuiltValue()
abstract class MerchantTokensDtoOutput
    implements Built<MerchantTokensDtoOutput, MerchantTokensDtoOutputBuilder> {
  /// A JWT for the Authorization header, valid 15 minutes.
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'accessTokenExpiresAt')
  DateTime get accessTokenExpiresAt;

  /// Used once at /refresh for a new pair; using it twice signs the device out.
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  MerchantTokensDtoOutput._();

  factory MerchantTokensDtoOutput([
    void updates(MerchantTokensDtoOutputBuilder b),
  ]) = _$MerchantTokensDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantTokensDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantTokensDtoOutput> get serializer =>
      _$MerchantTokensDtoOutputSerializer();
}

class _$MerchantTokensDtoOutputSerializer
    implements PrimitiveSerializer<MerchantTokensDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantTokensDtoOutput,
    _$MerchantTokensDtoOutput,
  ];

  @override
  final String wireName = r'MerchantTokensDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantTokensDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'accessTokenExpiresAt';
    yield serializers.serialize(
      object.accessTokenExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantTokensDtoOutput object, {
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
    required MerchantTokensDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accessToken = valueDes;
          break;
        case r'accessTokenExpiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.accessTokenExpiresAt = valueDes;
          break;
        case r'refreshToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantTokensDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantTokensDtoOutputBuilder();
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
