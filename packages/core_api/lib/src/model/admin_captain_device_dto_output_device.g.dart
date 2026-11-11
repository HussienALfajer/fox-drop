// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_device_dto_output_device.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainDeviceDtoOutputDevice
    extends AdminCaptainDeviceDtoOutputDevice {
  @override
  final String sessionId;
  @override
  final DateTime signedInAt;

  factory _$AdminCaptainDeviceDtoOutputDevice([
    void Function(AdminCaptainDeviceDtoOutputDeviceBuilder)? updates,
  ]) => (AdminCaptainDeviceDtoOutputDeviceBuilder()..update(updates))._build();

  _$AdminCaptainDeviceDtoOutputDevice._({
    required this.sessionId,
    required this.signedInAt,
  }) : super._();
  @override
  AdminCaptainDeviceDtoOutputDevice rebuild(
    void Function(AdminCaptainDeviceDtoOutputDeviceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainDeviceDtoOutputDeviceBuilder toBuilder() =>
      AdminCaptainDeviceDtoOutputDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainDeviceDtoOutputDevice &&
        sessionId == other.sessionId &&
        signedInAt == other.signedInAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, signedInAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainDeviceDtoOutputDevice')
          ..add('sessionId', sessionId)
          ..add('signedInAt', signedInAt))
        .toString();
  }
}

class AdminCaptainDeviceDtoOutputDeviceBuilder
    implements
        Builder<
          AdminCaptainDeviceDtoOutputDevice,
          AdminCaptainDeviceDtoOutputDeviceBuilder
        > {
  _$AdminCaptainDeviceDtoOutputDevice? _$v;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  DateTime? _signedInAt;
  DateTime? get signedInAt => _$this._signedInAt;
  set signedInAt(DateTime? signedInAt) => _$this._signedInAt = signedInAt;

  AdminCaptainDeviceDtoOutputDeviceBuilder() {
    AdminCaptainDeviceDtoOutputDevice._defaults(this);
  }

  AdminCaptainDeviceDtoOutputDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _signedInAt = $v.signedInAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainDeviceDtoOutputDevice other) {
    _$v = other as _$AdminCaptainDeviceDtoOutputDevice;
  }

  @override
  void update(
    void Function(AdminCaptainDeviceDtoOutputDeviceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainDeviceDtoOutputDevice build() => _build();

  _$AdminCaptainDeviceDtoOutputDevice _build() {
    final _$result =
        _$v ??
        _$AdminCaptainDeviceDtoOutputDevice._(
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'AdminCaptainDeviceDtoOutputDevice',
            'sessionId',
          ),
          signedInAt: BuiltValueNullFieldError.checkNotNull(
            signedInAt,
            r'AdminCaptainDeviceDtoOutputDevice',
            'signedInAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
