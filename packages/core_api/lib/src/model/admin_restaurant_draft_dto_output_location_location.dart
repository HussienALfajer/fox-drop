//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_location_location.g.dart';

/// AdminRestaurantDraftDtoOutputLocationLocation
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputLocationLocation
    implements
        Built<
          AdminRestaurantDraftDtoOutputLocationLocation,
          AdminRestaurantDraftDtoOutputLocationLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminRestaurantDraftDtoOutputLocationLocation._();

  factory AdminRestaurantDraftDtoOutputLocationLocation([
    void updates(AdminRestaurantDraftDtoOutputLocationLocationBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputLocationLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputLocationLocationBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputLocationLocation>
  get serializer => _$AdminRestaurantDraftDtoOutputLocationLocationSerializer();
}

class _$AdminRestaurantDraftDtoOutputLocationLocationSerializer
    implements
        PrimitiveSerializer<AdminRestaurantDraftDtoOutputLocationLocation> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputLocationLocation,
    _$AdminRestaurantDraftDtoOutputLocationLocation,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputLocationLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputLocationLocation object, {
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
    AdminRestaurantDraftDtoOutputLocationLocation object, {
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
    required AdminRestaurantDraftDtoOutputLocationLocationBuilder result,
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
  AdminRestaurantDraftDtoOutputLocationLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputLocationLocationBuilder();
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
