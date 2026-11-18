//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_list_dto_output_restaurants_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_list_dto_output.g.dart';

/// AdminRestaurantListDtoOutput
///
/// Properties:
/// * [currency] - The city’s base, of every balance.
/// * [restaurants] - By name; drafts included.
@BuiltValue()
abstract class AdminRestaurantListDtoOutput
    implements
        Built<
          AdminRestaurantListDtoOutput,
          AdminRestaurantListDtoOutputBuilder
        > {
  /// The city’s base, of every balance.
  @BuiltValueField(wireName: r'currency')
  String? get currency;

  /// By name; drafts included.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminRestaurantListDtoOutputRestaurantsInner> get restaurants;

  AdminRestaurantListDtoOutput._();

  factory AdminRestaurantListDtoOutput([
    void updates(AdminRestaurantListDtoOutputBuilder b),
  ]) = _$AdminRestaurantListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantListDtoOutput> get serializer =>
      _$AdminRestaurantListDtoOutputSerializer();
}

class _$AdminRestaurantListDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantListDtoOutput,
    _$AdminRestaurantListDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantListDtoOutputRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantListDtoOutput object, {
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
    required AdminRestaurantListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantListDtoOutputRestaurantsInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantListDtoOutputRestaurantsInner>;
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
  AdminRestaurantListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantListDtoOutputBuilder();
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
