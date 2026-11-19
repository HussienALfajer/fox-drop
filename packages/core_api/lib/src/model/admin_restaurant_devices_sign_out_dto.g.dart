// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_devices_sign_out_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDevicesSignOutDto
    extends AdminRestaurantDevicesSignOutDto {
  @override
  final String? deviceId;
  @override
  final String reason;

  factory _$AdminRestaurantDevicesSignOutDto([
    void Function(AdminRestaurantDevicesSignOutDtoBuilder)? updates,
  ]) => (AdminRestaurantDevicesSignOutDtoBuilder()..update(updates))._build();

  _$AdminRestaurantDevicesSignOutDto._({this.deviceId, required this.reason})
    : super._();
  @override
  AdminRestaurantDevicesSignOutDto rebuild(
    void Function(AdminRestaurantDevicesSignOutDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDevicesSignOutDtoBuilder toBuilder() =>
      AdminRestaurantDevicesSignOutDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDevicesSignOutDto &&
        deviceId == other.deviceId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantDevicesSignOutDto')
          ..add('deviceId', deviceId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRestaurantDevicesSignOutDtoBuilder
    implements
        Builder<
          AdminRestaurantDevicesSignOutDto,
          AdminRestaurantDevicesSignOutDtoBuilder
        > {
  _$AdminRestaurantDevicesSignOutDto? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRestaurantDevicesSignOutDtoBuilder() {
    AdminRestaurantDevicesSignOutDto._defaults(this);
  }

  AdminRestaurantDevicesSignOutDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDevicesSignOutDto other) {
    _$v = other as _$AdminRestaurantDevicesSignOutDto;
  }

  @override
  void update(void Function(AdminRestaurantDevicesSignOutDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDevicesSignOutDto build() => _build();

  _$AdminRestaurantDevicesSignOutDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDevicesSignOutDto._(
          deviceId: deviceId,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRestaurantDevicesSignOutDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
