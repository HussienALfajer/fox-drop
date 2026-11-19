//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_add_captain_note_dto.g.dart';

/// AdminAddCaptainNoteDto
///
/// Properties:
/// * [body]
@BuiltValue()
abstract class AdminAddCaptainNoteDto
    implements Built<AdminAddCaptainNoteDto, AdminAddCaptainNoteDtoBuilder> {
  @BuiltValueField(wireName: r'body')
  String get body;

  AdminAddCaptainNoteDto._();

  factory AdminAddCaptainNoteDto([
    void updates(AdminAddCaptainNoteDtoBuilder b),
  ]) = _$AdminAddCaptainNoteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAddCaptainNoteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAddCaptainNoteDto> get serializer =>
      _$AdminAddCaptainNoteDtoSerializer();
}

class _$AdminAddCaptainNoteDtoSerializer
    implements PrimitiveSerializer<AdminAddCaptainNoteDto> {
  @override
  final Iterable<Type> types = const [
    AdminAddCaptainNoteDto,
    _$AdminAddCaptainNoteDto,
  ];

  @override
  final String wireName = r'AdminAddCaptainNoteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAddCaptainNoteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAddCaptainNoteDto object, {
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
    required AdminAddCaptainNoteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  AdminAddCaptainNoteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAddCaptainNoteDtoBuilder();
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
