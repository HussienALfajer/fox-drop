//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_offer_dto_output_offer_peak_bonus.g.dart';

/// «يشمل مكافأة الذروة +{المبلغ}» (AP §9.12.5, D15), included in pay; null outside a window.
///
/// Properties:
/// * [amount] - Minor units of the currency, as a string.
/// * [currency]
@BuiltValue()
abstract class CaptainOfferDtoOutputOfferPeakBonus
    implements
        Built<
          CaptainOfferDtoOutputOfferPeakBonus,
          CaptainOfferDtoOutputOfferPeakBonusBuilder
        > {
  /// Minor units of the currency, as a string.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainOfferDtoOutputOfferPeakBonus._();

  factory CaptainOfferDtoOutputOfferPeakBonus([
    void updates(CaptainOfferDtoOutputOfferPeakBonusBuilder b),
  ]) = _$CaptainOfferDtoOutputOfferPeakBonus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOfferDtoOutputOfferPeakBonusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOfferDtoOutputOfferPeakBonus> get serializer =>
      _$CaptainOfferDtoOutputOfferPeakBonusSerializer();
}

class _$CaptainOfferDtoOutputOfferPeakBonusSerializer
    implements PrimitiveSerializer<CaptainOfferDtoOutputOfferPeakBonus> {
  @override
  final Iterable<Type> types = const [
    CaptainOfferDtoOutputOfferPeakBonus,
    _$CaptainOfferDtoOutputOfferPeakBonus,
  ];

  @override
  final String wireName = r'CaptainOfferDtoOutputOfferPeakBonus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOfferDtoOutputOfferPeakBonus object, {
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
    CaptainOfferDtoOutputOfferPeakBonus object, {
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
    required CaptainOfferDtoOutputOfferPeakBonusBuilder result,
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
  CaptainOfferDtoOutputOfferPeakBonus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOfferDtoOutputOfferPeakBonusBuilder();
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
