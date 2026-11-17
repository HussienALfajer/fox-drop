//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_canned_replies_dto_replies_inner.g.dart';

/// AdminCannedRepliesDtoRepliesInner
///
/// Properties:
/// * [title]
/// * [body]
@BuiltValue()
abstract class AdminCannedRepliesDtoRepliesInner
    implements
        Built<
          AdminCannedRepliesDtoRepliesInner,
          AdminCannedRepliesDtoRepliesInnerBuilder
        > {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  AdminCannedRepliesDtoRepliesInner._();

  factory AdminCannedRepliesDtoRepliesInner([
    void updates(AdminCannedRepliesDtoRepliesInnerBuilder b),
  ]) = _$AdminCannedRepliesDtoRepliesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCannedRepliesDtoRepliesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCannedRepliesDtoRepliesInner> get serializer =>
      _$AdminCannedRepliesDtoRepliesInnerSerializer();
}

class _$AdminCannedRepliesDtoRepliesInnerSerializer
    implements PrimitiveSerializer<AdminCannedRepliesDtoRepliesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCannedRepliesDtoRepliesInner,
    _$AdminCannedRepliesDtoRepliesInner,
  ];

  @override
  final String wireName = r'AdminCannedRepliesDtoRepliesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCannedRepliesDtoRepliesInner object, {
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
    AdminCannedRepliesDtoRepliesInner object, {
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
    required AdminCannedRepliesDtoRepliesInnerBuilder result,
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
  AdminCannedRepliesDtoRepliesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCannedRepliesDtoRepliesInnerBuilder();
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
