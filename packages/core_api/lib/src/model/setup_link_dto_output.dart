//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setup_link_dto_output.g.dart';

/// SetupLinkDtoOutput
///
/// Properties:
/// * [accountId]
/// * [setupToken] - Shown this once. The panel puts it in its setup link, after /setup#token=, for the owner to share.
/// * [setupExpiresAt]
@BuiltValue()
abstract class SetupLinkDtoOutput
    implements Built<SetupLinkDtoOutput, SetupLinkDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  /// Shown this once. The panel puts it in its setup link, after /setup#token=, for the owner to share.
  @BuiltValueField(wireName: r'setupToken')
  String get setupToken;

  @BuiltValueField(wireName: r'setupExpiresAt')
  DateTime get setupExpiresAt;

  SetupLinkDtoOutput._();

  factory SetupLinkDtoOutput([void updates(SetupLinkDtoOutputBuilder b)]) =
      _$SetupLinkDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetupLinkDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetupLinkDtoOutput> get serializer =>
      _$SetupLinkDtoOutputSerializer();
}

class _$SetupLinkDtoOutputSerializer
    implements PrimitiveSerializer<SetupLinkDtoOutput> {
  @override
  final Iterable<Type> types = const [SetupLinkDtoOutput, _$SetupLinkDtoOutput];

  @override
  final String wireName = r'SetupLinkDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetupLinkDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'setupToken';
    yield serializers.serialize(
      object.setupToken,
      specifiedType: const FullType(String),
    );
    yield r'setupExpiresAt';
    yield serializers.serialize(
      object.setupExpiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetupLinkDtoOutput object, {
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
    required SetupLinkDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.accountId = valueDes;
          break;
        case r'setupToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.setupToken = valueDes;
          break;
        case r'setupExpiresAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.setupExpiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetupLinkDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetupLinkDtoOutputBuilder();
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
