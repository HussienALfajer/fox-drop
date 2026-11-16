// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promo_code_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPromoCodeReportDtoOutput extends AdminPromoCodeReportDtoOutput {
  @override
  final AdminPromoCodesDtoOutputCodesInner code;
  @override
  final AdminPromoCodeReportDtoOutputReport report;
  @override
  final bool canManage;

  factory _$AdminPromoCodeReportDtoOutput([
    void Function(AdminPromoCodeReportDtoOutputBuilder)? updates,
  ]) => (AdminPromoCodeReportDtoOutputBuilder()..update(updates))._build();

  _$AdminPromoCodeReportDtoOutput._({
    required this.code,
    required this.report,
    required this.canManage,
  }) : super._();
  @override
  AdminPromoCodeReportDtoOutput rebuild(
    void Function(AdminPromoCodeReportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPromoCodeReportDtoOutputBuilder toBuilder() =>
      AdminPromoCodeReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPromoCodeReportDtoOutput &&
        code == other.code &&
        report == other.report &&
        canManage == other.canManage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, report.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPromoCodeReportDtoOutput')
          ..add('code', code)
          ..add('report', report)
          ..add('canManage', canManage))
        .toString();
  }
}

class AdminPromoCodeReportDtoOutputBuilder
    implements
        Builder<
          AdminPromoCodeReportDtoOutput,
          AdminPromoCodeReportDtoOutputBuilder
        > {
  _$AdminPromoCodeReportDtoOutput? _$v;

  AdminPromoCodesDtoOutputCodesInnerBuilder? _code;
  AdminPromoCodesDtoOutputCodesInnerBuilder get code =>
      _$this._code ??= AdminPromoCodesDtoOutputCodesInnerBuilder();
  set code(AdminPromoCodesDtoOutputCodesInnerBuilder? code) =>
      _$this._code = code;

  AdminPromoCodeReportDtoOutputReportBuilder? _report;
  AdminPromoCodeReportDtoOutputReportBuilder get report =>
      _$this._report ??= AdminPromoCodeReportDtoOutputReportBuilder();
  set report(AdminPromoCodeReportDtoOutputReportBuilder? report) =>
      _$this._report = report;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  AdminPromoCodeReportDtoOutputBuilder() {
    AdminPromoCodeReportDtoOutput._defaults(this);
  }

  AdminPromoCodeReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code.toBuilder();
      _report = $v.report.toBuilder();
      _canManage = $v.canManage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPromoCodeReportDtoOutput other) {
    _$v = other as _$AdminPromoCodeReportDtoOutput;
  }

  @override
  void update(void Function(AdminPromoCodeReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPromoCodeReportDtoOutput build() => _build();

  _$AdminPromoCodeReportDtoOutput _build() {
    _$AdminPromoCodeReportDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminPromoCodeReportDtoOutput._(
            code: code.build(),
            report: report.build(),
            canManage: BuiltValueNullFieldError.checkNotNull(
              canManage,
              r'AdminPromoCodeReportDtoOutput',
              'canManage',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'code';
        code.build();
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPromoCodeReportDtoOutput',
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
