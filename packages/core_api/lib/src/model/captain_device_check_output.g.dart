// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_device_check_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_notifications =
    const CaptainDeviceCheckOutputFailedEnum._('notifications');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_location =
    const CaptainDeviceCheckOutputFailedEnum._('location');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_battery =
    const CaptainDeviceCheckOutputFailedEnum._('battery');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_autostart =
    const CaptainDeviceCheckOutputFailedEnum._('autostart');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_backgroundRefresh =
    const CaptainDeviceCheckOutputFailedEnum._('backgroundRefresh');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_lowPowerMode =
    const CaptainDeviceCheckOutputFailedEnum._('lowPowerMode');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_fullScreen =
    const CaptainDeviceCheckOutputFailedEnum._('fullScreen');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_alarmVolume =
    const CaptainDeviceCheckOutputFailedEnum._('alarmVolume');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_doNotDisturb =
    const CaptainDeviceCheckOutputFailedEnum._('doNotDisturb');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_ringSwitch =
    const CaptainDeviceCheckOutputFailedEnum._('ringSwitch');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_testOffer =
    const CaptainDeviceCheckOutputFailedEnum._('testOffer');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_connection =
    const CaptainDeviceCheckOutputFailedEnum._('connection');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_gpsAccuracy =
    const CaptainDeviceCheckOutputFailedEnum._('gpsAccuracy');
const CaptainDeviceCheckOutputFailedEnum
_$captainDeviceCheckOutputFailedEnum_call =
    const CaptainDeviceCheckOutputFailedEnum._('call');

CaptainDeviceCheckOutputFailedEnum _$captainDeviceCheckOutputFailedEnumValueOf(
  String name,
) {
  switch (name) {
    case 'notifications':
      return _$captainDeviceCheckOutputFailedEnum_notifications;
    case 'location':
      return _$captainDeviceCheckOutputFailedEnum_location;
    case 'battery':
      return _$captainDeviceCheckOutputFailedEnum_battery;
    case 'autostart':
      return _$captainDeviceCheckOutputFailedEnum_autostart;
    case 'backgroundRefresh':
      return _$captainDeviceCheckOutputFailedEnum_backgroundRefresh;
    case 'lowPowerMode':
      return _$captainDeviceCheckOutputFailedEnum_lowPowerMode;
    case 'fullScreen':
      return _$captainDeviceCheckOutputFailedEnum_fullScreen;
    case 'alarmVolume':
      return _$captainDeviceCheckOutputFailedEnum_alarmVolume;
    case 'doNotDisturb':
      return _$captainDeviceCheckOutputFailedEnum_doNotDisturb;
    case 'ringSwitch':
      return _$captainDeviceCheckOutputFailedEnum_ringSwitch;
    case 'testOffer':
      return _$captainDeviceCheckOutputFailedEnum_testOffer;
    case 'connection':
      return _$captainDeviceCheckOutputFailedEnum_connection;
    case 'gpsAccuracy':
      return _$captainDeviceCheckOutputFailedEnum_gpsAccuracy;
    case 'call':
      return _$captainDeviceCheckOutputFailedEnum_call;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainDeviceCheckOutputFailedEnum>
_$captainDeviceCheckOutputFailedEnumValues =
    BuiltSet<CaptainDeviceCheckOutputFailedEnum>(
      const <CaptainDeviceCheckOutputFailedEnum>[
        _$captainDeviceCheckOutputFailedEnum_notifications,
        _$captainDeviceCheckOutputFailedEnum_location,
        _$captainDeviceCheckOutputFailedEnum_battery,
        _$captainDeviceCheckOutputFailedEnum_autostart,
        _$captainDeviceCheckOutputFailedEnum_backgroundRefresh,
        _$captainDeviceCheckOutputFailedEnum_lowPowerMode,
        _$captainDeviceCheckOutputFailedEnum_fullScreen,
        _$captainDeviceCheckOutputFailedEnum_alarmVolume,
        _$captainDeviceCheckOutputFailedEnum_doNotDisturb,
        _$captainDeviceCheckOutputFailedEnum_ringSwitch,
        _$captainDeviceCheckOutputFailedEnum_testOffer,
        _$captainDeviceCheckOutputFailedEnum_connection,
        _$captainDeviceCheckOutputFailedEnum_gpsAccuracy,
        _$captainDeviceCheckOutputFailedEnum_call,
      ],
    );

Serializer<CaptainDeviceCheckOutputFailedEnum>
_$captainDeviceCheckOutputFailedEnumSerializer =
    _$CaptainDeviceCheckOutputFailedEnumSerializer();

class _$CaptainDeviceCheckOutputFailedEnumSerializer
    implements PrimitiveSerializer<CaptainDeviceCheckOutputFailedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'notifications': 'notifications',
    'location': 'location',
    'battery': 'battery',
    'autostart': 'autostart',
    'backgroundRefresh': 'background_refresh',
    'lowPowerMode': 'low_power_mode',
    'fullScreen': 'full_screen',
    'alarmVolume': 'alarm_volume',
    'doNotDisturb': 'do_not_disturb',
    'ringSwitch': 'ring_switch',
    'testOffer': 'test_offer',
    'connection': 'connection',
    'gpsAccuracy': 'gps_accuracy',
    'call': 'call',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'notifications': 'notifications',
    'location': 'location',
    'battery': 'battery',
    'autostart': 'autostart',
    'background_refresh': 'backgroundRefresh',
    'low_power_mode': 'lowPowerMode',
    'full_screen': 'fullScreen',
    'alarm_volume': 'alarmVolume',
    'do_not_disturb': 'doNotDisturb',
    'ring_switch': 'ringSwitch',
    'test_offer': 'testOffer',
    'connection': 'connection',
    'gps_accuracy': 'gpsAccuracy',
    'call': 'call',
  };

  @override
  final Iterable<Type> types = const <Type>[CaptainDeviceCheckOutputFailedEnum];
  @override
  final String wireName = 'CaptainDeviceCheckOutputFailedEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeviceCheckOutputFailedEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainDeviceCheckOutputFailedEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainDeviceCheckOutputFailedEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainDeviceCheckOutput extends CaptainDeviceCheckOutput {
  @override
  final DateTime at;
  @override
  final bool passed;
  @override
  final BuiltList<CaptainDeviceCheckOutputFailedEnum> failed;

  factory _$CaptainDeviceCheckOutput([
    void Function(CaptainDeviceCheckOutputBuilder)? updates,
  ]) => (CaptainDeviceCheckOutputBuilder()..update(updates))._build();

  _$CaptainDeviceCheckOutput._({
    required this.at,
    required this.passed,
    required this.failed,
  }) : super._();
  @override
  CaptainDeviceCheckOutput rebuild(
    void Function(CaptainDeviceCheckOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeviceCheckOutputBuilder toBuilder() =>
      CaptainDeviceCheckOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeviceCheckOutput &&
        at == other.at &&
        passed == other.passed &&
        failed == other.failed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, passed.hashCode);
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainDeviceCheckOutput')
          ..add('at', at)
          ..add('passed', passed)
          ..add('failed', failed))
        .toString();
  }
}

