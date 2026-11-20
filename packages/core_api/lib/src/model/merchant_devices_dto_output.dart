//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_devices_dto_output_devices_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_devices_dto_output.g.dart';

/// MerchantDevicesDtoOutput
///
/// Properties:
/// * [devices] - Every device named on the restaurant, the latest named first.
/// * [withoutDevice] - RA §14.2, §4.6: the restaurant is open with no receiving device, as the worker last saw it.
@BuiltValue()
abstract class MerchantDevicesDtoOutput
    implements
        Built<MerchantDevicesDtoOutput, MerchantDevicesDtoOutputBuilder> {
  /// Every device named on the restaurant, the latest named first.
  @BuiltValueField(wireName: r'devices')
  BuiltList<MerchantDevicesDtoOutputDevicesInner> get devices;

  /// RA §14.2, §4.6: the restaurant is open with no receiving device, as the worker last saw it.
  @BuiltValueField(wireName: r'withoutDevice')
  bool get withoutDevice;

  MerchantDevicesDtoOutput._();

  factory MerchantDevicesDtoOutput([
    void updates(MerchantDevicesDtoOutputBuilder b),
  ]) = _$MerchantDevicesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDevicesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDevicesDtoOutput> get serializer =>
      _$MerchantDevicesDtoOutputSerializer();
}

class _$MerchantDevicesDtoOutputSerializer
    implements PrimitiveSerializer<MerchantDevicesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantDevicesDtoOutput,
    _$MerchantDevicesDtoOutput,
  ];

  @override
  final String wireName = r'MerchantDevicesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDevicesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'devices';
    yield serializers.serialize(
      object.devices,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantDevicesDtoOutputDevicesInner),
      ]),
    );
    yield r'withoutDevice';
    yield serializers.serialize(
      object.withoutDevice,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDevicesDtoOutput object, {
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
    required MerchantDevicesDtoOutputBuilder result,
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
                      FullType(MerchantDevicesDtoOutputDevicesInner),
                    ]),
                  )
                  as BuiltList<MerchantDevicesDtoOutputDevicesInner>;
          result.devices.replace(valueDes);
          break;
        case r'withoutDevice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.withoutDevice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantDevicesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDevicesDtoOutputBuilder();
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
