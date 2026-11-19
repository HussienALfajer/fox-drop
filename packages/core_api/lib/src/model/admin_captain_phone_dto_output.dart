//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_phone_dto_output.g.dart';

/// AdminCaptainPhoneDtoOutput
///
/// Properties:
/// * [phone]
@BuiltValue()
abstract class AdminCaptainPhoneDtoOutput
    implements
        Built<AdminCaptainPhoneDtoOutput, AdminCaptainPhoneDtoOutputBuilder> {
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  AdminCaptainPhoneDtoOutput._();

  factory AdminCaptainPhoneDtoOutput([
    void updates(AdminCaptainPhoneDtoOutputBuilder b),
  ]) = _$AdminCaptainPhoneDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainPhoneDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainPhoneDtoOutput> get serializer =>
      _$AdminCaptainPhoneDtoOutputSerializer();
}

class _$AdminCaptainPhoneDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainPhoneDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainPhoneDtoOutput,
    _$AdminCaptainPhoneDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainPhoneDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainPhoneDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainPhoneDtoOutput object, {
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
    required AdminCaptainPhoneDtoOutputBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainPhoneDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainPhoneDtoOutputBuilder();
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
