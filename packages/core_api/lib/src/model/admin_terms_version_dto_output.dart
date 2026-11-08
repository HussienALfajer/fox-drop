//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_terms_version_dto_output.g.dart';

/// AdminTermsVersionDtoOutput
///
/// Properties:
/// * [version] - Sent back with «أوافق» (CU §15, CA §15).
/// * [body] - Plain text; a line per paragraph.
/// * [publishedAt]
@BuiltValue()
abstract class AdminTermsVersionDtoOutput
    implements
        Built<AdminTermsVersionDtoOutput, AdminTermsVersionDtoOutputBuilder> {
  /// Sent back with «أوافق» (CU §15, CA §15).
  @BuiltValueField(wireName: r'version')
  int get version;

  /// Plain text; a line per paragraph.
  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'publishedAt')
  DateTime get publishedAt;

  AdminTermsVersionDtoOutput._();

  factory AdminTermsVersionDtoOutput([
    void updates(AdminTermsVersionDtoOutputBuilder b),
  ]) = _$AdminTermsVersionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTermsVersionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTermsVersionDtoOutput> get serializer =>
      _$AdminTermsVersionDtoOutputSerializer();
}

class _$AdminTermsVersionDtoOutputSerializer
    implements PrimitiveSerializer<AdminTermsVersionDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminTermsVersionDtoOutput,
    _$AdminTermsVersionDtoOutput,
  ];

  @override
  final String wireName = r'AdminTermsVersionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTermsVersionDtoOutput object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTermsVersionDtoOutput object, {
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
    required AdminTermsVersionDtoOutputBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTermsVersionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTermsVersionDtoOutputBuilder();
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
