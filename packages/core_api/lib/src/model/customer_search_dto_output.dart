//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_search_dto_output_restaurants_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_search_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_search_dto_output.g.dart';

/// CustomerSearchDtoOutput
///
/// Properties:
/// * [restaurants] - Restaurants delivering to the point whose name or category matches: open first, then busy and paused, then closed.
/// * [items] - Their items whose name or description matches, in the restaurants' order (closed last), at most 50.
@BuiltValue()
abstract class CustomerSearchDtoOutput
    implements Built<CustomerSearchDtoOutput, CustomerSearchDtoOutputBuilder> {
  /// Restaurants delivering to the point whose name or category matches: open first, then busy and paused, then closed.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CustomerSearchDtoOutputRestaurantsInner> get restaurants;

  /// Their items whose name or description matches, in the restaurants' order (closed last), at most 50.
  @BuiltValueField(wireName: r'items')
  BuiltList<CustomerSearchDtoOutputItemsInner> get items;

  CustomerSearchDtoOutput._();

  factory CustomerSearchDtoOutput([
    void updates(CustomerSearchDtoOutputBuilder b),
  ]) = _$CustomerSearchDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSearchDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSearchDtoOutput> get serializer =>
      _$CustomerSearchDtoOutputSerializer();
}

class _$CustomerSearchDtoOutputSerializer
    implements PrimitiveSerializer<CustomerSearchDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerSearchDtoOutput,
    _$CustomerSearchDtoOutput,
  ];

  @override
  final String wireName = r'CustomerSearchDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSearchDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerSearchDtoOutputRestaurantsInner),
      ]),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerSearchDtoOutputItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSearchDtoOutput object, {
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
    required CustomerSearchDtoOutputBuilder result,
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
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerSearchDtoOutputItemsInner),
                    ]),
                  )
                  as BuiltList<CustomerSearchDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSearchDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSearchDtoOutputBuilder();
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
