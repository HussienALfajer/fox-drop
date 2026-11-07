//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_update_notification_text_dto.g.dart';

/// AdminUpdateNotificationTextDto
///
/// Properties:
/// * [text] - Only the placeholders the template takes, as {name}.
@BuiltValue()
abstract class AdminUpdateNotificationTextDto
    implements
        Built<
          AdminUpdateNotificationTextDto,
          AdminUpdateNotificationTextDtoBuilder
        > {
  /// Only the placeholders the template takes, as {name}.
  @BuiltValueField(wireName: r'text')
  String get text;

  AdminUpdateNotificationTextDto._();

  factory AdminUpdateNotificationTextDto([
    void updates(AdminUpdateNotificationTextDtoBuilder b),
  ]) = _$AdminUpdateNotificationTextDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUpdateNotificationTextDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUpdateNotificationTextDto> get serializer =>
      _$AdminUpdateNotificationTextDtoSerializer();
}

class _$AdminUpdateNotificationTextDtoSerializer
    implements PrimitiveSerializer<AdminUpdateNotificationTextDto> {
  @override
  final Iterable<Type> types = const [
    AdminUpdateNotificationTextDto,
    _$AdminUpdateNotificationTextDto,
  ];

  @override
  final String wireName = r'AdminUpdateNotificationTextDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUpdateNotificationTextDto object, {
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
    AdminUpdateNotificationTextDto object, {
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
    required AdminUpdateNotificationTextDtoBuilder result,
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
  AdminUpdateNotificationTextDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUpdateNotificationTextDtoBuilder();
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
