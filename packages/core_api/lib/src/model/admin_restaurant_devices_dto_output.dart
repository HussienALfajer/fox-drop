//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_devices_dto_output_devices_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_devices_dto_output.g.dart';

/// AdminRestaurantDevicesDtoOutput
///
/// Properties:
/// * [devices] - Every device named on the restaurant, the latest named first.
@BuiltValue()
abstract class AdminRestaurantDevicesDtoOutput
    implements
        Built<
          AdminRestaurantDevicesDtoOutput,
          AdminRestaurantDevicesDtoOutputBuilder
        > {
  /// Every device named on the restaurant, the latest named first.
  @BuiltValueField(wireName: r'devices')
  BuiltList<AdminRestaurantDevicesDtoOutputDevicesInner> get devices;

  AdminRestaurantDevicesDtoOutput._();

  factory AdminRestaurantDevicesDtoOutput([
    void updates(AdminRestaurantDevicesDtoOutputBuilder b),
  ]) = _$AdminRestaurantDevicesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDevicesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDevicesDtoOutput> get serializer =>
      _$AdminRestaurantDevicesDtoOutputSerializer();
}

class _$AdminRestaurantDevicesDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantDevicesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDevicesDtoOutput,
    _$AdminRestaurantDevicesDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantDevicesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'devices';
    yield serializers.serialize(
      object.devices,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantDevicesDtoOutputDevicesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutput object, {
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
    required AdminRestaurantDevicesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'devices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantDevicesDtoOutputDevicesInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantDevicesDtoOutputDevicesInner>;
          result.devices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDevicesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDevicesDtoOutputBuilder();
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
