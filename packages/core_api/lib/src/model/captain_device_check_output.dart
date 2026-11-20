//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_device_check_output.g.dart';

/// CaptainDeviceCheckOutput
///
/// Properties:
/// * [at]
/// * [passed] - No failed item.
/// * [failed]
@BuiltValue()
abstract class CaptainDeviceCheckOutput
    implements
        Built<CaptainDeviceCheckOutput, CaptainDeviceCheckOutputBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// No failed item.
  @BuiltValueField(wireName: r'passed')
  bool get passed;

  @BuiltValueField(wireName: r'failed')
  BuiltList<CaptainDeviceCheckOutputFailedEnum> get failed;
  // enum failedEnum {  notifications,  location,  battery,  autostart,  full_screen,  alarm_volume,  do_not_disturb,  test_offer,  connection,  gps_accuracy,  call,  background_refresh,  low_power_mode,  ring_switch,  };

  CaptainDeviceCheckOutput._();

  factory CaptainDeviceCheckOutput([
    void updates(CaptainDeviceCheckOutputBuilder b),
  ]) = _$CaptainDeviceCheckOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeviceCheckOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeviceCheckOutput> get serializer =>
      _$CaptainDeviceCheckOutputSerializer();
}

class _$CaptainDeviceCheckOutputSerializer
    implements PrimitiveSerializer<CaptainDeviceCheckOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainDeviceCheckOutput,
    _$CaptainDeviceCheckOutput,
  ];

  @override
  final String wireName = r'CaptainDeviceCheckOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeviceCheckOutput object, {
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
        FullType(CaptainDeviceCheckOutputFailedEnum),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeviceCheckOutput object, {
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
    required CaptainDeviceCheckOutputBuilder result,
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
                      FullType(CaptainDeviceCheckOutputFailedEnum),
                    ]),
                  )
                  as BuiltList<CaptainDeviceCheckOutputFailedEnum>;
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
  CaptainDeviceCheckOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeviceCheckOutputBuilder();
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

class CaptainDeviceCheckOutputFailedEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'notifications')
  static const CaptainDeviceCheckOutputFailedEnum notifications =
      _$captainDeviceCheckOutputFailedEnum_notifications;
  @BuiltValueEnumConst(wireName: r'location')
  static const CaptainDeviceCheckOutputFailedEnum location =
      _$captainDeviceCheckOutputFailedEnum_location;
  @BuiltValueEnumConst(wireName: r'battery')
  static const CaptainDeviceCheckOutputFailedEnum battery =
      _$captainDeviceCheckOutputFailedEnum_battery;
  @BuiltValueEnumConst(wireName: r'autostart')
  static const CaptainDeviceCheckOutputFailedEnum autostart =
      _$captainDeviceCheckOutputFailedEnum_autostart;
  @BuiltValueEnumConst(wireName: r'full_screen')
  static const CaptainDeviceCheckOutputFailedEnum fullScreen =
      _$captainDeviceCheckOutputFailedEnum_fullScreen;
  @BuiltValueEnumConst(wireName: r'alarm_volume')
  static const CaptainDeviceCheckOutputFailedEnum alarmVolume =
      _$captainDeviceCheckOutputFailedEnum_alarmVolume;
  @BuiltValueEnumConst(wireName: r'do_not_disturb')
  static const CaptainDeviceCheckOutputFailedEnum doNotDisturb =
      _$captainDeviceCheckOutputFailedEnum_doNotDisturb;
  @BuiltValueEnumConst(wireName: r'test_offer')
  static const CaptainDeviceCheckOutputFailedEnum testOffer =
      _$captainDeviceCheckOutputFailedEnum_testOffer;
  @BuiltValueEnumConst(wireName: r'connection')
  static const CaptainDeviceCheckOutputFailedEnum connection =
      _$captainDeviceCheckOutputFailedEnum_connection;
  @BuiltValueEnumConst(wireName: r'gps_accuracy')
  static const CaptainDeviceCheckOutputFailedEnum gpsAccuracy =
      _$captainDeviceCheckOutputFailedEnum_gpsAccuracy;
  @BuiltValueEnumConst(wireName: r'call')
  static const CaptainDeviceCheckOutputFailedEnum call =
      _$captainDeviceCheckOutputFailedEnum_call;
  @BuiltValueEnumConst(wireName: r'background_refresh')
  static const CaptainDeviceCheckOutputFailedEnum backgroundRefresh =
      _$captainDeviceCheckOutputFailedEnum_backgroundRefresh;
  @BuiltValueEnumConst(wireName: r'low_power_mode')
  static const CaptainDeviceCheckOutputFailedEnum lowPowerMode =
      _$captainDeviceCheckOutputFailedEnum_lowPowerMode;
  @BuiltValueEnumConst(wireName: r'ring_switch')
  static const CaptainDeviceCheckOutputFailedEnum ringSwitch =
      _$captainDeviceCheckOutputFailedEnum_ringSwitch;

  static Serializer<CaptainDeviceCheckOutputFailedEnum> get serializer =>
      _$captainDeviceCheckOutputFailedEnumSerializer;

  const CaptainDeviceCheckOutputFailedEnum._(String name) : super(name);

  static BuiltSet<CaptainDeviceCheckOutputFailedEnum> get values =>
      _$captainDeviceCheckOutputFailedEnumValues;
  static CaptainDeviceCheckOutputFailedEnum valueOf(String name) =>
      _$captainDeviceCheckOutputFailedEnumValueOf(name);
}
