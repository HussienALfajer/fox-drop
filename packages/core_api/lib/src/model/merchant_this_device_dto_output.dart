//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_device_check_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_this_device_dto_output.g.dart';

/// MerchantThisDeviceDtoOutput
///
/// Properties:
/// * [ringing] - Whether ring events ring on this device (a cashier’s always, RA §4.4).
/// * [check] - The latest device check (RA §4.5).
@BuiltValue()
abstract class MerchantThisDeviceDtoOutput
    implements
        Built<MerchantThisDeviceDtoOutput, MerchantThisDeviceDtoOutputBuilder> {
  /// Whether ring events ring on this device (a cashier’s always, RA §4.4).
  @BuiltValueField(wireName: r'ringing')
  bool get ringing;

  /// The latest device check (RA §4.5).
  @BuiltValueField(wireName: r'check')
  MerchantDeviceCheckOutput? get check;

  MerchantThisDeviceDtoOutput._();

  factory MerchantThisDeviceDtoOutput([
    void updates(MerchantThisDeviceDtoOutputBuilder b),
  ]) = _$MerchantThisDeviceDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantThisDeviceDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantThisDeviceDtoOutput> get serializer =>
      _$MerchantThisDeviceDtoOutputSerializer();
}

class _$MerchantThisDeviceDtoOutputSerializer
    implements PrimitiveSerializer<MerchantThisDeviceDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantThisDeviceDtoOutput,
    _$MerchantThisDeviceDtoOutput,
  ];

  @override
  final String wireName = r'MerchantThisDeviceDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantThisDeviceDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ringing';
    yield serializers.serialize(
      object.ringing,
      specifiedType: const FullType(bool),
    );
    yield r'check';
    yield object.check == null
        ? null
        : serializers.serialize(
            object.check,
            specifiedType: const FullType.nullable(MerchantDeviceCheckOutput),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantThisDeviceDtoOutput object, {
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
    required MerchantThisDeviceDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ringing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.ringing = valueDes;
          break;
        case r'check':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantDeviceCheckOutput,
                    ),
                  )
                  as MerchantDeviceCheckOutput?;
          if (valueDes == null) continue;
          result.check.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantThisDeviceDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantThisDeviceDtoOutputBuilder();
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
