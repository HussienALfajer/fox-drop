// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_devices_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantDevicesDtoOutput extends MerchantDevicesDtoOutput {
  @override
  final BuiltList<MerchantDevicesDtoOutputDevicesInner> devices;

  factory _$MerchantDevicesDtoOutput([
    void Function(MerchantDevicesDtoOutputBuilder)? updates,
  ]) => (MerchantDevicesDtoOutputBuilder()..update(updates))._build();

  _$MerchantDevicesDtoOutput._({required this.devices}) : super._();
  @override
  MerchantDevicesDtoOutput rebuild(
    void Function(MerchantDevicesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDevicesDtoOutputBuilder toBuilder() =>
      MerchantDevicesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDevicesDtoOutput && devices == other.devices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, devices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantDevicesDtoOutput',
    )..add('devices', devices)).toString();
  }
}

class MerchantDevicesDtoOutputBuilder
    implements
        Builder<MerchantDevicesDtoOutput, MerchantDevicesDtoOutputBuilder> {
  _$MerchantDevicesDtoOutput? _$v;

  ListBuilder<MerchantDevicesDtoOutputDevicesInner>? _devices;
  ListBuilder<MerchantDevicesDtoOutputDevicesInner> get devices =>
      _$this._devices ??= ListBuilder<MerchantDevicesDtoOutputDevicesInner>();
  set devices(ListBuilder<MerchantDevicesDtoOutputDevicesInner>? devices) =>
      _$this._devices = devices;

  MerchantDevicesDtoOutputBuilder() {
    MerchantDevicesDtoOutput._defaults(this);
  }

  MerchantDevicesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _devices = $v.devices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDevicesDtoOutput other) {
    _$v = other as _$MerchantDevicesDtoOutput;
  }

  @override
  void update(void Function(MerchantDevicesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDevicesDtoOutput build() => _build();

  _$MerchantDevicesDtoOutput _build() {
    _$MerchantDevicesDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantDevicesDtoOutput._(devices: devices.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'devices';
        devices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantDevicesDtoOutput',
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
