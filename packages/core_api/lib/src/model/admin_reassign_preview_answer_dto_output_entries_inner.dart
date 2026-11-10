//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_entries_inner_amount.dart';
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_entries_inner_party.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_reassign_preview_answer_dto_output_entries_inner.g.dart';

/// AdminReassignPreviewAnswerDtoOutputEntriesInner
///
/// Properties:
/// * [type] - The journal type, such as custody.pay_merchant.
/// * [account] - The account purpose, such as captain.custody.
/// * [party]
/// * [amount]
@BuiltValue()
abstract class AdminReassignPreviewAnswerDtoOutputEntriesInner
    implements
        Built<
          AdminReassignPreviewAnswerDtoOutputEntriesInner,
          AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  /// The journal type, such as custody.pay_merchant.
  @BuiltValueField(wireName: r'type')
  String get type;

  /// The account purpose, such as captain.custody.
  @BuiltValueField(wireName: r'account')
  String get account;

  @BuiltValueField(wireName: r'party')
  AdminEditPreviewAnswerDtoOutputEntriesInnerParty get party;

  @BuiltValueField(wireName: r'amount')
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmount get amount;

  AdminReassignPreviewAnswerDtoOutputEntriesInner._();

  factory AdminReassignPreviewAnswerDtoOutputEntriesInner([
    void updates(AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminReassignPreviewAnswerDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReassignPreviewAnswerDtoOutputEntriesInner>
  get serializer =>
      _$AdminReassignPreviewAnswerDtoOutputEntriesInnerSerializer();
}

class _$AdminReassignPreviewAnswerDtoOutputEntriesInnerSerializer
    implements
        PrimitiveSerializer<AdminReassignPreviewAnswerDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminReassignPreviewAnswerDtoOutputEntriesInner,
    _$AdminReassignPreviewAnswerDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminReassignPreviewAnswerDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReassignPreviewAnswerDtoOutputEntriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
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
        AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
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
    AdminReassignPreviewAnswerDtoOutputEntriesInner object, {
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
    required AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder result,
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
                      AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
                    ),
                  )
                  as AdminEditPreviewAnswerDtoOutputEntriesInnerParty;
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
  AdminReassignPreviewAnswerDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder();
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
