//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_dto_output.g.dart';

/// ContactDtoOutput
///
/// Properties:
/// * [phone] - The support phone number in E.164, or null.
/// * [whatsapp] - The support WhatsApp number in E.164, or null.
@BuiltValue()
abstract class ContactDtoOutput
    implements Built<ContactDtoOutput, ContactDtoOutputBuilder> {
  /// The support phone number in E.164, or null.
  @BuiltValueField(wireName: r'phone')
  BuiltList<String> get phone;

  /// The support WhatsApp number in E.164, or null.
  @BuiltValueField(wireName: r'whatsapp')
  BuiltList<String> get whatsapp;

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
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'whatsapp';
    yield serializers.serialize(
      object.whatsapp,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
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
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.phone.replace(valueDes);
          break;
        case r'whatsapp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.whatsapp.replace(valueDes);
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
