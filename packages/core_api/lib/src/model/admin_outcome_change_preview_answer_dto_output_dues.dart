//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_change_preview_answer_dto_output_dues.g.dart';

/// The customer's dues (AP §8.8), with the customer responsible.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class AdminOutcomeChangePreviewAnswerDtoOutputDues
    implements
        Built<
          AdminOutcomeChangePreviewAnswerDtoOutputDues,
          AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminOutcomeChangePreviewAnswerDtoOutputDues._();

  factory AdminOutcomeChangePreviewAnswerDtoOutputDues([
    void updates(AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder b),
  ]) = _$AdminOutcomeChangePreviewAnswerDtoOutputDues;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomeChangePreviewAnswerDtoOutputDues>
  get serializer => _$AdminOutcomeChangePreviewAnswerDtoOutputDuesSerializer();
}

class _$AdminOutcomeChangePreviewAnswerDtoOutputDuesSerializer
    implements
        PrimitiveSerializer<AdminOutcomeChangePreviewAnswerDtoOutputDues> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomeChangePreviewAnswerDtoOutputDues,
    _$AdminOutcomeChangePreviewAnswerDtoOutputDues,
  ];

  @override
  final String wireName = r'AdminOutcomeChangePreviewAnswerDtoOutputDues';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomeChangePreviewAnswerDtoOutputDues object, {
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
    AdminOutcomeChangePreviewAnswerDtoOutputDues object, {
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
    required AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder result,
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
  AdminOutcomeChangePreviewAnswerDtoOutputDues deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder();
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
