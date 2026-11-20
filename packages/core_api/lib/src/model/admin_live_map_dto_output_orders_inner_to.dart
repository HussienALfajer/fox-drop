//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_orders_inner_to.g.dart';

/// The customer's pin.
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminLiveMapDtoOutputOrdersInnerTo
    implements
        Built<
          AdminLiveMapDtoOutputOrdersInnerTo,
          AdminLiveMapDtoOutputOrdersInnerToBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminLiveMapDtoOutputOrdersInnerTo._();

  factory AdminLiveMapDtoOutputOrdersInnerTo([
    void updates(AdminLiveMapDtoOutputOrdersInnerToBuilder b),
  ]) = _$AdminLiveMapDtoOutputOrdersInnerTo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputOrdersInnerToBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputOrdersInnerTo> get serializer =>
      _$AdminLiveMapDtoOutputOrdersInnerToSerializer();
}

class _$AdminLiveMapDtoOutputOrdersInnerToSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputOrdersInnerTo> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputOrdersInnerTo,
    _$AdminLiveMapDtoOutputOrdersInnerTo,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputOrdersInnerTo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputOrdersInnerTo object, {
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
    AdminLiveMapDtoOutputOrdersInnerTo object, {
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
    required AdminLiveMapDtoOutputOrdersInnerToBuilder result,
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
  AdminLiveMapDtoOutputOrdersInnerTo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputOrdersInnerToBuilder();
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
