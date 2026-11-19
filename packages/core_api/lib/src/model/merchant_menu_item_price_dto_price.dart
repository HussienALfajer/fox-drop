//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_item_price_dto_price.g.dart';

/// Above 0 (RA §9.4).
///
/// Properties:
/// * [amount] - Integer minor units of the base (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class MerchantMenuItemPriceDtoPrice
    implements
        Built<
          MerchantMenuItemPriceDtoPrice,
          MerchantMenuItemPriceDtoPriceBuilder
        > {
  /// Integer minor units of the base (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  MerchantMenuItemPriceDtoPrice._();

  factory MerchantMenuItemPriceDtoPrice([
    void updates(MerchantMenuItemPriceDtoPriceBuilder b),
  ]) = _$MerchantMenuItemPriceDtoPrice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuItemPriceDtoPriceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuItemPriceDtoPrice> get serializer =>
      _$MerchantMenuItemPriceDtoPriceSerializer();
}

class _$MerchantMenuItemPriceDtoPriceSerializer
    implements PrimitiveSerializer<MerchantMenuItemPriceDtoPrice> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuItemPriceDtoPrice,
    _$MerchantMenuItemPriceDtoPrice,
  ];

  @override
  final String wireName = r'MerchantMenuItemPriceDtoPrice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuItemPriceDtoPrice object, {
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
    MerchantMenuItemPriceDtoPrice object, {
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
    required MerchantMenuItemPriceDtoPriceBuilder result,
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
  MerchantMenuItemPriceDtoPrice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuItemPriceDtoPriceBuilder();
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
