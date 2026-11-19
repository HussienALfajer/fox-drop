//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_change_log_dto_output_entries_inner_changes_inner.g.dart';

/// AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner
///
/// Properties:
/// * [field]
/// * [before] - The value as JSON; null for none.
/// * [after]
@BuiltValue()
abstract class AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner
    implements
        Built<
          AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner,
          AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder
        > {
  @BuiltValueField(wireName: r'field')
  String get field;

  /// The value as JSON; null for none.
  @BuiltValueField(wireName: r'before')
  String? get before;

  @BuiltValueField(wireName: r'after')
  String? get after;

  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner._();

  factory AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner([
    void updates(
      AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder b,
    ),
  ]) = _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner>
  get serializer =>
      _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerSerializer();
}

class _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner,
    _$AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner,
  ];

  @override
  final String wireName =
      r'AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner object, {
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
    AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner object, {
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
    required AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder
    result,
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
  AdminCaptainChangeLogDtoOutputEntriesInnerChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminCaptainChangeLogDtoOutputEntriesInnerChangesInnerBuilder();
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
