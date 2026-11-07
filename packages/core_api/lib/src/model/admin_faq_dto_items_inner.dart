//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_faq_dto_items_inner.g.dart';

/// AdminFaqDtoItemsInner
///
/// Properties:
/// * [question]
/// * [answer]
@BuiltValue()
abstract class AdminFaqDtoItemsInner
    implements Built<AdminFaqDtoItemsInner, AdminFaqDtoItemsInnerBuilder> {
  @BuiltValueField(wireName: r'question')
  String get question;

  @BuiltValueField(wireName: r'answer')
  String get answer;

  AdminFaqDtoItemsInner._();

  factory AdminFaqDtoItemsInner([
    void updates(AdminFaqDtoItemsInnerBuilder b),
  ]) = _$AdminFaqDtoItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFaqDtoItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFaqDtoItemsInner> get serializer =>
      _$AdminFaqDtoItemsInnerSerializer();
}

class _$AdminFaqDtoItemsInnerSerializer
    implements PrimitiveSerializer<AdminFaqDtoItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminFaqDtoItemsInner,
    _$AdminFaqDtoItemsInner,
  ];

  @override
  final String wireName = r'AdminFaqDtoItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFaqDtoItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'question';
    yield serializers.serialize(
      object.question,
      specifiedType: const FullType(String),
    );
    yield r'answer';
    yield serializers.serialize(
      object.answer,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminFaqDtoItemsInner object, {
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
    required AdminFaqDtoItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'question':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.question = valueDes;
          break;
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.answer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminFaqDtoItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFaqDtoItemsInnerBuilder();
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
