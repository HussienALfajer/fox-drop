//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_preview_answer_dto_output_entries_inner_amount.g.dart';

/// From the platform's side: + a debit, − a credit.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class AdminEditPreviewAnswerDtoOutputEntriesInnerAmount
    implements
        Built<
          AdminEditPreviewAnswerDtoOutputEntriesInnerAmount,
          AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminEditPreviewAnswerDtoOutputEntriesInnerAmount._();

  factory AdminEditPreviewAnswerDtoOutputEntriesInnerAmount([
    void updates(AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder b),
  ]) = _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditPreviewAnswerDtoOutputEntriesInnerAmount>
  get serializer =>
      _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmountSerializer();
}

class _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmountSerializer
    implements
        PrimitiveSerializer<AdminEditPreviewAnswerDtoOutputEntriesInnerAmount> {
  @override
  final Iterable<Type> types = const [
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmount,
    _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount,
  ];

  @override
  final String wireName = r'AdminEditPreviewAnswerDtoOutputEntriesInnerAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmount object, {
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
    required AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder();
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
