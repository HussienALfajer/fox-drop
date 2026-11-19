//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_devices_sign_out_dto.g.dart';

/// AdminRestaurantDevicesSignOutDto
///
/// Properties:
/// * [deviceId] - One device; null for every one.
/// * [reason]
@BuiltValue()
abstract class AdminRestaurantDevicesSignOutDto
    implements
        Built<
          AdminRestaurantDevicesSignOutDto,
          AdminRestaurantDevicesSignOutDtoBuilder
        > {
  /// One device; null for every one.
  @BuiltValueField(wireName: r'deviceId')
  String? get deviceId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRestaurantDevicesSignOutDto._();

  factory AdminRestaurantDevicesSignOutDto([
    void updates(AdminRestaurantDevicesSignOutDtoBuilder b),
  ]) = _$AdminRestaurantDevicesSignOutDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDevicesSignOutDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDevicesSignOutDto> get serializer =>
      _$AdminRestaurantDevicesSignOutDtoSerializer();
}

class _$AdminRestaurantDevicesSignOutDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantDevicesSignOutDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDevicesSignOutDto,
    _$AdminRestaurantDevicesSignOutDto,
  ];

  @override
  final String wireName = r'AdminRestaurantDevicesSignOutDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDevicesSignOutDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deviceId';
    yield object.deviceId == null
        ? null
        : serializers.serialize(
            object.deviceId,
            specifiedType: const FullType.nullable(String),
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
    AdminRestaurantDevicesSignOutDto object, {
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
    required AdminRestaurantDevicesSignOutDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
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
  AdminRestaurantDevicesSignOutDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDevicesSignOutDtoBuilder();
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
