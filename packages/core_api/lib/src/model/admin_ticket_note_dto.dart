//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_note_dto.g.dart';

/// AdminTicketNoteDto
///
/// Properties:
/// * [cityId]
/// * [body]
@BuiltValue()
abstract class AdminTicketNoteDto
    implements Built<AdminTicketNoteDto, AdminTicketNoteDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'body')
  String get body;

  AdminTicketNoteDto._();

  factory AdminTicketNoteDto([void updates(AdminTicketNoteDtoBuilder b)]) =
      _$AdminTicketNoteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketNoteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketNoteDto> get serializer =>
      _$AdminTicketNoteDtoSerializer();
}

class _$AdminTicketNoteDtoSerializer
    implements PrimitiveSerializer<AdminTicketNoteDto> {
  @override
  final Iterable<Type> types = const [AdminTicketNoteDto, _$AdminTicketNoteDto];

  @override
  final String wireName = r'AdminTicketNoteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketNoteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
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
    AdminTicketNoteDto object, {
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
    required AdminTicketNoteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
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
  AdminTicketNoteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketNoteDtoBuilder();
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
