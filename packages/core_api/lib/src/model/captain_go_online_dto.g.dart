// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_go_online_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainGoOnlineDto extends CaptainGoOnlineDto {
  @override
  final String appVersion;
  @override
  final bool simulatedLocation;

  factory _$CaptainGoOnlineDto([
    void Function(CaptainGoOnlineDtoBuilder)? updates,
  ]) => (CaptainGoOnlineDtoBuilder()..update(updates))._build();

  _$CaptainGoOnlineDto._({
    required this.appVersion,
    required this.simulatedLocation,
  }) : super._();
  @override
  CaptainGoOnlineDto rebuild(
    void Function(CaptainGoOnlineDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainGoOnlineDtoBuilder toBuilder() =>
      CaptainGoOnlineDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainGoOnlineDto &&
        appVersion == other.appVersion &&
        simulatedLocation == other.simulatedLocation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, simulatedLocation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainGoOnlineDto')
          ..add('appVersion', appVersion)
          ..add('simulatedLocation', simulatedLocation))
        .toString();
  }
}

class CaptainGoOnlineDtoBuilder
    implements Builder<CaptainGoOnlineDto, CaptainGoOnlineDtoBuilder> {
  _$CaptainGoOnlineDto? _$v;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  bool? _simulatedLocation;
  bool? get simulatedLocation => _$this._simulatedLocation;
  set simulatedLocation(bool? simulatedLocation) =>
      _$this._simulatedLocation = simulatedLocation;

  CaptainGoOnlineDtoBuilder() {
    CaptainGoOnlineDto._defaults(this);
  }

  CaptainGoOnlineDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _appVersion = $v.appVersion;
      _simulatedLocation = $v.simulatedLocation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainGoOnlineDto other) {
    _$v = other as _$CaptainGoOnlineDto;
  }

  @override
  void update(void Function(CaptainGoOnlineDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainGoOnlineDto build() => _build();

  _$CaptainGoOnlineDto _build() {
    final _$result =
        _$v ??
        _$CaptainGoOnlineDto._(
          appVersion: BuiltValueNullFieldError.checkNotNull(
            appVersion,
            r'CaptainGoOnlineDto',
            'appVersion',
          ),
          simulatedLocation: BuiltValueNullFieldError.checkNotNull(
            simulatedLocation,
            r'CaptainGoOnlineDto',
            'simulatedLocation',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
