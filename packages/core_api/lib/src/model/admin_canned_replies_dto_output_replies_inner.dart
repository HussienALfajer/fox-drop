//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_canned_replies_dto_output_replies_inner.g.dart';

/// AdminCannedRepliesDtoOutputRepliesInner
///
/// Properties:
/// * [title]
/// * [body]
@BuiltValue()
abstract class AdminCannedRepliesDtoOutputRepliesInner
    implements
        Built<
          AdminCannedRepliesDtoOutputRepliesInner,
          AdminCannedRepliesDtoOutputRepliesInnerBuilder
        > {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  AdminCannedRepliesDtoOutputRepliesInner._();

  factory AdminCannedRepliesDtoOutputRepliesInner([
    void updates(AdminCannedRepliesDtoOutputRepliesInnerBuilder b),
  ]) = _$AdminCannedRepliesDtoOutputRepliesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCannedRepliesDtoOutputRepliesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCannedRepliesDtoOutputRepliesInner> get serializer =>
      _$AdminCannedRepliesDtoOutputRepliesInnerSerializer();
}

class _$AdminCannedRepliesDtoOutputRepliesInnerSerializer
    implements PrimitiveSerializer<AdminCannedRepliesDtoOutputRepliesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCannedRepliesDtoOutputRepliesInner,
    _$AdminCannedRepliesDtoOutputRepliesInner,
  ];

  @override
  final String wireName = r'AdminCannedRepliesDtoOutputRepliesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCannedRepliesDtoOutputRepliesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCannedRepliesDtoOutputRepliesInner object, {
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
    required AdminCannedRepliesDtoOutputRepliesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.title = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCannedRepliesDtoOutputRepliesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCannedRepliesDtoOutputRepliesInnerBuilder();
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
