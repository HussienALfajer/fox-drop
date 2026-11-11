//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_release_device_dto.g.dart';

/// AdminReleaseDeviceDto
///
/// Properties:
/// * [sessionId] - The device the panel showed.
/// * [reason] - Why, kept in the audit log (AP §9.7.5).
@BuiltValue()
abstract class AdminReleaseDeviceDto
    implements Built<AdminReleaseDeviceDto, AdminReleaseDeviceDtoBuilder> {
  /// The device the panel showed.
  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  /// Why, kept in the audit log (AP §9.7.5).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminReleaseDeviceDto._();

  factory AdminReleaseDeviceDto([
    void updates(AdminReleaseDeviceDtoBuilder b),
  ]) = _$AdminReleaseDeviceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReleaseDeviceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReleaseDeviceDto> get serializer =>
      _$AdminReleaseDeviceDtoSerializer();
}

class _$AdminReleaseDeviceDtoSerializer
    implements PrimitiveSerializer<AdminReleaseDeviceDto> {
  @override
  final Iterable<Type> types = const [
    AdminReleaseDeviceDto,
    _$AdminReleaseDeviceDto,
  ];

  @override
  final String wireName = r'AdminReleaseDeviceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReleaseDeviceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReleaseDeviceDto object, {
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
    required AdminReleaseDeviceDtoBuilder result,
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReleaseDeviceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReleaseDeviceDtoBuilder();
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
