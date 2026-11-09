//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurants_dto_output_restaurants_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurants_dto_output.g.dart';

/// AdminRestaurantsDtoOutput
///
/// Properties:
/// * [restaurants] 
@BuiltValue()
abstract class AdminRestaurantsDtoOutput implements Built<AdminRestaurantsDtoOutput, AdminRestaurantsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminRestaurantsDtoOutputRestaurantsInner> get restaurants;

  AdminRestaurantsDtoOutput._();

  factory AdminRestaurantsDtoOutput([void updates(AdminRestaurantsDtoOutputBuilder b)]) = _$AdminRestaurantsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantsDtoOutput> get serializer => _$AdminRestaurantsDtoOutputSerializer();
}

class _$AdminRestaurantsDtoOutputSerializer implements PrimitiveSerializer<AdminRestaurantsDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminRestaurantsDtoOutput, _$AdminRestaurantsDtoOutput];

  @override
  final String wireName = r'AdminRestaurantsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [FullType(AdminRestaurantsDtoOutputRestaurantsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRestaurantsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRestaurantsDtoOutputRestaurantsInner)]),
          ) as BuiltList<AdminRestaurantsDtoOutputRestaurantsInner>;
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
  AdminRestaurantsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantsDtoOutputBuilder();
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


