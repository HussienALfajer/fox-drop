// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_check_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_notifications =
    const MerchantDeviceCheckDtoFailedEnum._('notifications');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_battery =
    const MerchantDeviceCheckDtoFailedEnum._('battery');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_autostart =
    const MerchantDeviceCheckDtoFailedEnum._('autostart');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_fullScreen =
    const MerchantDeviceCheckDtoFailedEnum._('fullScreen');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_alarmVolume =
    const MerchantDeviceCheckDtoFailedEnum._('alarmVolume');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_sleep =
    const MerchantDeviceCheckDtoFailedEnum._('sleep');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_testRing =
    const MerchantDeviceCheckDtoFailedEnum._('testRing');
const MerchantDeviceCheckDtoFailedEnum
_$merchantDeviceCheckDtoFailedEnum_connection =
    const MerchantDeviceCheckDtoFailedEnum._('connection');

MerchantDeviceCheckDtoFailedEnum _$merchantDeviceCheckDtoFailedEnumValueOf(
  String name,
) {
  switch (name) {
    case 'notifications':
      return _$merchantDeviceCheckDtoFailedEnum_notifications;
    case 'battery':
      return _$merchantDeviceCheckDtoFailedEnum_battery;
    case 'autostart':
      return _$merchantDeviceCheckDtoFailedEnum_autostart;
    case 'fullScreen':
      return _$merchantDeviceCheckDtoFailedEnum_fullScreen;
    case 'alarmVolume':
      return _$merchantDeviceCheckDtoFailedEnum_alarmVolume;
    case 'sleep':
      return _$merchantDeviceCheckDtoFailedEnum_sleep;
    case 'testRing':
      return _$merchantDeviceCheckDtoFailedEnum_testRing;
    case 'connection':
      return _$merchantDeviceCheckDtoFailedEnum_connection;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantDeviceCheckDtoFailedEnum>
_$merchantDeviceCheckDtoFailedEnumValues =
    BuiltSet<MerchantDeviceCheckDtoFailedEnum>(
      const <MerchantDeviceCheckDtoFailedEnum>[
        _$merchantDeviceCheckDtoFailedEnum_notifications,
        _$merchantDeviceCheckDtoFailedEnum_battery,
        _$merchantDeviceCheckDtoFailedEnum_autostart,
        _$merchantDeviceCheckDtoFailedEnum_fullScreen,
        _$merchantDeviceCheckDtoFailedEnum_alarmVolume,
        _$merchantDeviceCheckDtoFailedEnum_sleep,
        _$merchantDeviceCheckDtoFailedEnum_testRing,
        _$merchantDeviceCheckDtoFailedEnum_connection,
      ],
    );

Serializer<MerchantDeviceCheckDtoFailedEnum>
_$merchantDeviceCheckDtoFailedEnumSerializer =
    _$MerchantDeviceCheckDtoFailedEnumSerializer();

class _$MerchantDeviceCheckDtoFailedEnumSerializer
    implements PrimitiveSerializer<MerchantDeviceCheckDtoFailedEnum> {
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
  final Iterable<Type> types = const <Type>[MerchantDeviceCheckDtoFailedEnum];
  @override
  final String wireName = 'MerchantDeviceCheckDtoFailedEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantDeviceCheckDtoFailedEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantDeviceCheckDtoFailedEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantDeviceCheckDtoFailedEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantDeviceCheckDto extends MerchantDeviceCheckDto {
  @override
  final BuiltList<MerchantDeviceCheckDtoFailedEnum> failed;
  @override
  final int? delayMs;

  factory _$MerchantDeviceCheckDto([
    void Function(MerchantDeviceCheckDtoBuilder)? updates,
  ]) => (MerchantDeviceCheckDtoBuilder()..update(updates))._build();

  _$MerchantDeviceCheckDto._({required this.failed, this.delayMs}) : super._();
  @override
  MerchantDeviceCheckDto rebuild(
    void Function(MerchantDeviceCheckDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDeviceCheckDtoBuilder toBuilder() =>
      MerchantDeviceCheckDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDeviceCheckDto &&
        failed == other.failed &&
        delayMs == other.delayMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jc(_$hash, delayMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDeviceCheckDto')
          ..add('failed', failed)
          ..add('delayMs', delayMs))
        .toString();
  }
}

class MerchantDeviceCheckDtoBuilder
    implements Builder<MerchantDeviceCheckDto, MerchantDeviceCheckDtoBuilder> {
  _$MerchantDeviceCheckDto? _$v;

  ListBuilder<MerchantDeviceCheckDtoFailedEnum>? _failed;
  ListBuilder<MerchantDeviceCheckDtoFailedEnum> get failed =>
      _$this._failed ??= ListBuilder<MerchantDeviceCheckDtoFailedEnum>();
  set failed(ListBuilder<MerchantDeviceCheckDtoFailedEnum>? failed) =>
      _$this._failed = failed;

  int? _delayMs;
  int? get delayMs => _$this._delayMs;
  set delayMs(int? delayMs) => _$this._delayMs = delayMs;

  MerchantDeviceCheckDtoBuilder() {
    MerchantDeviceCheckDto._defaults(this);
  }

  MerchantDeviceCheckDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _failed = $v.failed.toBuilder();
      _delayMs = $v.delayMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDeviceCheckDto other) {
    _$v = other as _$MerchantDeviceCheckDto;
  }

  @override
  void update(void Function(MerchantDeviceCheckDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDeviceCheckDto build() => _build();

  _$MerchantDeviceCheckDto _build() {
    _$MerchantDeviceCheckDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantDeviceCheckDto._(failed: failed.build(), delayMs: delayMs);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'failed';
        failed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantDeviceCheckDto',
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
