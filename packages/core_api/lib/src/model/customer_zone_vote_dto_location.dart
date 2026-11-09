//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_zone_vote_dto_location.g.dart';

/// CustomerZoneVoteDtoLocation
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class CustomerZoneVoteDtoLocation
    implements
        Built<CustomerZoneVoteDtoLocation, CustomerZoneVoteDtoLocationBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  CustomerZoneVoteDtoLocation._();

  factory CustomerZoneVoteDtoLocation([
    void updates(CustomerZoneVoteDtoLocationBuilder b),
  ]) = _$CustomerZoneVoteDtoLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerZoneVoteDtoLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerZoneVoteDtoLocation> get serializer =>
      _$CustomerZoneVoteDtoLocationSerializer();
}

class _$CustomerZoneVoteDtoLocationSerializer
    implements PrimitiveSerializer<CustomerZoneVoteDtoLocation> {
  @override
  final Iterable<Type> types = const [
    CustomerZoneVoteDtoLocation,
    _$CustomerZoneVoteDtoLocation,
  ];

  @override
  final String wireName = r'CustomerZoneVoteDtoLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerZoneVoteDtoLocation object, {
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
    CustomerZoneVoteDtoLocation object, {
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
    required CustomerZoneVoteDtoLocationBuilder result,
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
  CustomerZoneVoteDtoLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerZoneVoteDtoLocationBuilder();
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
