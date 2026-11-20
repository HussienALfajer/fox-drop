//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner_location.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_zones_inner.g.dart';

/// AdminLiveMapDtoOutputZonesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [active]
/// * [area]
@BuiltValue()
abstract class AdminLiveMapDtoOutputZonesInner
    implements
        Built<
          AdminLiveMapDtoOutputZonesInner,
          AdminLiveMapDtoOutputZonesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'active')
  bool get active;

  @BuiltValueField(wireName: r'area')
  BuiltList<AdminCustomerDtoOutputAddressesInnerLocation> get area;

  AdminLiveMapDtoOutputZonesInner._();

  factory AdminLiveMapDtoOutputZonesInner([
    void updates(AdminLiveMapDtoOutputZonesInnerBuilder b),
  ]) = _$AdminLiveMapDtoOutputZonesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputZonesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputZonesInner> get serializer =>
      _$AdminLiveMapDtoOutputZonesInnerSerializer();
}

class _$AdminLiveMapDtoOutputZonesInnerSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputZonesInner> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputZonesInner,
    _$AdminLiveMapDtoOutputZonesInner,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputZonesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputZonesInner object, {
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
        FullType(AdminCustomerDtoOutputAddressesInnerLocation),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputZonesInner object, {
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
    required AdminLiveMapDtoOutputZonesInnerBuilder result,
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
                      FullType(AdminCustomerDtoOutputAddressesInnerLocation),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputAddressesInnerLocation>;
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
  AdminLiveMapDtoOutputZonesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputZonesInnerBuilder();
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
