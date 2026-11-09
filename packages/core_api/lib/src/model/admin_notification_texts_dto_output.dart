//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_notification_texts_dto_output_templates_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_notification_texts_dto_output.g.dart';

/// AdminNotificationTextsDtoOutput
///
/// Properties:
/// * [templates] 
@BuiltValue()
abstract class AdminNotificationTextsDtoOutput implements Built<AdminNotificationTextsDtoOutput, AdminNotificationTextsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'templates')
  BuiltList<AdminNotificationTextsDtoOutputTemplatesInner> get templates;

  AdminNotificationTextsDtoOutput._();

  factory AdminNotificationTextsDtoOutput([void updates(AdminNotificationTextsDtoOutputBuilder b)]) = _$AdminNotificationTextsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminNotificationTextsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminNotificationTextsDtoOutput> get serializer => _$AdminNotificationTextsDtoOutputSerializer();
}

class _$AdminNotificationTextsDtoOutputSerializer implements PrimitiveSerializer<AdminNotificationTextsDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminNotificationTextsDtoOutput, _$AdminNotificationTextsDtoOutput];

  @override
  final String wireName = r'AdminNotificationTextsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminNotificationTextsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'templates';
    yield serializers.serialize(
      object.templates,
      specifiedType: const FullType(BuiltList, [FullType(AdminNotificationTextsDtoOutputTemplatesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminNotificationTextsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminNotificationTextsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'templates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminNotificationTextsDtoOutputTemplatesInner)]),
          ) as BuiltList<AdminNotificationTextsDtoOutputTemplatesInner>;
          result.templates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminNotificationTextsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminNotificationTextsDtoOutputBuilder();
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


