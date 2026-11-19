//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_option_price_dto_price_delta.g.dart';

/// 0 or more (RA §9.4).
///
/// Properties:
/// * [amount] - Integer minor units of the base (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class MerchantMenuOptionPriceDtoPriceDelta
    implements
        Built<
          MerchantMenuOptionPriceDtoPriceDelta,
          MerchantMenuOptionPriceDtoPriceDeltaBuilder
        > {
  /// Integer minor units of the base (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  MerchantMenuOptionPriceDtoPriceDelta._();

  factory MerchantMenuOptionPriceDtoPriceDelta([
    void updates(MerchantMenuOptionPriceDtoPriceDeltaBuilder b),
  ]) = _$MerchantMenuOptionPriceDtoPriceDelta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuOptionPriceDtoPriceDeltaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuOptionPriceDtoPriceDelta> get serializer =>
      _$MerchantMenuOptionPriceDtoPriceDeltaSerializer();
}

class _$MerchantMenuOptionPriceDtoPriceDeltaSerializer
    implements PrimitiveSerializer<MerchantMenuOptionPriceDtoPriceDelta> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuOptionPriceDtoPriceDelta,
    _$MerchantMenuOptionPriceDtoPriceDelta,
  ];

  @override
  final String wireName = r'MerchantMenuOptionPriceDtoPriceDelta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuOptionPriceDtoPriceDelta object, {
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
    MerchantMenuOptionPriceDtoPriceDelta object, {
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
    required MerchantMenuOptionPriceDtoPriceDeltaBuilder result,
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
  MerchantMenuOptionPriceDtoPriceDelta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuOptionPriceDtoPriceDeltaBuilder();
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
