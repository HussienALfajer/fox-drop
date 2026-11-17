//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_add_customer_note_dto.g.dart';

/// AdminAddCustomerNoteDto
///
/// Properties:
/// * [cityId]
/// * [body] - The note, up to 500 characters.
@BuiltValue()
abstract class AdminAddCustomerNoteDto
    implements Built<AdminAddCustomerNoteDto, AdminAddCustomerNoteDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The note, up to 500 characters.
  @BuiltValueField(wireName: r'body')
  String get body;

  AdminAddCustomerNoteDto._();

  factory AdminAddCustomerNoteDto([
    void updates(AdminAddCustomerNoteDtoBuilder b),
  ]) = _$AdminAddCustomerNoteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAddCustomerNoteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAddCustomerNoteDto> get serializer =>
      _$AdminAddCustomerNoteDtoSerializer();
}

class _$AdminAddCustomerNoteDtoSerializer
    implements PrimitiveSerializer<AdminAddCustomerNoteDto> {
  @override
  final Iterable<Type> types = const [
    AdminAddCustomerNoteDto,
    _$AdminAddCustomerNoteDto,
  ];

  @override
  final String wireName = r'AdminAddCustomerNoteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAddCustomerNoteDto object, {
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
    AdminAddCustomerNoteDto object, {
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
    required AdminAddCustomerNoteDtoBuilder result,
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
  AdminAddCustomerNoteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAddCustomerNoteDtoBuilder();
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
