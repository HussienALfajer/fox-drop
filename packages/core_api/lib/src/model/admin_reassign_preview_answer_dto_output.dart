//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_reassign_preview_answer_dto_output_entries_inner.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reassign_preview_answer_dto_output.g.dart';

/// AdminReassignPreviewAnswerDtoOutput
///
/// Properties:
/// * [entries] - Every entry the reassignment would post (docs/domain/09): the kept payment only.
/// * [cashAsked] - The captain reached the restaurant: ask the cash question.
/// * [cashLines] - While asked: what the captain paid (the last pickup request's lines, or the items value).
@BuiltValue()
abstract class AdminReassignPreviewAnswerDtoOutput
    implements
        Built<
          AdminReassignPreviewAnswerDtoOutput,
          AdminReassignPreviewAnswerDtoOutputBuilder
        > {
  /// Every entry the reassignment would post (docs/domain/09): the kept payment only.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminReassignPreviewAnswerDtoOutputEntriesInner> get entries;

  /// The captain reached the restaurant: ask the cash question.
  @BuiltValueField(wireName: r'cashAsked')
  bool get cashAsked;

  /// While asked: what the captain paid (the last pickup request's lines, or the items value).
  @BuiltValueField(wireName: r'cashLines')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? get cashLines;

  AdminReassignPreviewAnswerDtoOutput._();

  factory AdminReassignPreviewAnswerDtoOutput([
    void updates(AdminReassignPreviewAnswerDtoOutputBuilder b),
  ]) = _$AdminReassignPreviewAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReassignPreviewAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReassignPreviewAnswerDtoOutput> get serializer =>
      _$AdminReassignPreviewAnswerDtoOutputSerializer();
}

class _$AdminReassignPreviewAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminReassignPreviewAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminReassignPreviewAnswerDtoOutput,
    _$AdminReassignPreviewAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminReassignPreviewAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReassignPreviewAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminReassignPreviewAnswerDtoOutputEntriesInner),
      ]),
    );
    yield r'cashAsked';
    yield serializers.serialize(
      object.cashAsked,
      specifiedType: const FullType(bool),
    );
    yield r'cashLines';
    yield object.cashLines == null
        ? null
        : serializers.serialize(
            object.cashLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(CaptainAvailabilityDtoOutputCustodyLimit),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReassignPreviewAnswerDtoOutput object, {
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
    required AdminReassignPreviewAnswerDtoOutputBuilder result,
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
                      FullType(AdminReassignPreviewAnswerDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminReassignPreviewAnswerDtoOutputEntriesInner>;
          result.entries.replace(valueDes);
          break;
        case r'cashAsked':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.cashAsked = valueDes;
          break;
        case r'cashLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(CaptainAvailabilityDtoOutputCustodyLimit),
                    ]),
                  )
                  as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>?;
          if (valueDes == null) continue;
          result.cashLines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReassignPreviewAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReassignPreviewAnswerDtoOutputBuilder();
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
