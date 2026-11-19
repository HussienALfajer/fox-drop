//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_request_option_price_delta.g.dart';

/// 0 or more; a published option's delta changes through «تعديل السعر» only.
///
/// Properties:
/// * [amount] - Integer minor units of the base (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class MerchantRequestOptionPriceDelta
    implements
        Built<
          MerchantRequestOptionPriceDelta,
          MerchantRequestOptionPriceDeltaBuilder
        > {
  /// Integer minor units of the base (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  MerchantRequestOptionPriceDelta._();

  factory MerchantRequestOptionPriceDelta([
    void updates(MerchantRequestOptionPriceDeltaBuilder b),
  ]) = _$MerchantRequestOptionPriceDelta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRequestOptionPriceDeltaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRequestOptionPriceDelta> get serializer =>
      _$MerchantRequestOptionPriceDeltaSerializer();
}

class _$MerchantRequestOptionPriceDeltaSerializer
    implements PrimitiveSerializer<MerchantRequestOptionPriceDelta> {
  @override
  final Iterable<Type> types = const [
    MerchantRequestOptionPriceDelta,
    _$MerchantRequestOptionPriceDelta,
  ];

  @override
  final String wireName = r'MerchantRequestOptionPriceDelta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRequestOptionPriceDelta object, {
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
    MerchantRequestOptionPriceDelta object, {
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
    required MerchantRequestOptionPriceDeltaBuilder result,
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
  MerchantRequestOptionPriceDelta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRequestOptionPriceDeltaBuilder();
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
