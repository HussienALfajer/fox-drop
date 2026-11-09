//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/admin_cancel_preview_answer_dto_output_entries_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_preview_answer_dto_output.g.dart';

/// AdminCancelPreviewAnswerDtoOutput
///
/// Properties:
/// * [entries] - Every entry the cancellation would post (docs/domain/09).
/// * [cashAsked] - The captain reached the restaurant: ask the cash question.
/// * [compensationAllowed] - «تعويض الكابتن» may be chosen.
/// * [cashLines] - While asked: what the captain paid (the last pickup request's lines, or the items value).
/// * [strike] - The customer gets a late-cancellation strike (docs/domain/08): from accepted or ready with the customer responsible.
@BuiltValue()
abstract class AdminCancelPreviewAnswerDtoOutput
    implements
        Built<
          AdminCancelPreviewAnswerDtoOutput,
          AdminCancelPreviewAnswerDtoOutputBuilder
        > {
  /// Every entry the cancellation would post (docs/domain/09).
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminCancelPreviewAnswerDtoOutputEntriesInner> get entries;

  /// The captain reached the restaurant: ask the cash question.
  @BuiltValueField(wireName: r'cashAsked')
  bool get cashAsked;

  /// «تعويض الكابتن» may be chosen.
  @BuiltValueField(wireName: r'compensationAllowed')
  bool get compensationAllowed;

  /// While asked: what the captain paid (the last pickup request's lines, or the items value).
  @BuiltValueField(wireName: r'cashLines')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?>? get cashLines;

  /// The customer gets a late-cancellation strike (docs/domain/08): from accepted or ready with the customer responsible.
  @BuiltValueField(wireName: r'strike')
  bool get strike;

  AdminCancelPreviewAnswerDtoOutput._();

  factory AdminCancelPreviewAnswerDtoOutput([
    void updates(AdminCancelPreviewAnswerDtoOutputBuilder b),
  ]) = _$AdminCancelPreviewAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCancelPreviewAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelPreviewAnswerDtoOutput> get serializer =>
      _$AdminCancelPreviewAnswerDtoOutputSerializer();
}

class _$AdminCancelPreviewAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminCancelPreviewAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCancelPreviewAnswerDtoOutput,
    _$AdminCancelPreviewAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminCancelPreviewAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCancelPreviewAnswerDtoOutputEntriesInner),
      ]),
    );
    yield r'cashAsked';
    yield serializers.serialize(
      object.cashAsked,
      specifiedType: const FullType(bool),
    );
    yield r'compensationAllowed';
    yield serializers.serialize(
      object.compensationAllowed,
      specifiedType: const FullType(bool),
    );
    yield r'cashLines';
    yield object.cashLines == null
        ? null
        : serializers.serialize(
            object.cashLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
            ]),
          );
    yield r'strike';
    yield serializers.serialize(
      object.strike,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutput object, {
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
    required AdminCancelPreviewAnswerDtoOutputBuilder result,
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
                      FullType(AdminCancelPreviewAnswerDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminCancelPreviewAnswerDtoOutputEntriesInner>;
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
        case r'compensationAllowed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.compensationAllowed = valueDes;
          break;
        case r'cashLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
                    ]),
                  )
                  as BuiltList<CaptainWentOfflineDtoOutputHandIn?>?;
          if (valueDes == null) continue;
          result.cashLines.replace(valueDes);
          break;
        case r'strike':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.strike = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCancelPreviewAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelPreviewAnswerDtoOutputBuilder();
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
