//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_device_dto_output_device.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_device_dto_output.g.dart';

/// AdminCaptainDeviceDtoOutput
///
/// Properties:
/// * [device]
@BuiltValue()
abstract class AdminCaptainDeviceDtoOutput
    implements
        Built<AdminCaptainDeviceDtoOutput, AdminCaptainDeviceDtoOutputBuilder> {
  @BuiltValueField(wireName: r'device')
  AdminCaptainDeviceDtoOutputDevice? get device;

  AdminCaptainDeviceDtoOutput._();

  factory AdminCaptainDeviceDtoOutput([
    void updates(AdminCaptainDeviceDtoOutputBuilder b),
  ]) = _$AdminCaptainDeviceDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainDeviceDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainDeviceDtoOutput> get serializer =>
      _$AdminCaptainDeviceDtoOutputSerializer();
}

class _$AdminCaptainDeviceDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainDeviceDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainDeviceDtoOutput,
    _$AdminCaptainDeviceDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainDeviceDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainDeviceDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'device';
    yield object.device == null
        ? null
        : serializers.serialize(
            object.device,
            specifiedType: const FullType.nullable(
              AdminCaptainDeviceDtoOutputDevice,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainDeviceDtoOutput object, {
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
    required AdminCaptainDeviceDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'device':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainDeviceDtoOutputDevice,
                    ),
                  )
                  as AdminCaptainDeviceDtoOutputDevice?;
          if (valueDes == null) continue;
          result.device.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainDeviceDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainDeviceDtoOutputBuilder();
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
