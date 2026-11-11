//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_page_dto_output_delivery_fee.g.dart';

/// To the point; null while the city has no fee rule in its base currency.
///
/// Properties:
/// * [fee] 
/// * [free] - «توصيل مجاني».
@BuiltValue()
abstract class CustomerRestaurantPageDtoOutputDeliveryFee implements Built<CustomerRestaurantPageDtoOutputDeliveryFee, CustomerRestaurantPageDtoOutputDeliveryFeeBuilder> {
  @BuiltValueField(wireName: r'fee')
  CaptainAvailabilityDtoOutputCustodyLimit get fee;

  /// «توصيل مجاني».
  @BuiltValueField(wireName: r'free')
  bool get free;

  CustomerRestaurantPageDtoOutputDeliveryFee._();

  factory CustomerRestaurantPageDtoOutputDeliveryFee([void updates(CustomerRestaurantPageDtoOutputDeliveryFeeBuilder b)]) = _$CustomerRestaurantPageDtoOutputDeliveryFee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantPageDtoOutputDeliveryFeeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantPageDtoOutputDeliveryFee> get serializer => _$CustomerRestaurantPageDtoOutputDeliveryFeeSerializer();
}

class _$CustomerRestaurantPageDtoOutputDeliveryFeeSerializer implements PrimitiveSerializer<CustomerRestaurantPageDtoOutputDeliveryFee> {
  @override
  final Iterable<Type> types = const [CustomerRestaurantPageDtoOutputDeliveryFee, _$CustomerRestaurantPageDtoOutputDeliveryFee];

  @override
  final String wireName = r'CustomerRestaurantPageDtoOutputDeliveryFee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputDeliveryFee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fee';
    yield serializers.serialize(
      object.fee,
      specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
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
    CustomerRestaurantPageDtoOutputDeliveryFee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerRestaurantPageDtoOutputDeliveryFeeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainAvailabilityDtoOutputCustodyLimit),
          ) as CaptainAvailabilityDtoOutputCustodyLimit;
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
  CustomerRestaurantPageDtoOutputDeliveryFee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantPageDtoOutputDeliveryFeeBuilder();
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


