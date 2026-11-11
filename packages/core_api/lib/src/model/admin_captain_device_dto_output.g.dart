// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_device_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainDeviceDtoOutput extends AdminCaptainDeviceDtoOutput {
  @override
  final AdminCaptainDeviceDtoOutputDevice? device;

  factory _$AdminCaptainDeviceDtoOutput([
    void Function(AdminCaptainDeviceDtoOutputBuilder)? updates,
  ]) => (AdminCaptainDeviceDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainDeviceDtoOutput._({this.device}) : super._();
  @override
  AdminCaptainDeviceDtoOutput rebuild(
    void Function(AdminCaptainDeviceDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainDeviceDtoOutputBuilder toBuilder() =>
      AdminCaptainDeviceDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainDeviceDtoOutput && device == other.device;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainDeviceDtoOutput',
    )..add('device', device)).toString();
  }
}

class AdminCaptainDeviceDtoOutputBuilder
    implements
        Builder<
          AdminCaptainDeviceDtoOutput,
          AdminCaptainDeviceDtoOutputBuilder
        > {
  _$AdminCaptainDeviceDtoOutput? _$v;

  AdminCaptainDeviceDtoOutputDeviceBuilder? _device;
  AdminCaptainDeviceDtoOutputDeviceBuilder get device =>
      _$this._device ??= AdminCaptainDeviceDtoOutputDeviceBuilder();
  set device(AdminCaptainDeviceDtoOutputDeviceBuilder? device) =>
      _$this._device = device;

  AdminCaptainDeviceDtoOutputBuilder() {
    AdminCaptainDeviceDtoOutput._defaults(this);
  }

  AdminCaptainDeviceDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _device = $v.device?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainDeviceDtoOutput other) {
    _$v = other as _$AdminCaptainDeviceDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainDeviceDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainDeviceDtoOutput build() => _build();

  _$AdminCaptainDeviceDtoOutput _build() {
    _$AdminCaptainDeviceDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCaptainDeviceDtoOutput._(device: _device?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'device';
        _device?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainDeviceDtoOutput',
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