class CaptainDeviceCheckOutputBuilder
    implements
        Builder<CaptainDeviceCheckOutput, CaptainDeviceCheckOutputBuilder> {
  _$CaptainDeviceCheckOutput? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  bool? _passed;
  bool? get passed => _$this._passed;
  set passed(bool? passed) => _$this._passed = passed;

  ListBuilder<CaptainDeviceCheckOutputFailedEnum>? _failed;
  ListBuilder<CaptainDeviceCheckOutputFailedEnum> get failed =>
      _$this._failed ??= ListBuilder<CaptainDeviceCheckOutputFailedEnum>();
  set failed(ListBuilder<CaptainDeviceCheckOutputFailedEnum>? failed) =>
      _$this._failed = failed;

  CaptainDeviceCheckOutputBuilder() {
    CaptainDeviceCheckOutput._defaults(this);
  }

  CaptainDeviceCheckOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _passed = $v.passed;
      _failed = $v.failed.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeviceCheckOutput other) {
    _$v = other as _$CaptainDeviceCheckOutput;
  }

  @override
  void update(void Function(CaptainDeviceCheckOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeviceCheckOutput build() => _build();

  _$CaptainDeviceCheckOutput _build() {
    _$CaptainDeviceCheckOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainDeviceCheckOutput._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CaptainDeviceCheckOutput',
              'at',
            ),
            passed: BuiltValueNullFieldError.checkNotNull(
              passed,
              r'CaptainDeviceCheckOutput',
              'passed',
            ),
            failed: failed.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'failed';
        failed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDeviceCheckOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
