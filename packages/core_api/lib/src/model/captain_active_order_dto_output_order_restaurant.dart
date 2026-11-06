//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order_restaurant_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_restaurant.g.dart';

/// CaptainActiveOrderDtoOutputOrderRestaurant
///
/// Properties:
/// * [name]
/// * [address]
/// * [location]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderRestaurant
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderRestaurant,
          CaptainActiveOrderDtoOutputOrderRestaurantBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'location')
  CaptainActiveOrderDtoOutputOrderRestaurantLocation get location;

  CaptainActiveOrderDtoOutputOrderRestaurant._();

  factory CaptainActiveOrderDtoOutputOrderRestaurant([
    void updates(CaptainActiveOrderDtoOutputOrderRestaurantBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderRestaurant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderRestaurantBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderRestaurant>
  get serializer => _$CaptainActiveOrderDtoOutputOrderRestaurantSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderRestaurantSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderRestaurant> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderRestaurant,
    _$CaptainActiveOrderDtoOutputOrderRestaurant,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderRestaurant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield object.address == null
        ? null
        : serializers.serialize(
            object.address,
            specifiedType: const FullType.nullable(String),
          );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        CaptainActiveOrderDtoOutputOrderRestaurantLocation,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderRestaurant object, {
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
    required CaptainActiveOrderDtoOutputOrderRestaurantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainActiveOrderDtoOutputOrderRestaurantLocation,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderRestaurantLocation;
          result.location.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderRestaurant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderRestaurantBuilder();
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
