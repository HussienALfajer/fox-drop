//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_ticket_correction_dto_output_entries_inner_amount.dart';
import 'package:core_api/src/model/admin_edit_preview_answer_dto_output_entries_inner_party.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_correction_dto_output_entries_inner.g.dart';

/// AdminTicketCorrectionDtoOutputEntriesInner
///
/// Properties:
/// * [type]
/// * [reason]
/// * [account]
/// * [party]
/// * [amount]
@BuiltValue()
abstract class AdminTicketCorrectionDtoOutputEntriesInner
    implements
        Built<
          AdminTicketCorrectionDtoOutputEntriesInner,
          AdminTicketCorrectionDtoOutputEntriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'account')
  String get account;

  @BuiltValueField(wireName: r'party')
  AdminEditPreviewAnswerDtoOutputEntriesInnerParty get party;

  @BuiltValueField(wireName: r'amount')
  AdminTicketCorrectionDtoOutputEntriesInnerAmount get amount;

  AdminTicketCorrectionDtoOutputEntriesInner._();

  factory AdminTicketCorrectionDtoOutputEntriesInner([
    void updates(AdminTicketCorrectionDtoOutputEntriesInnerBuilder b),
  ]) = _$AdminTicketCorrectionDtoOutputEntriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketCorrectionDtoOutputEntriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketCorrectionDtoOutputEntriesInner>
  get serializer => _$AdminTicketCorrectionDtoOutputEntriesInnerSerializer();
}

class _$AdminTicketCorrectionDtoOutputEntriesInnerSerializer
    implements PrimitiveSerializer<AdminTicketCorrectionDtoOutputEntriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketCorrectionDtoOutputEntriesInner,
    _$AdminTicketCorrectionDtoOutputEntriesInner,
  ];

  @override
  final String wireName = r'AdminTicketCorrectionDtoOutputEntriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketCorrectionDtoOutputEntriesInner object, {
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
        AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
      ),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(
        AdminTicketCorrectionDtoOutputEntriesInnerAmount,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketCorrectionDtoOutputEntriesInner object, {
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
    required AdminTicketCorrectionDtoOutputEntriesInnerBuilder result,
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
                      AdminTicketCorrectionDtoOutputEntriesInnerAmount,
                    ),
                  )
                  as AdminTicketCorrectionDtoOutputEntriesInnerAmount;
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
  AdminTicketCorrectionDtoOutputEntriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketCorrectionDtoOutputEntriesInnerBuilder();
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
