//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_no_answer_answer.g.dart';

/// The customer's latest answer to a ping.
///
/// Properties:
/// * [answer] - «الزبون رأى التنبيه وهو قادم», or «الزبون يتواصل مع المستلم» for an order with a recipient.
/// * [at]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderNoAnswerAnswer
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderNoAnswerAnswer,
          CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder
        > {
  /// «الزبون رأى التنبيه وهو قادم», or «الزبون يتواصل مع المستلم» for an order with a recipient.
  @BuiltValueField(wireName: r'answer')
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum get answer;
  // enum answerEnum {  coming,  contacting_recipient,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  CaptainActiveOrderDtoOutputOrderNoAnswerAnswer._();

  factory CaptainActiveOrderDtoOutputOrderNoAnswerAnswer([
    void updates(CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderNoAnswerAnswer>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswerSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswerSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderNoAnswerAnswer> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswer,
    _$CaptainActiveOrderDtoOutputOrderNoAnswerAnswer,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderNoAnswerAnswer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'answer';
    yield serializers.serialize(
      object.answer,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum,
      ),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderNoAnswerAnswer object, {
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
    required CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum;
          result.answer = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderNoAnswerAnswer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderNoAnswerAnswerBuilder();
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

/// «الزبون رأى التنبيه وهو قادم», or «الزبون يتواصل مع المستلم» for an order with a recipient.
class CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'coming')
  static const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum coming =
      _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_coming;
  @BuiltValueEnumConst(wireName: r'contacting_recipient')
  static const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum
  contactingRecipient =
      _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum_contactingRecipient;

  static Serializer<CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum>
  get values =>
      _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumValues;
  static CaptainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderNoAnswerAnswerAnswerEnumValueOf(name);
}
