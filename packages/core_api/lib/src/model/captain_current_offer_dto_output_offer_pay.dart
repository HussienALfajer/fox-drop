//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_pay.g.dart';

/// The order pay, the largest text; «قد يُضاف أجر انتظار». Null without a pay table.
///
/// Properties:
/// * [amount] - Minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferPay
    implements
        Built<
          CaptainCurrentOfferDtoOutputOfferPay,
          CaptainCurrentOfferDtoOutputOfferPayBuilder
        > {
  /// Minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainCurrentOfferDtoOutputOfferPay._();

  factory CaptainCurrentOfferDtoOutputOfferPay([
    void updates(CaptainCurrentOfferDtoOutputOfferPayBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutputOfferPay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputOfferPayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferPay> get serializer =>
      _$CaptainCurrentOfferDtoOutputOfferPaySerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferPaySerializer
    implements PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferPay> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutputOfferPay,
    _$CaptainCurrentOfferDtoOutputOfferPay,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferPay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferPay object, {
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
    CaptainCurrentOfferDtoOutputOfferPay object, {
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
    required CaptainCurrentOfferDtoOutputOfferPayBuilder result,
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
  CaptainCurrentOfferDtoOutputOfferPay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferPayBuilder();
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
