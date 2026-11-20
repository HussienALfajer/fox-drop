//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_device_check_output.dart';
import 'package:core_api/src/model/admin_restaurant_devices_dto_output_devices_inner_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_devices_dto_output_devices_inner.g.dart';

/// MerchantDevicesDtoOutputDevicesInner
///
/// Properties:
/// * [deviceId]
/// * [name]
/// * [platform]
/// * [appVersion]
/// * [user]
/// * [signedIn]
/// * [lastSeenAt] - Its session’s last refresh (every 15 minutes while open), or its end.
/// * [ringing] - Whether ring events ring on it: the owner’s setting, always for a cashier (RA §4.4).
/// * [connected] - Signed in and on the restaurant’s channel within the last 60 s (RA §4.3).
/// * [deviceCheck] - Its latest device check (RA §4.5), or null before any.
/// * [thisDevice] - The device making the request.
@BuiltValue()
abstract class MerchantDevicesDtoOutputDevicesInner
    implements
        Built<
          MerchantDevicesDtoOutputDevicesInner,
          MerchantDevicesDtoOutputDevicesInnerBuilder
        > {
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'platform')
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum get platform;
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

  /// Whether ring events ring on it: the owner’s setting, always for a cashier (RA §4.4).
  @BuiltValueField(wireName: r'ringing')
  bool get ringing;

  /// Signed in and on the restaurant’s channel within the last 60 s (RA §4.3).
  @BuiltValueField(wireName: r'connected')
  bool get connected;

  /// Its latest device check (RA §4.5), or null before any.
  @BuiltValueField(wireName: r'deviceCheck')
  MerchantDeviceCheckOutput? get deviceCheck;

  /// The device making the request.
  @BuiltValueField(wireName: r'thisDevice')
  bool get thisDevice;

  MerchantDevicesDtoOutputDevicesInner._();

  factory MerchantDevicesDtoOutputDevicesInner([
    void updates(MerchantDevicesDtoOutputDevicesInnerBuilder b),
  ]) = _$MerchantDevicesDtoOutputDevicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDevicesDtoOutputDevicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDevicesDtoOutputDevicesInner> get serializer =>
      _$MerchantDevicesDtoOutputDevicesInnerSerializer();
}

class _$MerchantDevicesDtoOutputDevicesInnerSerializer
    implements PrimitiveSerializer<MerchantDevicesDtoOutputDevicesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantDevicesDtoOutputDevicesInner,
    _$MerchantDevicesDtoOutputDevicesInner,
  ];

  @override
  final String wireName = r'MerchantDevicesDtoOutputDevicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDevicesDtoOutputDevicesInner object, {
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
        MerchantDevicesDtoOutputDevicesInnerPlatformEnum,
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
    yield serializers.serialize(
      object.ringing,
      specifiedType: const FullType(bool),
    );
    yield r'connected';
    yield serializers.serialize(
      object.connected,
      specifiedType: const FullType(bool),
    );
    yield r'deviceCheck';
    yield object.deviceCheck == null
        ? null
        : serializers.serialize(
            object.deviceCheck,
            specifiedType: const FullType.nullable(MerchantDeviceCheckOutput),
          );
    yield r'thisDevice';
    yield serializers.serialize(
      object.thisDevice,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDevicesDtoOutputDevicesInner object, {
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
    required MerchantDevicesDtoOutputDevicesInnerBuilder result,
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
                      MerchantDevicesDtoOutputDevicesInnerPlatformEnum,
                    ),
                  )
                  as MerchantDevicesDtoOutputDevicesInnerPlatformEnum;
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
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.ringing = valueDes;
          break;
        case r'connected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.connected = valueDes;
          break;
        case r'deviceCheck':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantDeviceCheckOutput,
                    ),
                  )
                  as MerchantDeviceCheckOutput?;
          if (valueDes == null) continue;
          result.deviceCheck.replace(valueDes);
          break;
        case r'thisDevice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.thisDevice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantDevicesDtoOutputDevicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDevicesDtoOutputDevicesInnerBuilder();
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

class MerchantDevicesDtoOutputDevicesInnerPlatformEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'android')
  static const MerchantDevicesDtoOutputDevicesInnerPlatformEnum android =
      _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_android;
  @BuiltValueEnumConst(wireName: r'ios')
  static const MerchantDevicesDtoOutputDevicesInnerPlatformEnum ios =
      _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_ios;
  @BuiltValueEnumConst(wireName: r'windows')
  static const MerchantDevicesDtoOutputDevicesInnerPlatformEnum windows =
      _$merchantDevicesDtoOutputDevicesInnerPlatformEnum_windows;

  static Serializer<MerchantDevicesDtoOutputDevicesInnerPlatformEnum>
  get serializer =>
      _$merchantDevicesDtoOutputDevicesInnerPlatformEnumSerializer;

  const MerchantDevicesDtoOutputDevicesInnerPlatformEnum._(String name)
    : super(name);

  static BuiltSet<MerchantDevicesDtoOutputDevicesInnerPlatformEnum>
  get values => _$merchantDevicesDtoOutputDevicesInnerPlatformEnumValues;
  static MerchantDevicesDtoOutputDevicesInnerPlatformEnum valueOf(
    String name,
  ) => _$merchantDevicesDtoOutputDevicesInnerPlatformEnumValueOf(name);
}
