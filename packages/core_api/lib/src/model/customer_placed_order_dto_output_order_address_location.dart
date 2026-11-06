//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_placed_order_dto_output_order_address_location.g.dart';

/// CustomerPlacedOrderDtoOutputOrderAddressLocation
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class CustomerPlacedOrderDtoOutputOrderAddressLocation
    implements
        Built<
          CustomerPlacedOrderDtoOutputOrderAddressLocation,
          CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  CustomerPlacedOrderDtoOutputOrderAddressLocation._();

  factory CustomerPlacedOrderDtoOutputOrderAddressLocation([
    void updates(CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder b),
  ]) = _$CustomerPlacedOrderDtoOutputOrderAddressLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlacedOrderDtoOutputOrderAddressLocation>
  get serializer =>
      _$CustomerPlacedOrderDtoOutputOrderAddressLocationSerializer();
}

class _$CustomerPlacedOrderDtoOutputOrderAddressLocationSerializer
    implements
        PrimitiveSerializer<CustomerPlacedOrderDtoOutputOrderAddressLocation> {
  @override
  final Iterable<Type> types = const [
    CustomerPlacedOrderDtoOutputOrderAddressLocation,
    _$CustomerPlacedOrderDtoOutputOrderAddressLocation,
  ];

  @override
  final String wireName = r'CustomerPlacedOrderDtoOutputOrderAddressLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrderAddressLocation object, {
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
    CustomerPlacedOrderDtoOutputOrderAddressLocation object, {
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
    required CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
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
  CustomerPlacedOrderDtoOutputOrderAddressLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlacedOrderDtoOutputOrderAddressLocationBuilder();
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
