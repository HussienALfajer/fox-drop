//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_notes_inner.g.dart';

/// AdminTicketPageDtoOutputNotesInner
///
/// Properties:
/// * [id]
/// * [authorName]
/// * [body]
/// * [createdAt]
@BuiltValue()
abstract class AdminTicketPageDtoOutputNotesInner
    implements
        Built<
          AdminTicketPageDtoOutputNotesInner,
          AdminTicketPageDtoOutputNotesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'authorName')
  String? get authorName;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminTicketPageDtoOutputNotesInner._();

  factory AdminTicketPageDtoOutputNotesInner([
    void updates(AdminTicketPageDtoOutputNotesInnerBuilder b),
  ]) = _$AdminTicketPageDtoOutputNotesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputNotesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputNotesInner> get serializer =>
      _$AdminTicketPageDtoOutputNotesInnerSerializer();
}

class _$AdminTicketPageDtoOutputNotesInnerSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputNotesInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputNotesInner,
    _$AdminTicketPageDtoOutputNotesInner,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputNotesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputNotesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'authorName';
    yield object.authorName == null
        ? null
        : serializers.serialize(
            object.authorName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputNotesInner object, {
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
    required AdminTicketPageDtoOutputNotesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'authorName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.authorName = valueDes;
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
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputNotesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputNotesInnerBuilder();
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
