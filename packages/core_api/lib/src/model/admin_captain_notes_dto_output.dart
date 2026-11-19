//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_customer_dto_output_notes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_notes_dto_output.g.dart';

/// AdminCaptainNotesDtoOutput
///
/// Properties:
/// * [notes] - Newest first.
@BuiltValue()
abstract class AdminCaptainNotesDtoOutput
    implements
        Built<AdminCaptainNotesDtoOutput, AdminCaptainNotesDtoOutputBuilder> {
  /// Newest first.
  @BuiltValueField(wireName: r'notes')
  BuiltList<AdminCustomerDtoOutputNotesInner> get notes;

  AdminCaptainNotesDtoOutput._();

  factory AdminCaptainNotesDtoOutput([
    void updates(AdminCaptainNotesDtoOutputBuilder b),
  ]) = _$AdminCaptainNotesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainNotesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainNotesDtoOutput> get serializer =>
      _$AdminCaptainNotesDtoOutputSerializer();
}

class _$AdminCaptainNotesDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainNotesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainNotesDtoOutput,
    _$AdminCaptainNotesDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainNotesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainNotesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'notes';
    yield serializers.serialize(
      object.notes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputNotesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainNotesDtoOutput object, {
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
    required AdminCaptainNotesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'notes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputNotesInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputNotesInner>;
          result.notes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainNotesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainNotesDtoOutputBuilder();
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
