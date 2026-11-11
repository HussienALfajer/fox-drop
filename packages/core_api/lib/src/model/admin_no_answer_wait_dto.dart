//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_no_answer_wait_dto.g.dart';

/// AdminNoAnswerWaitDto
///
/// Properties:
/// * [message] - Operations' message to the captain at the door (CA §14 #13).
@BuiltValue()
abstract class AdminNoAnswerWaitDto
    implements Built<AdminNoAnswerWaitDto, AdminNoAnswerWaitDtoBuilder> {
  /// Operations' message to the captain at the door (CA §14 #13).
  @BuiltValueField(wireName: r'message')
  String get message;

  AdminNoAnswerWaitDto._();

  factory AdminNoAnswerWaitDto([void updates(AdminNoAnswerWaitDtoBuilder b)]) =
      _$AdminNoAnswerWaitDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNoAnswerWaitDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNoAnswerWaitDto> get serializer =>
      _$AdminNoAnswerWaitDtoSerializer();
}

class _$AdminNoAnswerWaitDtoSerializer
    implements PrimitiveSerializer<AdminNoAnswerWaitDto> {
  @override
  final Iterable<Type> types = const [
    AdminNoAnswerWaitDto,
    _$AdminNoAnswerWaitDto,
  ];

  @override
  final String wireName = r'AdminNoAnswerWaitDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNoAnswerWaitDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNoAnswerWaitDto object, {
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
    required AdminNoAnswerWaitDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNoAnswerWaitDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNoAnswerWaitDtoBuilder();
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
