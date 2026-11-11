//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_device_dto_output_device.g.dart';

/// The device signed in now (K5: one at a time), or null.
///
/// Properties:
/// * [sessionId] - Named by «تحرير الجهاز», so it never ends a newer one.
/// * [signedInAt]
@BuiltValue()
abstract class AdminCaptainDeviceDtoOutputDevice
    implements
        Built<
          AdminCaptainDeviceDtoOutputDevice,
          AdminCaptainDeviceDtoOutputDeviceBuilder
        > {
  /// Named by «تحرير الجهاز», so it never ends a newer one.
  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'signedInAt')
  DateTime get signedInAt;

  AdminCaptainDeviceDtoOutputDevice._();

  factory AdminCaptainDeviceDtoOutputDevice([
    void updates(AdminCaptainDeviceDtoOutputDeviceBuilder b),
  ]) = _$AdminCaptainDeviceDtoOutputDevice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainDeviceDtoOutputDeviceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainDeviceDtoOutputDevice> get serializer =>
      _$AdminCaptainDeviceDtoOutputDeviceSerializer();
}

class _$AdminCaptainDeviceDtoOutputDeviceSerializer
    implements PrimitiveSerializer<AdminCaptainDeviceDtoOutputDevice> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainDeviceDtoOutputDevice,
    _$AdminCaptainDeviceDtoOutputDevice,
  ];

  @override
  final String wireName = r'AdminCaptainDeviceDtoOutputDevice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainDeviceDtoOutputDevice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'signedInAt';
    yield serializers.serialize(
      object.signedInAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainDeviceDtoOutputDevice object, {
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
    required AdminCaptainDeviceDtoOutputDeviceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sessionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sessionId = valueDes;
          break;
        case r'signedInAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.signedInAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainDeviceDtoOutputDevice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainDeviceDtoOutputDeviceBuilder();
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
