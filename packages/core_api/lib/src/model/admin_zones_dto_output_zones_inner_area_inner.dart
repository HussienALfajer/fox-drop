//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_zones_dto_output_zones_inner_area_inner.g.dart';

/// A corner of the zone's outline.
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminZonesDtoOutputZonesInnerAreaInner
    implements
        Built<
          AdminZonesDtoOutputZonesInnerAreaInner,
          AdminZonesDtoOutputZonesInnerAreaInnerBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminZonesDtoOutputZonesInnerAreaInner._();

  factory AdminZonesDtoOutputZonesInnerAreaInner([
    void updates(AdminZonesDtoOutputZonesInnerAreaInnerBuilder b),
  ]) = _$AdminZonesDtoOutputZonesInnerAreaInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminZonesDtoOutputZonesInnerAreaInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminZonesDtoOutputZonesInnerAreaInner> get serializer =>
      _$AdminZonesDtoOutputZonesInnerAreaInnerSerializer();
}

class _$AdminZonesDtoOutputZonesInnerAreaInnerSerializer
    implements PrimitiveSerializer<AdminZonesDtoOutputZonesInnerAreaInner> {
  @override
  final Iterable<Type> types = const [
    AdminZonesDtoOutputZonesInnerAreaInner,
    _$AdminZonesDtoOutputZonesInnerAreaInner,
  ];

  @override
  final String wireName = r'AdminZonesDtoOutputZonesInnerAreaInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminZonesDtoOutputZonesInnerAreaInner object, {
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
    AdminZonesDtoOutputZonesInnerAreaInner object, {
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
    required AdminZonesDtoOutputZonesInnerAreaInnerBuilder result,
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
  AdminZonesDtoOutputZonesInnerAreaInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminZonesDtoOutputZonesInnerAreaInnerBuilder();
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
