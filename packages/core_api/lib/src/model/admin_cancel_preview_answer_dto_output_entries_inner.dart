//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_cancel_preview_answer_dto_output_entries_inner_amount.dart';
import 'package:core_api/src/model/admin_cancel_preview_answer_dto_output_entries_inner_party.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_preview_answer_dto_output_entries_inner.g.dart';

/// AdminCancelPreviewAnswerDtoOutputEntriesInner
///
/// Properties:
/// * [type] - The journal type, such as merchant.credit.
/// * [account] - The account purpose, such as merchant.account.
/// * [party]
/// * [amount]
@BuiltValue()
abstract class AdminCancelPreviewAnswerDtoOutputEntriesInner
    implements
        Built<
          AdminCancelPreviewAnswerDtoOutputEntriesInner,
          AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  /// The journal type, such as merchant.credit.
  @BuiltValueField(wireName: r'type')
  String get type;

  /// The account purpose, such as merchant.account.
  @BuiltValueField(wireName: r'account')
  String get account;

  @BuiltValueField(wireName: r'party')
  AdminCancelPreviewAnswerDtoOutputEntriesInnerParty get party;

  @BuiltValueField(wireName: r'amount')
  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount get amount;

  AdminCancelPreviewAnswerDtoOutputEntriesInner._();

  factory AdminCancelPreviewAnswerDtoOutputEntriesInner([
    void updates(AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminCancelPreviewAnswerDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelPreviewAnswerDtoOutputEntriesInner>
  get serializer => _$AdminCancelPreviewAnswerDtoOutputEntriesInnerSerializer();
}

class _$AdminCancelPreviewAnswerDtoOutputEntriesInnerSerializer
    implements
        PrimitiveSerializer<AdminCancelPreviewAnswerDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCancelPreviewAnswerDtoOutputEntriesInner,
    _$AdminCancelPreviewAnswerDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminCancelPreviewAnswerDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutputEntriesInner object, {
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
        AdminCancelPreviewAnswerDtoOutputEntriesInnerParty,
      ),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(
        AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutputEntriesInner object, {
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
    required AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder result,
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
                      AdminCancelPreviewAnswerDtoOutputEntriesInnerParty,
                    ),
                  )
                  as AdminCancelPreviewAnswerDtoOutputEntriesInnerParty;
          result.party.replace(valueDes);
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount,
                    ),
                  )
                  as AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount;
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
  AdminCancelPreviewAnswerDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder();
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
