//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cancel_preview_answer_dto_output_entries_inner_amount.g.dart';

/// From the platform's side: + a debit, − a credit.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount
    implements
        Built<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount,
          AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount._();

  factory AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount([
    void updates(AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder b),
  ]) = _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount>
  get serializer =>
      _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountSerializer();
}

class _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountSerializer
    implements
        PrimitiveSerializer<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount
        > {
  @override
  final Iterable<Type> types = const [
    AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount,
    _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount,
  ];

  @override
  final String wireName =
      r'AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount object, {
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
    AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount object, {
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
    required AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder result,
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
  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder();
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
