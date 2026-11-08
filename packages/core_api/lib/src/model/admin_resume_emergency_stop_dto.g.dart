// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_resume_emergency_stop_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminResumeEmergencyStopDto extends AdminResumeEmergencyStopDto {
  @override
  final String cityId;
  @override
  final String stopId;
  @override
  final String? serviceBack;

  factory _$AdminResumeEmergencyStopDto([
    void Function(AdminResumeEmergencyStopDtoBuilder)? updates,
  ]) => (AdminResumeEmergencyStopDtoBuilder()..update(updates))._build();

  _$AdminResumeEmergencyStopDto._({
    required this.cityId,
    required this.stopId,
    this.serviceBack,
  }) : super._();
  @override
  AdminResumeEmergencyStopDto rebuild(
    void Function(AdminResumeEmergencyStopDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminResumeEmergencyStopDtoBuilder toBuilder() =>
      AdminResumeEmergencyStopDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminResumeEmergencyStopDto &&
        cityId == other.cityId &&
        stopId == other.stopId &&
        serviceBack == other.serviceBack;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, stopId.hashCode);
    _$hash = $jc(_$hash, serviceBack.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminResumeEmergencyStopDto')
          ..add('cityId', cityId)
          ..add('stopId', stopId)
          ..add('serviceBack', serviceBack))
        .toString();
  }
}

class AdminResumeEmergencyStopDtoBuilder
    implements
        Builder<
          AdminResumeEmergencyStopDto,
          AdminResumeEmergencyStopDtoBuilder
        > {
  _$AdminResumeEmergencyStopDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _stopId;
  String? get stopId => _$this._stopId;
  set stopId(String? stopId) => _$this._stopId = stopId;

  String? _serviceBack;
  String? get serviceBack => _$this._serviceBack;
  set serviceBack(String? serviceBack) => _$this._serviceBack = serviceBack;

  AdminResumeEmergencyStopDtoBuilder() {
    AdminResumeEmergencyStopDto._defaults(this);
  }

  AdminResumeEmergencyStopDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _stopId = $v.stopId;
      _serviceBack = $v.serviceBack;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminResumeEmergencyStopDto other) {
    _$v = other as _$AdminResumeEmergencyStopDto;
  }

  @override
  void update(void Function(AdminResumeEmergencyStopDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminResumeEmergencyStopDto build() => _build();

  _$AdminResumeEmergencyStopDto _build() {
    final _$result =
        _$v ??
        _$AdminResumeEmergencyStopDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminResumeEmergencyStopDto',
            'cityId',
          ),
          stopId: BuiltValueNullFieldError.checkNotNull(
            stopId,
            r'AdminResumeEmergencyStopDto',
            'stopId',
          ),
          serviceBack: serviceBack,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
