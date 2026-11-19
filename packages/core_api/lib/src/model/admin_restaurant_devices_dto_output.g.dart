// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_devices_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDevicesDtoOutput
    extends AdminRestaurantDevicesDtoOutput {
  @override
  final BuiltList<AdminRestaurantDevicesDtoOutputDevicesInner> devices;

  factory _$AdminRestaurantDevicesDtoOutput([
    void Function(AdminRestaurantDevicesDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantDevicesDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantDevicesDtoOutput._({required this.devices}) : super._();
  @override
  AdminRestaurantDevicesDtoOutput rebuild(
    void Function(AdminRestaurantDevicesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDevicesDtoOutputBuilder toBuilder() =>
      AdminRestaurantDevicesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDevicesDtoOutput && devices == other.devices;
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
      r'AdminRestaurantDevicesDtoOutput',
    )..add('devices', devices)).toString();
  }
}

class AdminRestaurantDevicesDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantDevicesDtoOutput,
          AdminRestaurantDevicesDtoOutputBuilder
        > {
  _$AdminRestaurantDevicesDtoOutput? _$v;

  ListBuilder<AdminRestaurantDevicesDtoOutputDevicesInner>? _devices;
  ListBuilder<AdminRestaurantDevicesDtoOutputDevicesInner> get devices =>
      _$this._devices ??=
          ListBuilder<AdminRestaurantDevicesDtoOutputDevicesInner>();
  set devices(
    ListBuilder<AdminRestaurantDevicesDtoOutputDevicesInner>? devices,
  ) => _$this._devices = devices;

  AdminRestaurantDevicesDtoOutputBuilder() {
    AdminRestaurantDevicesDtoOutput._defaults(this);
  }

  AdminRestaurantDevicesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _devices = $v.devices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDevicesDtoOutput other) {
    _$v = other as _$AdminRestaurantDevicesDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantDevicesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDevicesDtoOutput build() => _build();

  _$AdminRestaurantDevicesDtoOutput _build() {
    _$AdminRestaurantDevicesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminRestaurantDevicesDtoOutput._(devices: devices.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'devices';
        devices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDevicesDtoOutput',
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
