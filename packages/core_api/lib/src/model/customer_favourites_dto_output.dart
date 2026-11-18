//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_search_dto_output_restaurants_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_favourites_dto_output.g.dart';

/// CustomerFavouritesDtoOutput
///
/// Properties:
/// * [restaurants] - CU §9.6 «المفضلة»: the favourites that deliver to the point, with their state and estimate, open first and closed last; the others are left out.
@BuiltValue()
abstract class CustomerFavouritesDtoOutput
    implements
        Built<CustomerFavouritesDtoOutput, CustomerFavouritesDtoOutputBuilder> {
  /// CU §9.6 «المفضلة»: the favourites that deliver to the point, with their state and estimate, open first and closed last; the others are left out.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CustomerSearchDtoOutputRestaurantsInner> get restaurants;

  CustomerFavouritesDtoOutput._();

  factory CustomerFavouritesDtoOutput([
    void updates(CustomerFavouritesDtoOutputBuilder b),
  ]) = _$CustomerFavouritesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerFavouritesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerFavouritesDtoOutput> get serializer =>
      _$CustomerFavouritesDtoOutputSerializer();
}

class _$CustomerFavouritesDtoOutputSerializer
    implements PrimitiveSerializer<CustomerFavouritesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerFavouritesDtoOutput,
    _$CustomerFavouritesDtoOutput,
  ];

  @override
  final String wireName = r'CustomerFavouritesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerFavouritesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerSearchDtoOutputRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerFavouritesDtoOutput object, {
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
    required CustomerFavouritesDtoOutputBuilder result,
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
                      FullType(CustomerSearchDtoOutputRestaurantsInner),
                    ]),
                  )
                  as BuiltList<CustomerSearchDtoOutputRestaurantsInner>;
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
  CustomerFavouritesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerFavouritesDtoOutputBuilder();
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
