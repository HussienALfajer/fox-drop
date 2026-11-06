//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_dto_output.g.dart';

/// The support phone and WhatsApp numbers in E.164, when set (AP §9.13).
///
/// Properties:
/// * [phone]
/// * [whatsapp]
@BuiltValue()
abstract class ContactDtoOutput
    implements Built<ContactDtoOutput, ContactDtoOutputBuilder> {
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'whatsapp')
  String? get whatsapp;

  ContactDtoOutput._();

  factory ContactDtoOutput([void updates(ContactDtoOutputBuilder b)]) =
      _$ContactDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactDtoOutput> get serializer =>
      _$ContactDtoOutputSerializer();
}

class _$ContactDtoOutputSerializer
    implements PrimitiveSerializer<ContactDtoOutput> {
  @override
  final Iterable<Type> types = const [ContactDtoOutput, _$ContactDtoOutput];

  @override
  final String wireName = r'ContactDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType(String),
      );
    }
    if (object.whatsapp != null) {
      yield r'whatsapp';
      yield serializers.serialize(
        object.whatsapp,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactDtoOutput object, {
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
    required ContactDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'whatsapp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.whatsapp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactDtoOutputBuilder();
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
