//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_office_dto_output_office_location.g.dart';

/// The office's point, until the map (slice 2.29).
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminCityOfficeDtoOutputOfficeLocation
    implements
        Built<
          AdminCityOfficeDtoOutputOfficeLocation,
          AdminCityOfficeDtoOutputOfficeLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminCityOfficeDtoOutputOfficeLocation._();

  factory AdminCityOfficeDtoOutputOfficeLocation([
    void updates(AdminCityOfficeDtoOutputOfficeLocationBuilder b),
  ]) = _$AdminCityOfficeDtoOutputOfficeLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityOfficeDtoOutputOfficeLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityOfficeDtoOutputOfficeLocation> get serializer =>
      _$AdminCityOfficeDtoOutputOfficeLocationSerializer();
}

class _$AdminCityOfficeDtoOutputOfficeLocationSerializer
    implements PrimitiveSerializer<AdminCityOfficeDtoOutputOfficeLocation> {
  @override
  final Iterable<Type> types = const [
    AdminCityOfficeDtoOutputOfficeLocation,
    _$AdminCityOfficeDtoOutputOfficeLocation,
  ];

  @override
  final String wireName = r'AdminCityOfficeDtoOutputOfficeLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityOfficeDtoOutputOfficeLocation object, {
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
    AdminCityOfficeDtoOutputOfficeLocation object, {
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
    required AdminCityOfficeDtoOutputOfficeLocationBuilder result,
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
  AdminCityOfficeDtoOutputOfficeLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityOfficeDtoOutputOfficeLocationBuilder();
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
