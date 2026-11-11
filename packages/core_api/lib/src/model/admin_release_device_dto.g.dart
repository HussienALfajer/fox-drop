// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_release_device_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReleaseDeviceDto extends AdminReleaseDeviceDto {
  @override
  final String sessionId;
  @override
  final String reason;

  factory _$AdminReleaseDeviceDto([
    void Function(AdminReleaseDeviceDtoBuilder)? updates,
  ]) => (AdminReleaseDeviceDtoBuilder()..update(updates))._build();

  _$AdminReleaseDeviceDto._({required this.sessionId, required this.reason})
    : super._();
  @override
  AdminReleaseDeviceDto rebuild(
    void Function(AdminReleaseDeviceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReleaseDeviceDtoBuilder toBuilder() =>
      AdminReleaseDeviceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReleaseDeviceDto &&
        sessionId == other.sessionId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReleaseDeviceDto')
          ..add('sessionId', sessionId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminReleaseDeviceDtoBuilder
    implements Builder<AdminReleaseDeviceDto, AdminReleaseDeviceDtoBuilder> {
  _$AdminReleaseDeviceDto? _$v;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminReleaseDeviceDtoBuilder() {
    AdminReleaseDeviceDto._defaults(this);
  }

  AdminReleaseDeviceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReleaseDeviceDto other) {
    _$v = other as _$AdminReleaseDeviceDto;
  }

  @override
  void update(void Function(AdminReleaseDeviceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReleaseDeviceDto build() => _build();

  _$AdminReleaseDeviceDto _build() {
    final _$result =
        _$v ??
        _$AdminReleaseDeviceDto._(
          sessionId: BuiltValueNullFieldError.checkNotNull(
            sessionId,
            r'AdminReleaseDeviceDto',
            'sessionId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminReleaseDeviceDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
