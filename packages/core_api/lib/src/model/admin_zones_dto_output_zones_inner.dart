//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_zones_dto_output_zones_inner_area_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_zones_dto_output_zones_inner.g.dart';

/// AdminZonesDtoOutputZonesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [active]
/// * [area] - The corners in order, the ring left open.
@BuiltValue()
abstract class AdminZonesDtoOutputZonesInner
    implements
        Built<
          AdminZonesDtoOutputZonesInner,
          AdminZonesDtoOutputZonesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'active')
  bool get active;

  /// The corners in order, the ring left open.
  @BuiltValueField(wireName: r'area')
  BuiltList<AdminZonesDtoOutputZonesInnerAreaInner> get area;

  AdminZonesDtoOutputZonesInner._();

  factory AdminZonesDtoOutputZonesInner([
    void updates(AdminZonesDtoOutputZonesInnerBuilder b),
  ]) = _$AdminZonesDtoOutputZonesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminZonesDtoOutputZonesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminZonesDtoOutputZonesInner> get serializer =>
      _$AdminZonesDtoOutputZonesInnerSerializer();
}

class _$AdminZonesDtoOutputZonesInnerSerializer
    implements PrimitiveSerializer<AdminZonesDtoOutputZonesInner> {
  @override
  final Iterable<Type> types = const [
    AdminZonesDtoOutputZonesInner,
    _$AdminZonesDtoOutputZonesInner,
  ];

  @override
  final String wireName = r'AdminZonesDtoOutputZonesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminZonesDtoOutputZonesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    yield r'area';
    yield serializers.serialize(
      object.area,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminZonesDtoOutputZonesInnerAreaInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminZonesDtoOutputZonesInner object, {
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
    required AdminZonesDtoOutputZonesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        case r'area':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminZonesDtoOutputZonesInnerAreaInner),
                    ]),
                  )
                  as BuiltList<AdminZonesDtoOutputZonesInnerAreaInner>;
          result.area.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminZonesDtoOutputZonesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminZonesDtoOutputZonesInnerBuilder();
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
