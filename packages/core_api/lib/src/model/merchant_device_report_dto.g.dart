// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantDeviceReportDto extends MerchantDeviceReportDto {
  @override
  final String appVersion;
  @override
  final bool? ringing;

  factory _$MerchantDeviceReportDto([
    void Function(MerchantDeviceReportDtoBuilder)? updates,
  ]) => (MerchantDeviceReportDtoBuilder()..update(updates))._build();

  _$MerchantDeviceReportDto._({required this.appVersion, this.ringing})
    : super._();
  @override
  MerchantDeviceReportDto rebuild(
    void Function(MerchantDeviceReportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDeviceReportDtoBuilder toBuilder() =>
      MerchantDeviceReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDeviceReportDto &&
        appVersion == other.appVersion &&
        ringing == other.ringing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, ringing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDeviceReportDto')
          ..add('appVersion', appVersion)
          ..add('ringing', ringing))
        .toString();
  }
}

class MerchantDeviceReportDtoBuilder
    implements
        Builder<MerchantDeviceReportDto, MerchantDeviceReportDtoBuilder> {
  _$MerchantDeviceReportDto? _$v;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  bool? _ringing;
  bool? get ringing => _$this._ringing;
  set ringing(bool? ringing) => _$this._ringing = ringing;

  MerchantDeviceReportDtoBuilder() {
    MerchantDeviceReportDto._defaults(this);
  }

  MerchantDeviceReportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _appVersion = $v.appVersion;
      _ringing = $v.ringing;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDeviceReportDto other) {
    _$v = other as _$MerchantDeviceReportDto;
  }

  @override
  void update(void Function(MerchantDeviceReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDeviceReportDto build() => _build();

  _$MerchantDeviceReportDto _build() {
    final _$result =
        _$v ??
        _$MerchantDeviceReportDto._(
          appVersion: BuiltValueNullFieldError.checkNotNull(
            appVersion,
            r'MerchantDeviceReportDto',
            'appVersion',
          ),
          ringing: ringing,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
