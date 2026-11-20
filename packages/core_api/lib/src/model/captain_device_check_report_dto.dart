//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_device_check_report_dto.g.dart';

/// CaptainDeviceCheckReportDto
///
/// Properties:
/// * [failed] - The checks of CA §4.5 that failed; empty when all passed.
@BuiltValue()
abstract class CaptainDeviceCheckReportDto
    implements
        Built<CaptainDeviceCheckReportDto, CaptainDeviceCheckReportDtoBuilder> {
  /// The checks of CA §4.5 that failed; empty when all passed.
  @BuiltValueField(wireName: r'failed')
  BuiltList<CaptainDeviceCheckReportDtoFailedEnum> get failed;
  // enum failedEnum {  notifications,  location,  battery,  autostart,  background_refresh,  low_power_mode,  full_screen,  alarm_volume,  do_not_disturb,  ring_switch,  test_offer,  connection,  gps_accuracy,  call,  };

  CaptainDeviceCheckReportDto._();

  factory CaptainDeviceCheckReportDto([
    void updates(CaptainDeviceCheckReportDtoBuilder b),
  ]) = _$CaptainDeviceCheckReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeviceCheckReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeviceCheckReportDto> get serializer =>
      _$CaptainDeviceCheckReportDtoSerializer();
}

class _$CaptainDeviceCheckReportDtoSerializer
    implements PrimitiveSerializer<CaptainDeviceCheckReportDto> {
  @override
  final Iterable<Type> types = const [
    CaptainDeviceCheckReportDto,
    _$CaptainDeviceCheckReportDto,
  ];

  @override
  final String wireName = r'CaptainDeviceCheckReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeviceCheckReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainDeviceCheckReportDtoFailedEnum),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeviceCheckReportDto object, {
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
    required CaptainDeviceCheckReportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'failed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainDeviceCheckReportDtoFailedEnum),
                    ]),
                  )
                  as BuiltList<CaptainDeviceCheckReportDtoFailedEnum>;
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
  CaptainDeviceCheckReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeviceCheckReportDtoBuilder();
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

class CaptainDeviceCheckReportDtoFailedEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'notifications')
  static const CaptainDeviceCheckReportDtoFailedEnum notifications =
      _$captainDeviceCheckReportDtoFailedEnum_notifications;
  @BuiltValueEnumConst(wireName: r'location')
  static const CaptainDeviceCheckReportDtoFailedEnum location =
      _$captainDeviceCheckReportDtoFailedEnum_location;
  @BuiltValueEnumConst(wireName: r'battery')
  static const CaptainDeviceCheckReportDtoFailedEnum battery =
      _$captainDeviceCheckReportDtoFailedEnum_battery;
  @BuiltValueEnumConst(wireName: r'autostart')
  static const CaptainDeviceCheckReportDtoFailedEnum autostart =
      _$captainDeviceCheckReportDtoFailedEnum_autostart;
  @BuiltValueEnumConst(wireName: r'background_refresh')
  static const CaptainDeviceCheckReportDtoFailedEnum backgroundRefresh =
      _$captainDeviceCheckReportDtoFailedEnum_backgroundRefresh;
  @BuiltValueEnumConst(wireName: r'low_power_mode')
  static const CaptainDeviceCheckReportDtoFailedEnum lowPowerMode =
      _$captainDeviceCheckReportDtoFailedEnum_lowPowerMode;
  @BuiltValueEnumConst(wireName: r'full_screen')
  static const CaptainDeviceCheckReportDtoFailedEnum fullScreen =
      _$captainDeviceCheckReportDtoFailedEnum_fullScreen;
  @BuiltValueEnumConst(wireName: r'alarm_volume')
  static const CaptainDeviceCheckReportDtoFailedEnum alarmVolume =
      _$captainDeviceCheckReportDtoFailedEnum_alarmVolume;
  @BuiltValueEnumConst(wireName: r'do_not_disturb')
  static const CaptainDeviceCheckReportDtoFailedEnum doNotDisturb =
      _$captainDeviceCheckReportDtoFailedEnum_doNotDisturb;
  @BuiltValueEnumConst(wireName: r'ring_switch')
  static const CaptainDeviceCheckReportDtoFailedEnum ringSwitch =
      _$captainDeviceCheckReportDtoFailedEnum_ringSwitch;
  @BuiltValueEnumConst(wireName: r'test_offer')
  static const CaptainDeviceCheckReportDtoFailedEnum testOffer =
      _$captainDeviceCheckReportDtoFailedEnum_testOffer;
  @BuiltValueEnumConst(wireName: r'connection')
  static const CaptainDeviceCheckReportDtoFailedEnum connection =
      _$captainDeviceCheckReportDtoFailedEnum_connection;
  @BuiltValueEnumConst(wireName: r'gps_accuracy')
  static const CaptainDeviceCheckReportDtoFailedEnum gpsAccuracy =
      _$captainDeviceCheckReportDtoFailedEnum_gpsAccuracy;
  @BuiltValueEnumConst(wireName: r'call')
  static const CaptainDeviceCheckReportDtoFailedEnum call =
      _$captainDeviceCheckReportDtoFailedEnum_call;

  static Serializer<CaptainDeviceCheckReportDtoFailedEnum> get serializer =>
      _$captainDeviceCheckReportDtoFailedEnumSerializer;

  const CaptainDeviceCheckReportDtoFailedEnum._(String name) : super(name);

  static BuiltSet<CaptainDeviceCheckReportDtoFailedEnum> get values =>
      _$captainDeviceCheckReportDtoFailedEnumValues;
  static CaptainDeviceCheckReportDtoFailedEnum valueOf(String name) =>
      _$captainDeviceCheckReportDtoFailedEnumValueOf(name);
}
