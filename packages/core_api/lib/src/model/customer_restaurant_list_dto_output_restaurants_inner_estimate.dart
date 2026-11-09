//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output_restaurants_inner_estimate.g.dart';

/// CU §8.4: «{fromMin}–{toMin} د».
///
/// Properties:
/// * [fromMin] 
/// * [toMin] 
@BuiltValue()
abstract class CustomerRestaurantListDtoOutputRestaurantsInnerEstimate implements Built<CustomerRestaurantListDtoOutputRestaurantsInnerEstimate, CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder> {
  @BuiltValueField(wireName: r'fromMin')
  int get fromMin;

  @BuiltValueField(wireName: r'toMin')
  int get toMin;

  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate._();

  factory CustomerRestaurantListDtoOutputRestaurantsInnerEstimate([void updates(CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder b)]) = _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutputRestaurantsInnerEstimate> get serializer => _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimateSerializer();
}

class _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimateSerializer implements PrimitiveSerializer<CustomerRestaurantListDtoOutputRestaurantsInnerEstimate> {
  @override
  final Iterable<Type> types = const [CustomerRestaurantListDtoOutputRestaurantsInnerEstimate, _$CustomerRestaurantListDtoOutputRestaurantsInnerEstimate];

  @override
  final String wireName = r'CustomerRestaurantListDtoOutputRestaurantsInnerEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromMin';
    yield serializers.serialize(
      object.fromMin,
      specifiedType: const FullType(int),
    );
    yield r'toMin';
    yield serializers.serialize(
      object.toMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fromMin = valueDes;
          break;
        case r'toMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.toMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder();
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


