//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_address_list_dto_output_addresses_inner_location.g.dart';

/// The pin, inside an active zone (CU §7.1).
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class CustomerAddressListDtoOutputAddressesInnerLocation
    implements
        Built<
          CustomerAddressListDtoOutputAddressesInnerLocation,
          CustomerAddressListDtoOutputAddressesInnerLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  CustomerAddressListDtoOutputAddressesInnerLocation._();

  factory CustomerAddressListDtoOutputAddressesInnerLocation([
    void updates(CustomerAddressListDtoOutputAddressesInnerLocationBuilder b),
  ]) = _$CustomerAddressListDtoOutputAddressesInnerLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerAddressListDtoOutputAddressesInnerLocationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAddressListDtoOutputAddressesInnerLocation>
  get serializer =>
      _$CustomerAddressListDtoOutputAddressesInnerLocationSerializer();
}

class _$CustomerAddressListDtoOutputAddressesInnerLocationSerializer
    implements
        PrimitiveSerializer<
          CustomerAddressListDtoOutputAddressesInnerLocation
        > {
  @override
  final Iterable<Type> types = const [
    CustomerAddressListDtoOutputAddressesInnerLocation,
    _$CustomerAddressListDtoOutputAddressesInnerLocation,
  ];

  @override
  final String wireName = r'CustomerAddressListDtoOutputAddressesInnerLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAddressListDtoOutputAddressesInnerLocation object, {
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
    CustomerAddressListDtoOutputAddressesInnerLocation object, {
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
    required CustomerAddressListDtoOutputAddressesInnerLocationBuilder result,
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
  CustomerAddressListDtoOutputAddressesInnerLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAddressListDtoOutputAddressesInnerLocationBuilder();
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
