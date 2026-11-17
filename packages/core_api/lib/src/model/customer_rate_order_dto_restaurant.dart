//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_rate_order_dto_restaurant.g.dart';

/// «قيّم المطعم», or null to skip it.
///
/// Properties:
/// * [stars]
/// * [reasons] - Codes of Content's list for the stars: restaurant_rating_low (1–2), _mid (3), _high (4–5), or captain_rating_* for the captain.
/// * [comment] - Up to 300 characters; null without one.
@BuiltValue()
abstract class CustomerRateOrderDtoRestaurant
    implements
        Built<
          CustomerRateOrderDtoRestaurant,
          CustomerRateOrderDtoRestaurantBuilder
        > {
  @BuiltValueField(wireName: r'stars')
  int get stars;

  /// Codes of Content's list for the stars: restaurant_rating_low (1–2), _mid (3), _high (4–5), or captain_rating_* for the captain.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<String> get reasons;

  /// Up to 300 characters; null without one.
  @BuiltValueField(wireName: r'comment')
  String? get comment;

  CustomerRateOrderDtoRestaurant._();

  factory CustomerRateOrderDtoRestaurant([
    void updates(CustomerRateOrderDtoRestaurantBuilder b),
  ]) = _$CustomerRateOrderDtoRestaurant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRateOrderDtoRestaurantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRateOrderDtoRestaurant> get serializer =>
      _$CustomerRateOrderDtoRestaurantSerializer();
}

class _$CustomerRateOrderDtoRestaurantSerializer
    implements PrimitiveSerializer<CustomerRateOrderDtoRestaurant> {
  @override
  final Iterable<Type> types = const [
    CustomerRateOrderDtoRestaurant,
    _$CustomerRateOrderDtoRestaurant,
  ];

  @override
  final String wireName = r'CustomerRateOrderDtoRestaurant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRateOrderDtoRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'comment';
    yield object.comment == null
        ? null
        : serializers.serialize(
            object.comment,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRateOrderDtoRestaurant object, {
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
    required CustomerRateOrderDtoRestaurantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stars':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.stars = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.reasons.replace(valueDes);
          break;
        case r'comment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRateOrderDtoRestaurant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRateOrderDtoRestaurantBuilder();
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
