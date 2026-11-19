//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_save_zone_dto_area_inner.g.dart';

/// A corner of the zone's outline.
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminSaveZoneDtoAreaInner
    implements
        Built<AdminSaveZoneDtoAreaInner, AdminSaveZoneDtoAreaInnerBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminSaveZoneDtoAreaInner._();

  factory AdminSaveZoneDtoAreaInner([
    void updates(AdminSaveZoneDtoAreaInnerBuilder b),
  ]) = _$AdminSaveZoneDtoAreaInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSaveZoneDtoAreaInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSaveZoneDtoAreaInner> get serializer =>
      _$AdminSaveZoneDtoAreaInnerSerializer();
}

class _$AdminSaveZoneDtoAreaInnerSerializer
    implements PrimitiveSerializer<AdminSaveZoneDtoAreaInner> {
  @override
  final Iterable<Type> types = const [
    AdminSaveZoneDtoAreaInner,
    _$AdminSaveZoneDtoAreaInner,
  ];

  @override
  final String wireName = r'AdminSaveZoneDtoAreaInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSaveZoneDtoAreaInner object, {
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
    AdminSaveZoneDtoAreaInner object, {
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
    required AdminSaveZoneDtoAreaInnerBuilder result,
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
  AdminSaveZoneDtoAreaInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSaveZoneDtoAreaInnerBuilder();
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
