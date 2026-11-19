//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_log_dto_output_events_inner_changes_inner.g.dart';

/// AdminAuditLogDtoOutputEventsInnerChangesInner
///
/// Properties:
/// * [field]
/// * [before] - JSON; null for none.
/// * [after] - JSON; null for none.
@BuiltValue()
abstract class AdminAuditLogDtoOutputEventsInnerChangesInner
    implements
        Built<
          AdminAuditLogDtoOutputEventsInnerChangesInner,
          AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder
        > {
  @BuiltValueField(wireName: r'field')
  String get field;

  /// JSON; null for none.
  @BuiltValueField(wireName: r'before')
  String? get before;

  /// JSON; null for none.
  @BuiltValueField(wireName: r'after')
  String? get after;

  AdminAuditLogDtoOutputEventsInnerChangesInner._();

  factory AdminAuditLogDtoOutputEventsInnerChangesInner([
    void updates(AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder b),
  ]) = _$AdminAuditLogDtoOutputEventsInnerChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditLogDtoOutputEventsInnerChangesInner>
  get serializer => _$AdminAuditLogDtoOutputEventsInnerChangesInnerSerializer();
}

class _$AdminAuditLogDtoOutputEventsInnerChangesInnerSerializer
    implements
        PrimitiveSerializer<AdminAuditLogDtoOutputEventsInnerChangesInner> {
  @override
  final Iterable<Type> types = const [
    AdminAuditLogDtoOutputEventsInnerChangesInner,
    _$AdminAuditLogDtoOutputEventsInnerChangesInner,
  ];

  @override
  final String wireName = r'AdminAuditLogDtoOutputEventsInnerChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditLogDtoOutputEventsInnerChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(String),
    );
    yield r'before';
    yield object.before == null
        ? null
        : serializers.serialize(
            object.before,
            specifiedType: const FullType.nullable(String),
          );
    yield r'after';
    yield object.after == null
        ? null
        : serializers.serialize(
            object.after,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogDtoOutputEventsInnerChangesInner object, {
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
    required AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'field':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.field = valueDes;
          break;
        case r'before':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.before = valueDes;
          break;
        case r'after':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.after = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditLogDtoOutputEventsInnerChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder();
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
