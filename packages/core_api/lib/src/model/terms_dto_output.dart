//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'terms_dto_output.g.dart';

/// TermsDtoOutput
///
/// Properties:
/// * [version] - Sent back with «أوافق» (CU §15, CA §15).
/// * [body] - Plain text; a line per paragraph.
/// * [publishedAt]
/// * [pending] - The signed-in account has not accepted this version; false for a guest and for a cashier (RA S13).
@BuiltValue()
abstract class TermsDtoOutput
    implements Built<TermsDtoOutput, TermsDtoOutputBuilder> {
  /// Sent back with «أوافق» (CU §15, CA §15).
  @BuiltValueField(wireName: r'version')
  int get version;

  /// Plain text; a line per paragraph.
  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'publishedAt')
  DateTime get publishedAt;

  /// The signed-in account has not accepted this version; false for a guest and for a cashier (RA S13).
  @BuiltValueField(wireName: r'pending')
  bool get pending;

  TermsDtoOutput._();

  factory TermsDtoOutput([void updates(TermsDtoOutputBuilder b)]) =
      _$TermsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TermsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TermsDtoOutput> get serializer =>
      _$TermsDtoOutputSerializer();
}

class _$TermsDtoOutputSerializer
    implements PrimitiveSerializer<TermsDtoOutput> {
  @override
  final Iterable<Type> types = const [TermsDtoOutput, _$TermsDtoOutput];

  @override
  final String wireName = r'TermsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TermsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'publishedAt';
    yield serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'pending';
    yield serializers.serialize(
      object.pending,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TermsDtoOutput object, {
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
    required TermsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'body':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.body = valueDes;
          break;
        case r'publishedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.publishedAt = valueDes;
          break;
        case r'pending':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.pending = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TermsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TermsDtoOutputBuilder();
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
