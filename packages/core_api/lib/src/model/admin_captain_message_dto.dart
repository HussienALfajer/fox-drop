//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_message_dto.g.dart';

/// AdminCaptainMessageDto
///
/// Properties:
/// * [text]
@BuiltValue()
abstract class AdminCaptainMessageDto
    implements Built<AdminCaptainMessageDto, AdminCaptainMessageDtoBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  AdminCaptainMessageDto._();

  factory AdminCaptainMessageDto([
    void updates(AdminCaptainMessageDtoBuilder b),
  ]) = _$AdminCaptainMessageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainMessageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainMessageDto> get serializer =>
      _$AdminCaptainMessageDtoSerializer();
}

class _$AdminCaptainMessageDtoSerializer
    implements PrimitiveSerializer<AdminCaptainMessageDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainMessageDto,
    _$AdminCaptainMessageDto,
  ];

  @override
  final String wireName = r'AdminCaptainMessageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainMessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainMessageDto object, {
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
    required AdminCaptainMessageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.text = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainMessageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainMessageDtoBuilder();
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
