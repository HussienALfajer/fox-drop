//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_address_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_restaurant.g.dart';

/// CaptainCurrentOfferDtoOutputOfferRestaurant
///
/// Properties:
/// * [name]
/// * [location]
/// * [distanceMetres] - From the captain, by road, when the offer opened.
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferRestaurant
    implements
        Built<
          CaptainCurrentOfferDtoOutputOfferRestaurant,
          CaptainCurrentOfferDtoOutputOfferRestaurantBuilder
        > {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'location')
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation get location;

  /// From the captain, by road, when the offer opened.
  @BuiltValueField(wireName: r'distanceMetres')
  int get distanceMetres;

  CaptainCurrentOfferDtoOutputOfferRestaurant._();

  factory CaptainCurrentOfferDtoOutputOfferRestaurant([
    void updates(CaptainCurrentOfferDtoOutputOfferRestaurantBuilder b),
  ]) = _$CaptainCurrentOfferDtoOutputOfferRestaurant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputOfferRestaurantBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferRestaurant>
  get serializer => _$CaptainCurrentOfferDtoOutputOfferRestaurantSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferRestaurantSerializer
    implements
        PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferRestaurant> {
  @override
  final Iterable<Type> types = const [
    CaptainCurrentOfferDtoOutputOfferRestaurant,
    _$CaptainCurrentOfferDtoOutputOfferRestaurant,
  ];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferRestaurant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferRestaurant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation,
      ),
    );
    yield r'distanceMetres';
    yield serializers.serialize(
      object.distanceMetres,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferRestaurant object, {
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
    required CaptainCurrentOfferDtoOutputOfferRestaurantBuilder result,
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
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation;
          result.location.replace(valueDes);
          break;
        case r'distanceMetres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.distanceMetres = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutputOfferRestaurant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferRestaurantBuilder();
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
