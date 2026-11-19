//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_audit_log_dto_output_events_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_log_dto_output.g.dart';

/// AdminAuditLogDtoOutput
///
/// Properties:
/// * [events] - Newest first.
/// * [nextCursor] - Null on the last page.
@BuiltValue()
abstract class AdminAuditLogDtoOutput
    implements Built<AdminAuditLogDtoOutput, AdminAuditLogDtoOutputBuilder> {
  /// Newest first.
  @BuiltValueField(wireName: r'events')
  BuiltList<AdminAuditLogDtoOutputEventsInner> get events;

  /// Null on the last page.
  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminAuditLogDtoOutput._();

  factory AdminAuditLogDtoOutput([
    void updates(AdminAuditLogDtoOutputBuilder b),
  ]) = _$AdminAuditLogDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditLogDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditLogDtoOutput> get serializer =>
      _$AdminAuditLogDtoOutputSerializer();
}

class _$AdminAuditLogDtoOutputSerializer
    implements PrimitiveSerializer<AdminAuditLogDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminAuditLogDtoOutput,
    _$AdminAuditLogDtoOutput,
  ];

  @override
  final String wireName = r'AdminAuditLogDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminAuditLogDtoOutputEventsInner),
      ]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null
        ? null
        : serializers.serialize(
            object.nextCursor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogDtoOutput object, {
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
    required AdminAuditLogDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'events':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminAuditLogDtoOutputEventsInner),
                    ]),
                  )
                  as BuiltList<AdminAuditLogDtoOutputEventsInner>;
          result.events.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditLogDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditLogDtoOutputBuilder();
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
