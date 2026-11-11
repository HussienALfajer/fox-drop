// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_peak_bonus_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetPeakBonusDto extends AdminSetPeakBonusDto {
  @override
  final String cityId;
  @override
  final bool enabled;
  @override
  final BuiltList<AdminSetPeakBonusDtoWindowsInner> windows;

  factory _$AdminSetPeakBonusDto([
    void Function(AdminSetPeakBonusDtoBuilder)? updates,
  ]) => (AdminSetPeakBonusDtoBuilder()..update(updates))._build();

  _$AdminSetPeakBonusDto._({
    required this.cityId,
    required this.enabled,
    required this.windows,
  }) : super._();
  @override
  AdminSetPeakBonusDto rebuild(
    void Function(AdminSetPeakBonusDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetPeakBonusDtoBuilder toBuilder() =>
      AdminSetPeakBonusDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetPeakBonusDto &&
        cityId == other.cityId &&
        enabled == other.enabled &&
        windows == other.windows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, windows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetPeakBonusDto')
          ..add('cityId', cityId)
          ..add('enabled', enabled)
          ..add('windows', windows))
        .toString();
  }
}

class AdminSetPeakBonusDtoBuilder
    implements Builder<AdminSetPeakBonusDto, AdminSetPeakBonusDtoBuilder> {
  _$AdminSetPeakBonusDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ListBuilder<AdminSetPeakBonusDtoWindowsInner>? _windows;
  ListBuilder<AdminSetPeakBonusDtoWindowsInner> get windows =>
      _$this._windows ??= ListBuilder<AdminSetPeakBonusDtoWindowsInner>();
  set windows(ListBuilder<AdminSetPeakBonusDtoWindowsInner>? windows) =>
      _$this._windows = windows;

  AdminSetPeakBonusDtoBuilder() {
    AdminSetPeakBonusDto._defaults(this);
  }

  AdminSetPeakBonusDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _enabled = $v.enabled;
      _windows = $v.windows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetPeakBonusDto other) {
    _$v = other as _$AdminSetPeakBonusDto;
  }

  @override
  void update(void Function(AdminSetPeakBonusDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetPeakBonusDto build() => _build();

  _$AdminSetPeakBonusDto _build() {
    _$AdminSetPeakBonusDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetPeakBonusDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminSetPeakBonusDto',
              'cityId',
            ),
            enabled: BuiltValueNullFieldError.checkNotNull(
              enabled,
              r'AdminSetPeakBonusDto',
              'enabled',
            ),
            windows: windows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'windows';
        windows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetPeakBonusDto',
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
