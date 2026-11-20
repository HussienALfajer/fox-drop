//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_app_device_check.g.dart';

/// The last device check (CA §4.5), of whichever phone ran it; null before one.
///
/// Properties:
/// * [at]
/// * [passed]
/// * [failed]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputAppDeviceCheck
    implements
        Built<
          AdminCaptainProfileDtoOutputAppDeviceCheck,
          AdminCaptainProfileDtoOutputAppDeviceCheckBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'passed')
  bool get passed;

  @BuiltValueField(wireName: r'failed')
  BuiltList<AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum> get failed;
  // enum failedEnum {  notifications,  location,  battery,  autostart,  full_screen,  alarm_volume,  do_not_disturb,  test_offer,  connection,  gps_accuracy,  call,  background_refresh,  low_power_mode,  ring_switch,  };

  AdminCaptainProfileDtoOutputAppDeviceCheck._();

  factory AdminCaptainProfileDtoOutputAppDeviceCheck([
    void updates(AdminCaptainProfileDtoOutputAppDeviceCheckBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputAppDeviceCheck;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputAppDeviceCheckBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputAppDeviceCheck>
  get serializer => _$AdminCaptainProfileDtoOutputAppDeviceCheckSerializer();
}

class _$AdminCaptainProfileDtoOutputAppDeviceCheckSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputAppDeviceCheck> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputAppDeviceCheck,
    _$AdminCaptainProfileDtoOutputAppDeviceCheck,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputAppDeviceCheck';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputAppDeviceCheck object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'passed';
    yield serializers.serialize(
      object.passed,
      specifiedType: const FullType(bool),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputAppDeviceCheck object, {
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
    required AdminCaptainProfileDtoOutputAppDeviceCheckBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'passed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.passed = valueDes;
          break;
        case r'failed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
                  >;
          result.failed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutputAppDeviceCheck deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputAppDeviceCheckBuilder();
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

class AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'notifications')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
  notifications =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_notifications;
  @BuiltValueEnumConst(wireName: r'location')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum location =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_location;
  @BuiltValueEnumConst(wireName: r'battery')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum battery =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_battery;
  @BuiltValueEnumConst(wireName: r'autostart')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum autostart =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_autostart;
  @BuiltValueEnumConst(wireName: r'full_screen')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum fullScreen =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_fullScreen;
  @BuiltValueEnumConst(wireName: r'alarm_volume')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
  alarmVolume =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_alarmVolume;
  @BuiltValueEnumConst(wireName: r'do_not_disturb')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
  doNotDisturb =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_doNotDisturb;
  @BuiltValueEnumConst(wireName: r'test_offer')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum testOffer =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_testOffer;
  @BuiltValueEnumConst(wireName: r'connection')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum connection =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_connection;
  @BuiltValueEnumConst(wireName: r'gps_accuracy')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
  gpsAccuracy =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_gpsAccuracy;
  @BuiltValueEnumConst(wireName: r'call')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum call =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_call;
  @BuiltValueEnumConst(wireName: r'background_refresh')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
  backgroundRefresh =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_backgroundRefresh;
  @BuiltValueEnumConst(wireName: r'low_power_mode')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum
  lowPowerMode =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_lowPowerMode;
  @BuiltValueEnumConst(wireName: r'ring_switch')
  static const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum ringSwitch =
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnum_ringSwitch;

  static Serializer<AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum>
  get serializer =>
      _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnumSerializer;

  const AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum>
  get values => _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnumValues;
  static AdminCaptainProfileDtoOutputAppDeviceCheckFailedEnum valueOf(
    String name,
  ) => _$adminCaptainProfileDtoOutputAppDeviceCheckFailedEnumValueOf(name);
}
