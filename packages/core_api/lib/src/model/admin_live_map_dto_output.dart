//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_captains_inner.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_restaurants_inner.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_orders_inner.dart';
import 'package:core_api/src/model/admin_live_map_dto_output_zones_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output.g.dart';

/// AdminLiveMapDtoOutput
///
/// Properties:
/// * [zones]
/// * [restaurants]
/// * [captains]
/// * [orders]
@BuiltValue()
abstract class AdminLiveMapDtoOutput
    implements Built<AdminLiveMapDtoOutput, AdminLiveMapDtoOutputBuilder> {
  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminLiveMapDtoOutputZonesInner> get zones;

  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminLiveMapDtoOutputRestaurantsInner> get restaurants;

  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminLiveMapDtoOutputCaptainsInner> get captains;

  @BuiltValueField(wireName: r'orders')
  BuiltList<AdminLiveMapDtoOutputOrdersInner> get orders;

  AdminLiveMapDtoOutput._();

  factory AdminLiveMapDtoOutput([
    void updates(AdminLiveMapDtoOutputBuilder b),
  ]) = _$AdminLiveMapDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutput> get serializer =>
      _$AdminLiveMapDtoOutputSerializer();
}

class _$AdminLiveMapDtoOutputSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutput,
    _$AdminLiveMapDtoOutput,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLiveMapDtoOutputZonesInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLiveMapDtoOutputRestaurantsInner),
      ]),
    );
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLiveMapDtoOutputCaptainsInner),
      ]),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminLiveMapDtoOutputOrdersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutput object, {
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
    required AdminLiveMapDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLiveMapDtoOutputZonesInner),
                    ]),
                  )
                  as BuiltList<AdminLiveMapDtoOutputZonesInner>;
          result.zones.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLiveMapDtoOutputRestaurantsInner),
                    ]),
                  )
                  as BuiltList<AdminLiveMapDtoOutputRestaurantsInner>;
          result.restaurants.replace(valueDes);
          break;
        case r'captains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLiveMapDtoOutputCaptainsInner),
                    ]),
                  )
                  as BuiltList<AdminLiveMapDtoOutputCaptainsInner>;
          result.captains.replace(valueDes);
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminLiveMapDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<AdminLiveMapDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLiveMapDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputBuilder();
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
