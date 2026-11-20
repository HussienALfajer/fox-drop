// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_export_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportExportBodyDto extends AdminReportExportBodyDto {
  @override
  final String cityId;
  @override
  final String from;
  @override
  final String to;

  factory _$AdminReportExportBodyDto([
    void Function(AdminReportExportBodyDtoBuilder)? updates,
  ]) => (AdminReportExportBodyDtoBuilder()..update(updates))._build();

  _$AdminReportExportBodyDto._({
    required this.cityId,
    required this.from,
    required this.to,
  }) : super._();
  @override
  AdminReportExportBodyDto rebuild(
    void Function(AdminReportExportBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReportExportBodyDtoBuilder toBuilder() =>
      AdminReportExportBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportExportBodyDto &&
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
    return (newBuiltValueToStringHelper(r'AdminReportExportBodyDto')
          ..add('cityId', cityId)
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class AdminReportExportBodyDtoBuilder
    implements
        Builder<AdminReportExportBodyDto, AdminReportExportBodyDtoBuilder> {
  _$AdminReportExportBodyDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  AdminReportExportBodyDtoBuilder() {
    AdminReportExportBodyDto._defaults(this);
  }

  AdminReportExportBodyDtoBuilder get _$this {
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
  void replace(AdminReportExportBodyDto other) {
    _$v = other as _$AdminReportExportBodyDto;
  }

  @override
  void update(void Function(AdminReportExportBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportExportBodyDto build() => _build();

  _$AdminReportExportBodyDto _build() {
    final _$result =
        _$v ??
        _$AdminReportExportBodyDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminReportExportBodyDto',
            'cityId',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminReportExportBodyDto',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminReportExportBodyDto',
            'to',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
