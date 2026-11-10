//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_outcome_preview_answer_dto_output_loss.g.dart';

/// docs/domain/09 rule 3: what the responsible party bears for the food.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class AdminOutcomePreviewAnswerDtoOutputLoss
    implements
        Built<
          AdminOutcomePreviewAnswerDtoOutputLoss,
          AdminOutcomePreviewAnswerDtoOutputLossBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminOutcomePreviewAnswerDtoOutputLoss._();

  factory AdminOutcomePreviewAnswerDtoOutputLoss([
    void updates(AdminOutcomePreviewAnswerDtoOutputLossBuilder b),
  ]) = _$AdminOutcomePreviewAnswerDtoOutputLoss;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOutcomePreviewAnswerDtoOutputLossBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOutcomePreviewAnswerDtoOutputLoss> get serializer =>
      _$AdminOutcomePreviewAnswerDtoOutputLossSerializer();
}

class _$AdminOutcomePreviewAnswerDtoOutputLossSerializer
    implements PrimitiveSerializer<AdminOutcomePreviewAnswerDtoOutputLoss> {
  @override
  final Iterable<Type> types = const [
    AdminOutcomePreviewAnswerDtoOutputLoss,
    _$AdminOutcomePreviewAnswerDtoOutputLoss,
  ];

  @override
  final String wireName = r'AdminOutcomePreviewAnswerDtoOutputLoss';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputLoss object, {
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
    AdminOutcomePreviewAnswerDtoOutputLoss object, {
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
    required AdminOutcomePreviewAnswerDtoOutputLossBuilder result,
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
  AdminOutcomePreviewAnswerDtoOutputLoss deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOutcomePreviewAnswerDtoOutputLossBuilder();
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
