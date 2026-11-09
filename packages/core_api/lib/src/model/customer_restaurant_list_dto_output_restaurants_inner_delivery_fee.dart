//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output_restaurants_inner_delivery_fee.g.dart';

/// To the point; null while the city has no fee rule in its base currency.
///
/// Properties:
/// * [fee] 
/// * [free] - «توصيل مجاني».
@BuiltValue()
abstract class CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee implements Built<CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee, CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder> {
  @BuiltValueField(wireName: r'fee')
  CaptainWentOfflineDtoOutputHandIn? get fee;

  /// «توصيل مجاني».
  @BuiltValueField(wireName: r'free')
  bool get free;

  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee._();

  factory CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee([void updates(CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder b)]) = _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee> get serializer => _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeSerializer();
}

class _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeSerializer implements PrimitiveSerializer<CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee> {
  @override
  final Iterable<Type> types = const [CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee, _$CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee];

  @override
  final String wireName = r'CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fee';
    yield object.fee == null ? null : serializers.serialize(
      object.fee,
      specifiedType: const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
    );
    yield r'free';
    yield serializers.serialize(
      object.free,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
          ) as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.fee.replace(valueDes);
          break;
        case r'free':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.free = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder();
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


