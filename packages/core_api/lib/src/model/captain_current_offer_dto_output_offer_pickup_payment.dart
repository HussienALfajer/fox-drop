//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_pickup_payment.g.dart';

/// «تدفع للمطعم» (D26: the items value).
///
/// Properties:
/// * [amount] - Minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferPickupPayment
    implements
        Built<
          CaptainCurrentOfferDtoOutputOfferPickupPayment,
          CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder
        > {
  /// Minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainCurrentOfferDtoOutputOfferPickupPayment._();

  factory CaptainCurrentOfferDtoOutputOfferPickupPayment([
    void updates(CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutputOfferPickupPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferPickupPayment>
  get serializer =>
      _$CaptainCurrentOfferDtoOutputOfferPickupPaymentSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferPickupPaymentSerializer
    implements
        PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferPickupPayment> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutputOfferPickupPayment,
    _$CaptainCurrentOfferDtoOutputOfferPickupPayment,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferPickupPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferPickupPayment object, {
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
    CaptainCurrentOfferDtoOutputOfferPickupPayment object, {
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
    required CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder result,
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
  CaptainCurrentOfferDtoOutputOfferPickupPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder();
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
