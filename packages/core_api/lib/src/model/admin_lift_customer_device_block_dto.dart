//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_lift_customer_device_block_dto.g.dart';

/// AdminLiftCustomerDeviceBlockDto
///
/// Properties:
/// * [cityId]
/// * [deviceId] - The device the profile listed.
/// * [note] - The required reason, such as a phone sold on.
@BuiltValue()
abstract class AdminLiftCustomerDeviceBlockDto
    implements
        Built<
          AdminLiftCustomerDeviceBlockDto,
          AdminLiftCustomerDeviceBlockDtoBuilder
        > {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The device the profile listed.
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  /// The required reason, such as a phone sold on.
  @BuiltValueField(wireName: r'note')
  String get note;

  AdminLiftCustomerDeviceBlockDto._();

  factory AdminLiftCustomerDeviceBlockDto([
    void updates(AdminLiftCustomerDeviceBlockDtoBuilder b),
  ]) = _$AdminLiftCustomerDeviceBlockDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiftCustomerDeviceBlockDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiftCustomerDeviceBlockDto> get serializer =>
      _$AdminLiftCustomerDeviceBlockDtoSerializer();
}

class _$AdminLiftCustomerDeviceBlockDtoSerializer
    implements PrimitiveSerializer<AdminLiftCustomerDeviceBlockDto> {
  @override
  final Iterable<Type> types = const [
    AdminLiftCustomerDeviceBlockDto,
    _$AdminLiftCustomerDeviceBlockDto,
  ];

  @override
  final String wireName = r'AdminLiftCustomerDeviceBlockDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiftCustomerDeviceBlockDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiftCustomerDeviceBlockDto object, {
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
    required AdminLiftCustomerDeviceBlockDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'deviceId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deviceId = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLiftCustomerDeviceBlockDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiftCustomerDeviceBlockDtoBuilder();
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
