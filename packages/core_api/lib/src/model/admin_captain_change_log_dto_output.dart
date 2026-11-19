//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_change_log_dto_output_entries_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_change_log_dto_output.g.dart';

/// AdminCaptainChangeLogDtoOutput
///
/// Properties:
/// * [entries] - The latest 200 changes, newest first.
@BuiltValue()
abstract class AdminCaptainChangeLogDtoOutput
    implements
        Built<
          AdminCaptainChangeLogDtoOutput,
          AdminCaptainChangeLogDtoOutputBuilder
        > {
  /// The latest 200 changes, newest first.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminCaptainChangeLogDtoOutputEntriesInner> get entries;

  AdminCaptainChangeLogDtoOutput._();

  factory AdminCaptainChangeLogDtoOutput([
    void updates(AdminCaptainChangeLogDtoOutputBuilder b),
  ]) = _$AdminCaptainChangeLogDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainChangeLogDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainChangeLogDtoOutput> get serializer =>
      _$AdminCaptainChangeLogDtoOutputSerializer();
}

class _$AdminCaptainChangeLogDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainChangeLogDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainChangeLogDtoOutput,
    _$AdminCaptainChangeLogDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainChangeLogDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainChangeLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainChangeLogDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainChangeLogDtoOutput object, {
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
    required AdminCaptainChangeLogDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainChangeLogDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainChangeLogDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainChangeLogDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainChangeLogDtoOutputBuilder();
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
