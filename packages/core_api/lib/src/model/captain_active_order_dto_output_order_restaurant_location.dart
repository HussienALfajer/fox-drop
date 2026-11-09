//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_restaurant_location.g.dart';

/// On the map, with the route and «ابدأ الملاحة».
///
/// Properties:
/// * [latitude] 
/// * [longitude] 
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderRestaurantLocation implements Built<CaptainActiveOrderDtoOutputOrderRestaurantLocation, CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  CaptainActiveOrderDtoOutputOrderRestaurantLocation._();

  factory CaptainActiveOrderDtoOutputOrderRestaurantLocation([void updates(CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder b)]) = _$CaptainActiveOrderDtoOutputOrderRestaurantLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderRestaurantLocation> get serializer => _$CaptainActiveOrderDtoOutputOrderRestaurantLocationSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderRestaurantLocationSerializer implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderRestaurantLocation> {
  @override
  final Iterable<Type> types = const [CaptainActiveOrderDtoOutputOrderRestaurantLocation, _$CaptainActiveOrderDtoOutputOrderRestaurantLocation];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderRestaurantLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderRestaurantLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderRestaurantLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderRestaurantLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderRestaurantLocationBuilder();
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


