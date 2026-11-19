//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_item_price_dto_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_item_price_dto.g.dart';

/// MerchantMenuItemPriceDto
///
/// Properties:
/// * [price]
@BuiltValue()
abstract class MerchantMenuItemPriceDto
    implements
        Built<MerchantMenuItemPriceDto, MerchantMenuItemPriceDtoBuilder> {
  @BuiltValueField(wireName: r'price')
  MerchantMenuItemPriceDtoPrice get price;

  MerchantMenuItemPriceDto._();

  factory MerchantMenuItemPriceDto([
    void updates(MerchantMenuItemPriceDtoBuilder b),
  ]) = _$MerchantMenuItemPriceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuItemPriceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuItemPriceDto> get serializer =>
      _$MerchantMenuItemPriceDtoSerializer();
}

class _$MerchantMenuItemPriceDtoSerializer
    implements PrimitiveSerializer<MerchantMenuItemPriceDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuItemPriceDto,
    _$MerchantMenuItemPriceDto,
  ];

  @override
  final String wireName = r'MerchantMenuItemPriceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuItemPriceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(MerchantMenuItemPriceDtoPrice),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuItemPriceDto object, {
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
    required MerchantMenuItemPriceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuItemPriceDtoPrice,
                    ),
                  )
                  as MerchantMenuItemPriceDtoPrice;
          result.price.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuItemPriceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuItemPriceDtoBuilder();
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
