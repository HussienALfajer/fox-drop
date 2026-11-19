//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_devices_dto_output_devices_inner_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_devices_dto_output_devices_inner.g.dart';

/// AdminRestaurantDevicesDtoOutputDevicesInner
///
/// Properties:
/// * [deviceId]
/// * [name]
/// * [platform]
/// * [appVersion]
/// * [user]
/// * [signedIn]
/// * [lastSeenAt] - Its session’s last refresh (every 15 minutes while open), or its end.
/// * [ringing] - Null until the devices report it (2.42).
/// * [deviceCheck] - Null until the device check (2.42).
@BuiltValue()
abstract class AdminRestaurantDevicesDtoOutputDevicesInner
    implements
        Built<
          AdminRestaurantDevicesDtoOutputDevicesInner,
          AdminRestaurantDevicesDtoOutputDevicesInnerBuilder
        > {
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'platform')
  AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum get platform;
  // enum platformEnum {  android,  ios,  windows,  };

  @BuiltValueField(wireName: r'appVersion')
  String get appVersion;

  @BuiltValueField(wireName: r'user')
  AdminRestaurantDevicesDtoOutputDevicesInnerUser? get user;

  @BuiltValueField(wireName: r'signedIn')
  bool get signedIn;

  /// Its session’s last refresh (every 15 minutes while open), or its end.
  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime? get lastSeenAt;

  /// Null until the devices report it (2.42).
  @BuiltValueField(wireName: r'ringing')
  bool? get ringing;

  /// Null until the device check (2.42).
  @BuiltValueField(wireName: r'deviceCheck')
  String? get deviceCheck;

  AdminRestaurantDevicesDtoOutputDevicesInner._();

  factory AdminRestaurantDevicesDtoOutputDevicesInner([
    void updates(AdminRestaurantDevicesDtoOutputDevicesInnerBuilder b),
  ]) = _$AdminRestaurantDevicesDtoOutputDevicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDevicesDtoOutputDevicesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDevicesDtoOutputDevicesInner>
  get serializer => _$AdminRestaurantDevicesDtoOutputDevicesInnerSerializer();
}

class _$AdminRestaurantDevicesDtoOutputDevicesInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantDevicesDtoOutputDevicesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDevicesDtoOutputDevicesInner,
    _$AdminRestaurantDevicesDtoOutputDevicesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantDevicesDtoOutputDevicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutputDevicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(
        AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum,
      ),
    );
    yield r'appVersion';
    yield serializers.serialize(
      object.appVersion,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield object.user == null
        ? null
        : serializers.serialize(
            object.user,
            specifiedType: const FullType.nullable(
              AdminRestaurantDevicesDtoOutputDevicesInnerUser,
            ),
          );
    yield r'signedIn';
    yield serializers.serialize(
      object.signedIn,
      specifiedType: const FullType(bool),
    );
    yield r'lastSeenAt';
    yield object.lastSeenAt == null
        ? null
        : serializers.serialize(
            object.lastSeenAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'ringing';
    yield object.ringing == null
        ? null
        : serializers.serialize(
            object.ringing,
            specifiedType: const FullType.nullable(bool),
          );
    yield r'deviceCheck';
    yield object.deviceCheck == null
        ? null
        : serializers.serialize(
            object.deviceCheck,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDevicesDtoOutputDevicesInner object, {
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
    required AdminRestaurantDevicesDtoOutputDevicesInnerBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deviceId = valueDes;
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
        case r'platform':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum,
                    ),
                  )
                  as AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum;
          result.platform = valueDes;
          break;
        case r'appVersion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.appVersion = valueDes;
          break;
        case r'user':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminRestaurantDevicesDtoOutputDevicesInnerUser,
                    ),
                  )
                  as AdminRestaurantDevicesDtoOutputDevicesInnerUser?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        case r'signedIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.signedIn = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.lastSeenAt = valueDes;
          break;
        case r'ringing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(bool),
                  )
                  as bool?;
          if (valueDes == null) continue;
          result.ringing = valueDes;
          break;
        case r'deviceCheck':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.deviceCheck = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDevicesDtoOutputDevicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDevicesDtoOutputDevicesInnerBuilder();
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

class AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'android')
  static const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum android =
      _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'ios')
  static const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum ios =
      _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'windows')
  static const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum windows =
      _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum_windows;

  static Serializer<AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum>
  get serializer =>
      _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumSerializer;

  const AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum>
  get values => _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumValues;
  static AdminRestaurantDevicesDtoOutputDevicesInnerPlatformEnum valueOf(
    String name,
  ) => _$adminRestaurantDevicesDtoOutputDevicesInnerPlatformEnumValueOf(name);
}
