//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_manual_entries_dto_output_entries_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_entries_dto_output.g.dart';

/// AdminManualEntriesDtoOutput
///
/// Properties:
/// * [entries]
@BuiltValue()
abstract class AdminManualEntriesDtoOutput
    implements
        Built<AdminManualEntriesDtoOutput, AdminManualEntriesDtoOutputBuilder> {
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminManualEntriesDtoOutputEntriesInner> get entries;

  AdminManualEntriesDtoOutput._();

  factory AdminManualEntriesDtoOutput([
    void updates(AdminManualEntriesDtoOutputBuilder b),
  ]) = _$AdminManualEntriesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualEntriesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualEntriesDtoOutput> get serializer =>
      _$AdminManualEntriesDtoOutputSerializer();
}

class _$AdminManualEntriesDtoOutputSerializer
    implements PrimitiveSerializer<AdminManualEntriesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminManualEntriesDtoOutput,
    _$AdminManualEntriesDtoOutput,
  ];

  @override
  final String wireName = r'AdminManualEntriesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualEntriesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminManualEntriesDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutput object, {
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
    required AdminManualEntriesDtoOutputBuilder result,
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
                      FullType(AdminManualEntriesDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminManualEntriesDtoOutputEntriesInner>;
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
  AdminManualEntriesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualEntriesDtoOutputBuilder();
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
