// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_check_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_notifications =
    const MerchantDeviceCheckOutputFailedEnum._('notifications');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_battery =
    const MerchantDeviceCheckOutputFailedEnum._('battery');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_autostart =
    const MerchantDeviceCheckOutputFailedEnum._('autostart');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_fullScreen =
    const MerchantDeviceCheckOutputFailedEnum._('fullScreen');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_alarmVolume =
    const MerchantDeviceCheckOutputFailedEnum._('alarmVolume');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_sleep =
    const MerchantDeviceCheckOutputFailedEnum._('sleep');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_testRing =
    const MerchantDeviceCheckOutputFailedEnum._('testRing');
const MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnum_connection =
    const MerchantDeviceCheckOutputFailedEnum._('connection');

MerchantDeviceCheckOutputFailedEnum
_$merchantDeviceCheckOutputFailedEnumValueOf(String name) {
  switch (name) {
    case 'notifications':
      return _$merchantDeviceCheckOutputFailedEnum_notifications;
    case 'battery':
      return _$merchantDeviceCheckOutputFailedEnum_battery;
    case 'autostart':
      return _$merchantDeviceCheckOutputFailedEnum_autostart;
    case 'fullScreen':
      return _$merchantDeviceCheckOutputFailedEnum_fullScreen;
    case 'alarmVolume':
      return _$merchantDeviceCheckOutputFailedEnum_alarmVolume;
    case 'sleep':
      return _$merchantDeviceCheckOutputFailedEnum_sleep;
    case 'testRing':
      return _$merchantDeviceCheckOutputFailedEnum_testRing;
    case 'connection':
      return _$merchantDeviceCheckOutputFailedEnum_connection;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantDeviceCheckOutputFailedEnum>
_$merchantDeviceCheckOutputFailedEnumValues =
    BuiltSet<MerchantDeviceCheckOutputFailedEnum>(
      const <MerchantDeviceCheckOutputFailedEnum>[
        _$merchantDeviceCheckOutputFailedEnum_notifications,
        _$merchantDeviceCheckOutputFailedEnum_battery,
        _$merchantDeviceCheckOutputFailedEnum_autostart,
        _$merchantDeviceCheckOutputFailedEnum_fullScreen,
        _$merchantDeviceCheckOutputFailedEnum_alarmVolume,
        _$merchantDeviceCheckOutputFailedEnum_sleep,
        _$merchantDeviceCheckOutputFailedEnum_testRing,
        _$merchantDeviceCheckOutputFailedEnum_connection,
      ],
    );

Serializer<MerchantDeviceCheckOutputFailedEnum>
_$merchantDeviceCheckOutputFailedEnumSerializer =
    _$MerchantDeviceCheckOutputFailedEnumSerializer();

class _$MerchantDeviceCheckOutputFailedEnumSerializer
    implements PrimitiveSerializer<MerchantDeviceCheckOutputFailedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'notifications': 'notifications',
    'battery': 'battery',
    'autostart': 'autostart',
    'fullScreen': 'full_screen',
    'alarmVolume': 'alarm_volume',
    'sleep': 'sleep',
    'testRing': 'test_ring',
    'connection': 'connection',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'notifications': 'notifications',
    'battery': 'battery',
    'autostart': 'autostart',
    'full_screen': 'fullScreen',
    'alarm_volume': 'alarmVolume',
    'sleep': 'sleep',
    'test_ring': 'testRing',
    'connection': 'connection',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantDeviceCheckOutputFailedEnum,
  ];
  @override
  final String wireName = 'MerchantDeviceCheckOutputFailedEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceCheckOutputFailedEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantDeviceCheckOutputFailedEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantDeviceCheckOutputFailedEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantDeviceCheckOutput extends MerchantDeviceCheckOutput {
  @override
  final DateTime at;
  @override
  final bool passed;
  @override
  final BuiltList<MerchantDeviceCheckOutputFailedEnum> failed;
  @override
  final int? delayMs;

  factory _$MerchantDeviceCheckOutput([
    void Function(MerchantDeviceCheckOutputBuilder)? updates,
  ]) => (MerchantDeviceCheckOutputBuilder()..update(updates))._build();

  _$MerchantDeviceCheckOutput._({
    required this.at,
    required this.passed,
    required this.failed,
    this.delayMs,
  }) : super._();
  @override
  MerchantDeviceCheckOutput rebuild(
    void Function(MerchantDeviceCheckOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDeviceCheckOutputBuilder toBuilder() =>
      MerchantDeviceCheckOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDeviceCheckOutput &&
        at == other.at &&
        passed == other.passed &&
        failed == other.failed &&
        delayMs == other.delayMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, passed.hashCode);
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jc(_$hash, delayMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDeviceCheckOutput')
          ..add('at', at)
          ..add('passed', passed)
          ..add('failed', failed)
          ..add('delayMs', delayMs))
        .toString();
  }
}

class MerchantDeviceCheckOutputBuilder
    implements
        Builder<MerchantDeviceCheckOutput, MerchantDeviceCheckOutputBuilder> {
  _$MerchantDeviceCheckOutput? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  bool? _passed;
  bool? get passed => _$this._passed;
  set passed(bool? passed) => _$this._passed = passed;

  ListBuilder<MerchantDeviceCheckOutputFailedEnum>? _failed;
  ListBuilder<MerchantDeviceCheckOutputFailedEnum> get failed =>
      _$this._failed ??= ListBuilder<MerchantDeviceCheckOutputFailedEnum>();
  set failed(ListBuilder<MerchantDeviceCheckOutputFailedEnum>? failed) =>
      _$this._failed = failed;

  int? _delayMs;
  int? get delayMs => _$this._delayMs;
  set delayMs(int? delayMs) => _$this._delayMs = delayMs;

  MerchantDeviceCheckOutputBuilder() {
    MerchantDeviceCheckOutput._defaults(this);
  }

  MerchantDeviceCheckOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _passed = $v.passed;
      _failed = $v.failed.toBuilder();
      _delayMs = $v.delayMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDeviceCheckOutput other) {
    _$v = other as _$MerchantDeviceCheckOutput;
  }

  @override
  void update(void Function(MerchantDeviceCheckOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDeviceCheckOutput build() => _build();

  _$MerchantDeviceCheckOutput _build() {
    _$MerchantDeviceCheckOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantDeviceCheckOutput._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'MerchantDeviceCheckOutput',
              'at',
            ),
            passed: BuiltValueNullFieldError.checkNotNull(
              passed,
              r'MerchantDeviceCheckOutput',
              'passed',
            ),
            failed: failed.build(),
            delayMs: delayMs,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'failed';
        failed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantDeviceCheckOutput',
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
