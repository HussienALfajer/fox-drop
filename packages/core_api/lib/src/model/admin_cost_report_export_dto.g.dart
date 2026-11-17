// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_export_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCostReportExportDto extends AdminCostReportExportDto {
  @override
  final String cityId;
  @override
  final String from;
  @override
  final String to;

  factory _$AdminCostReportExportDto([
    void Function(AdminCostReportExportDtoBuilder)? updates,
  ]) => (AdminCostReportExportDtoBuilder()..update(updates))._build();

  _$AdminCostReportExportDto._({
    required this.cityId,
    required this.from,
    required this.to,
  }) : super._();
  @override
  AdminCostReportExportDto rebuild(
    void Function(AdminCostReportExportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportExportDtoBuilder toBuilder() =>
      AdminCostReportExportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportExportDto &&
        cityId == other.cityId &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCostReportExportDto')
          ..add('cityId', cityId)
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class AdminCostReportExportDtoBuilder
    implements
        Builder<AdminCostReportExportDto, AdminCostReportExportDtoBuilder> {
  _$AdminCostReportExportDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  AdminCostReportExportDtoBuilder() {
    AdminCostReportExportDto._defaults(this);
  }

  AdminCostReportExportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportExportDto other) {
    _$v = other as _$AdminCostReportExportDto;
  }

  @override
  void update(void Function(AdminCostReportExportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportExportDto build() => _build();

  _$AdminCostReportExportDto _build() {
    final _$result =
        _$v ??
        _$AdminCostReportExportDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminCostReportExportDto',
            'cityId',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminCostReportExportDto',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminCostReportExportDto',
            'to',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
