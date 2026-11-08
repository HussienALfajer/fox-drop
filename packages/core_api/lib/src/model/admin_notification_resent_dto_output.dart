//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_notification_resent_dto_output.g.dart';

/// AdminNotificationResentDtoOutput
///
/// Properties:
/// * [body] - The text pushed again.
@BuiltValue()
abstract class AdminNotificationResentDtoOutput
    implements
        Built<
          AdminNotificationResentDtoOutput,
          AdminNotificationResentDtoOutputBuilder
        > {
  /// The text pushed again.
  @BuiltValueField(wireName: r'body')
  String get body;

  AdminNotificationResentDtoOutput._();

  factory AdminNotificationResentDtoOutput([
    void updates(AdminNotificationResentDtoOutputBuilder b),
  ]) = _$AdminNotificationResentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNotificationResentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNotificationResentDtoOutput> get serializer =>
      _$AdminNotificationResentDtoOutputSerializer();
}

class _$AdminNotificationResentDtoOutputSerializer
    implements PrimitiveSerializer<AdminNotificationResentDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminNotificationResentDtoOutput,
    _$AdminNotificationResentDtoOutput,
  ];

  @override
  final String wireName = r'AdminNotificationResentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNotificationResentDtoOutput object, {
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
    AdminNotificationResentDtoOutput object, {
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
    required AdminNotificationResentDtoOutputBuilder result,
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
  AdminNotificationResentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNotificationResentDtoOutputBuilder();
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
