//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_option_price_dto_price_delta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_option_price_dto.g.dart';

/// MerchantMenuOptionPriceDto
///
/// Properties:
/// * [priceDelta]
@BuiltValue()
abstract class MerchantMenuOptionPriceDto
    implements
        Built<MerchantMenuOptionPriceDto, MerchantMenuOptionPriceDtoBuilder> {
  @BuiltValueField(wireName: r'priceDelta')
  MerchantMenuOptionPriceDtoPriceDelta get priceDelta;

  MerchantMenuOptionPriceDto._();

  factory MerchantMenuOptionPriceDto([
    void updates(MerchantMenuOptionPriceDtoBuilder b),
  ]) = _$MerchantMenuOptionPriceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuOptionPriceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuOptionPriceDto> get serializer =>
      _$MerchantMenuOptionPriceDtoSerializer();
}

class _$MerchantMenuOptionPriceDtoSerializer
    implements PrimitiveSerializer<MerchantMenuOptionPriceDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuOptionPriceDto,
    _$MerchantMenuOptionPriceDto,
  ];

  @override
  final String wireName = r'MerchantMenuOptionPriceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuOptionPriceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(MerchantMenuOptionPriceDtoPriceDelta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuOptionPriceDto object, {
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
    required MerchantMenuOptionPriceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuOptionPriceDtoPriceDelta,
                    ),
                  )
                  as MerchantMenuOptionPriceDtoPriceDelta;
          result.priceDelta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuOptionPriceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuOptionPriceDtoBuilder();
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
