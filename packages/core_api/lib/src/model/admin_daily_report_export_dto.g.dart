// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_export_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportExportDto extends AdminDailyReportExportDto {
  @override
  final String cityId;
  @override
  final String day;

  factory _$AdminDailyReportExportDto([
    void Function(AdminDailyReportExportDtoBuilder)? updates,
  ]) => (AdminDailyReportExportDtoBuilder()..update(updates))._build();

  _$AdminDailyReportExportDto._({required this.cityId, required this.day})
    : super._();
  @override
  AdminDailyReportExportDto rebuild(
    void Function(AdminDailyReportExportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportExportDtoBuilder toBuilder() =>
      AdminDailyReportExportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportExportDto &&
        cityId == other.cityId &&
        day == other.day;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportExportDto')
          ..add('cityId', cityId)
          ..add('day', day))
        .toString();
  }
}

class AdminDailyReportExportDtoBuilder
    implements
        Builder<AdminDailyReportExportDto, AdminDailyReportExportDtoBuilder> {
  _$AdminDailyReportExportDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _day;
  String? get day => _$this._day;
  set day(String? day) => _$this._day = day;

  AdminDailyReportExportDtoBuilder() {
    AdminDailyReportExportDto._defaults(this);
  }

  AdminDailyReportExportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _day = $v.day;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportExportDto other) {
    _$v = other as _$AdminDailyReportExportDto;
  }

  @override
  void update(void Function(AdminDailyReportExportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportExportDto build() => _build();

  _$AdminDailyReportExportDto _build() {
    final _$result =
        _$v ??
        _$AdminDailyReportExportDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminDailyReportExportDto',
            'cityId',
          ),
          day: BuiltValueNullFieldError.checkNotNull(
            day,
            r'AdminDailyReportExportDto',
            'day',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
