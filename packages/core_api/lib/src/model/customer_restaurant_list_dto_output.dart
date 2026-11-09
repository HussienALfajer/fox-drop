//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_restaurant_list_dto_output_restaurants_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_list_dto_output.g.dart';

/// CustomerRestaurantListDtoOutput
///
/// Properties:
/// * [restaurants] - CU §8.2: open first, then busy and paused, then closed; with similarTo, the open ones only (CU §11.9).
@BuiltValue()
abstract class CustomerRestaurantListDtoOutput
    implements
        Built<
          CustomerRestaurantListDtoOutput,
          CustomerRestaurantListDtoOutputBuilder
        > {
  /// CU §8.2: open first, then busy and paused, then closed; with similarTo, the open ones only (CU §11.9).
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CustomerRestaurantListDtoOutputRestaurantsInner> get restaurants;

  CustomerRestaurantListDtoOutput._();

  factory CustomerRestaurantListDtoOutput([
    void updates(CustomerRestaurantListDtoOutputBuilder b),
  ]) = _$CustomerRestaurantListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantListDtoOutput> get serializer =>
      _$CustomerRestaurantListDtoOutputSerializer();
}

class _$CustomerRestaurantListDtoOutputSerializer
    implements PrimitiveSerializer<CustomerRestaurantListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerRestaurantListDtoOutput,
    _$CustomerRestaurantListDtoOutput,
  ];

  @override
  final String wireName = r'CustomerRestaurantListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerRestaurantListDtoOutputRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutput object, {
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
    required CustomerRestaurantListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerRestaurantListDtoOutputRestaurantsInner),
                    ]),
                  )
                  as BuiltList<CustomerRestaurantListDtoOutputRestaurantsInner>;
          result.restaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantListDtoOutputBuilder();
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
