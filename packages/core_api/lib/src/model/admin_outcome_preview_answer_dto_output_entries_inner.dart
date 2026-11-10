//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_entries_inner_amount.dart';
import 'package:core_api/src/model/admin_outcome_preview_answer_dto_output_entries_inner_party.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_preview_answer_dto_output_entries_inner.g.dart';

/// AdminOutcomePreviewAnswerDtoOutputEntriesInner
///
/// Properties:
/// * [type] - The journal type, such as dues.charge.
/// * [reason] - The journal's reason, its line on the party's account (RA §12.5).
/// * [account] - The account purpose, such as customer.dues.
/// * [party]
/// * [amount]
@BuiltValue()
abstract class AdminOutcomePreviewAnswerDtoOutputEntriesInner
    implements
        Built<
          AdminOutcomePreviewAnswerDtoOutputEntriesInner,
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  /// The journal type, such as dues.charge.
  @BuiltValueField(wireName: r'type')
  String get type;

  /// The journal's reason, its line on the party's account (RA §12.5).
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// The account purpose, such as customer.dues.
  @BuiltValueField(wireName: r'account')
  String get account;

  @BuiltValueField(wireName: r'party')
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty get party;

  @BuiltValueField(wireName: r'amount')
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmount get amount;

  AdminOutcomePreviewAnswerDtoOutputEntriesInner._();

  factory AdminOutcomePreviewAnswerDtoOutputEntriesInner([
    void updates(AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminOutcomePreviewAnswerDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomePreviewAnswerDtoOutputEntriesInner>
  get serializer =>
      _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerSerializer();
}

class _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerSerializer
    implements
        PrimitiveSerializer<AdminOutcomePreviewAnswerDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomePreviewAnswerDtoOutputEntriesInner,
    _$AdminOutcomePreviewAnswerDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminOutcomePreviewAnswerDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputEntriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'account';
    yield serializers.serialize(
      object.account,
      specifiedType: const FullType(String),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(
        AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty,
      ),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(
        AdminEditPreviewAnswerDtoOutputEntriesInnerAmount,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputEntriesInner object, {
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
    required AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.type = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'account':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.account = valueDes;
          break;
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty,
                    ),
                  )
                  as AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty;
          result.party.replace(valueDes);
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminEditPreviewAnswerDtoOutputEntriesInnerAmount,
                    ),
                  )
                  as AdminEditPreviewAnswerDtoOutputEntriesInnerAmount;
          result.amount.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder();
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
