//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'realtime_token_dto_output.g.dart';

/// RealtimeTokenDtoOutput
///
/// Properties:
/// * [token] - Centrifugo's connection token, valid 15 minutes; ask again when it expires.
/// * [expiresAt]
@BuiltValue()
abstract class RealtimeTokenDtoOutput
    implements Built<RealtimeTokenDtoOutput, RealtimeTokenDtoOutputBuilder> {
  /// Centrifugo's connection token, valid 15 minutes; ask again when it expires.
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  RealtimeTokenDtoOutput._();

  factory RealtimeTokenDtoOutput([
    void updates(RealtimeTokenDtoOutputBuilder b),
  ]) = _$RealtimeTokenDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RealtimeTokenDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RealtimeTokenDtoOutput> get serializer =>
      _$RealtimeTokenDtoOutputSerializer();
}

class _$RealtimeTokenDtoOutputSerializer
    implements PrimitiveSerializer<RealtimeTokenDtoOutput> {
  @override
  final Iterable<Type> types = const [
    RealtimeTokenDtoOutput,
    _$RealtimeTokenDtoOutput,
  ];

  @override
  final String wireName = r'RealtimeTokenDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RealtimeTokenDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RealtimeTokenDtoOutput object, {
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
    required RealtimeTokenDtoOutputBuilder result,
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
        case r'expiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RealtimeTokenDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RealtimeTokenDtoOutputBuilder();
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
