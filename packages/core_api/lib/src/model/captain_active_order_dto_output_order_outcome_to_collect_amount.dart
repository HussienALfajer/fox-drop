//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_outcome_to_collect_amount.g.dart';

/// The amount due on the payment screen (CA §9.7).
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount,
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount._();

  factory CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount([
    void updates(
      CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder b,
    ),
  ]) = _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount
        > {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount,
    _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount,
  ];

  @override
  final String wireName =
      r'CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount object, {
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
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount object, {
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
    required CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder
    result,
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
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder();
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
