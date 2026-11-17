// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_lift_customer_device_block_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiftCustomerDeviceBlockDto
    extends AdminLiftCustomerDeviceBlockDto {
  @override
  final String cityId;
  @override
  final String deviceId;
  @override
  final String note;

  factory _$AdminLiftCustomerDeviceBlockDto([
    void Function(AdminLiftCustomerDeviceBlockDtoBuilder)? updates,
  ]) => (AdminLiftCustomerDeviceBlockDtoBuilder()..update(updates))._build();

  _$AdminLiftCustomerDeviceBlockDto._({
    required this.cityId,
    required this.deviceId,
    required this.note,
  }) : super._();
  @override
  AdminLiftCustomerDeviceBlockDto rebuild(
    void Function(AdminLiftCustomerDeviceBlockDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiftCustomerDeviceBlockDtoBuilder toBuilder() =>
      AdminLiftCustomerDeviceBlockDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiftCustomerDeviceBlockDto &&
        cityId == other.cityId &&
        deviceId == other.deviceId &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminLiftCustomerDeviceBlockDto')
          ..add('cityId', cityId)
          ..add('deviceId', deviceId)
          ..add('note', note))
        .toString();
  }
}

class AdminLiftCustomerDeviceBlockDtoBuilder
    implements
        Builder<
          AdminLiftCustomerDeviceBlockDto,
          AdminLiftCustomerDeviceBlockDtoBuilder
        > {
  _$AdminLiftCustomerDeviceBlockDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminLiftCustomerDeviceBlockDtoBuilder() {
    AdminLiftCustomerDeviceBlockDto._defaults(this);
  }

  AdminLiftCustomerDeviceBlockDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _deviceId = $v.deviceId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiftCustomerDeviceBlockDto other) {
    _$v = other as _$AdminLiftCustomerDeviceBlockDto;
  }

  @override
  void update(void Function(AdminLiftCustomerDeviceBlockDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiftCustomerDeviceBlockDto build() => _build();

  _$AdminLiftCustomerDeviceBlockDto _build() {
    final _$result =
        _$v ??
        _$AdminLiftCustomerDeviceBlockDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminLiftCustomerDeviceBlockDto',
            'cityId',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'AdminLiftCustomerDeviceBlockDto',
            'deviceId',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminLiftCustomerDeviceBlockDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
