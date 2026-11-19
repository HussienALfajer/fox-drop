//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_message_sent_dto_output.g.dart';

/// AdminCaptainMessageSentDtoOutput
///
/// Properties:
/// * [sent]
@BuiltValue()
abstract class AdminCaptainMessageSentDtoOutput
    implements
        Built<
          AdminCaptainMessageSentDtoOutput,
          AdminCaptainMessageSentDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'sent')
  AdminCaptainMessageSentDtoOutputSentEnum get sent;
  // enum sentEnum {  true,  };

  AdminCaptainMessageSentDtoOutput._();

  factory AdminCaptainMessageSentDtoOutput([
    void updates(AdminCaptainMessageSentDtoOutputBuilder b),
  ]) = _$AdminCaptainMessageSentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainMessageSentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainMessageSentDtoOutput> get serializer =>
      _$AdminCaptainMessageSentDtoOutputSerializer();
}

class _$AdminCaptainMessageSentDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainMessageSentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainMessageSentDtoOutput,
    _$AdminCaptainMessageSentDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainMessageSentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainMessageSentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(AdminCaptainMessageSentDtoOutputSentEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainMessageSentDtoOutput object, {
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
    required AdminCaptainMessageSentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sent':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainMessageSentDtoOutputSentEnum,
                    ),
                  )
                  as AdminCaptainMessageSentDtoOutputSentEnum;
          result.sent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainMessageSentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainMessageSentDtoOutputBuilder();
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

class AdminCaptainMessageSentDtoOutputSentEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const AdminCaptainMessageSentDtoOutputSentEnum true_ =
      _$adminCaptainMessageSentDtoOutputSentEnum_true_;

  static Serializer<AdminCaptainMessageSentDtoOutputSentEnum> get serializer =>
      _$adminCaptainMessageSentDtoOutputSentEnumSerializer;

  const AdminCaptainMessageSentDtoOutputSentEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainMessageSentDtoOutputSentEnum> get values =>
      _$adminCaptainMessageSentDtoOutputSentEnumValues;
  static AdminCaptainMessageSentDtoOutputSentEnum valueOf(String name) =>
      _$adminCaptainMessageSentDtoOutputSentEnumValueOf(name);
}
