//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_shortfall_preview_answer_dto_output_shortfall.dart';
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_entries_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shortfall_preview_answer_dto_output.g.dart';

/// AdminShortfallPreviewAnswerDtoOutput
///
/// Properties:
/// * [shortfall]
/// * [dues]
/// * [captainCharge]
/// * [entries] - Every entry the resolution would post.
@BuiltValue()
abstract class AdminShortfallPreviewAnswerDtoOutput
    implements
        Built<
          AdminShortfallPreviewAnswerDtoOutput,
          AdminShortfallPreviewAnswerDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'shortfall')
  AdminShortfallPreviewAnswerDtoOutputShortfall get shortfall;

  @BuiltValueField(wireName: r'dues')
  CaptainWentOfflineDtoOutputHandIn? get dues;

  @BuiltValueField(wireName: r'captainCharge')
  CaptainWentOfflineDtoOutputHandIn? get captainCharge;

  /// Every entry the resolution would post.
  @BuiltValueField(wireName: r'entries')
  BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get entries;

  AdminShortfallPreviewAnswerDtoOutput._();

  factory AdminShortfallPreviewAnswerDtoOutput([
    void updates(AdminShortfallPreviewAnswerDtoOutputBuilder b),
  ]) = _$AdminShortfallPreviewAnswerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminShortfallPreviewAnswerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminShortfallPreviewAnswerDtoOutput> get serializer =>
      _$AdminShortfallPreviewAnswerDtoOutputSerializer();
}

class _$AdminShortfallPreviewAnswerDtoOutputSerializer
    implements PrimitiveSerializer<AdminShortfallPreviewAnswerDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminShortfallPreviewAnswerDtoOutput,
    _$AdminShortfallPreviewAnswerDtoOutput,
  ];

  @override
  final String wireName = r'AdminShortfallPreviewAnswerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminShortfallPreviewAnswerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'shortfall';
    yield serializers.serialize(
      object.shortfall,
      specifiedType: const FullType(
        AdminShortfallPreviewAnswerDtoOutputShortfall,
      ),
    );
    yield r'dues';
    yield object.dues == null
        ? null
        : serializers.serialize(
            object.dues,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'captainCharge';
    yield object.captainCharge == null
        ? null
        : serializers.serialize(
            object.captainCharge,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'entries';
    yield serializers.serialize(
      object.entries,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOutcomePreviewAnswerDtoOutputEntriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminShortfallPreviewAnswerDtoOutput object, {
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
    required AdminShortfallPreviewAnswerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'shortfall':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminShortfallPreviewAnswerDtoOutputShortfall,
                    ),
                  )
                  as AdminShortfallPreviewAnswerDtoOutputShortfall;
          result.shortfall.replace(valueDes);
          break;
        case r'dues':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.dues.replace(valueDes);
          break;
        case r'captainCharge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.captainCharge.replace(valueDes);
          break;
        case r'entries':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOutcomePreviewAnswerDtoOutputEntriesInner),
                    ]),
                  )
                  as BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner>;
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
  AdminShortfallPreviewAnswerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminShortfallPreviewAnswerDtoOutputBuilder();
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
