// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCostReportDtoOutputTotals extends AdminCostReportDtoOutputTotals {
  @override
  final String discounts;
  @override
  final String compensation;
  @override
  final String operating;
  @override
  final String total;

  factory _$AdminCostReportDtoOutputTotals([
    void Function(AdminCostReportDtoOutputTotalsBuilder)? updates,
  ]) => (AdminCostReportDtoOutputTotalsBuilder()..update(updates))._build();

  _$AdminCostReportDtoOutputTotals._({
    required this.discounts,
    required this.compensation,
    required this.operating,
    required this.total,
  }) : super._();
  @override
  AdminCostReportDtoOutputTotals rebuild(
    void Function(AdminCostReportDtoOutputTotalsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputTotalsBuilder toBuilder() =>
      AdminCostReportDtoOutputTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutputTotals &&
        discounts == other.discounts &&
        compensation == other.compensation &&
        operating == other.operating &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, discounts.hashCode);
    _$hash = $jc(_$hash, compensation.hashCode);
    _$hash = $jc(_$hash, operating.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCostReportDtoOutputTotals')
          ..add('discounts', discounts)
          ..add('compensation', compensation)
          ..add('operating', operating)
          ..add('total', total))
        .toString();
  }
}

class AdminCostReportDtoOutputTotalsBuilder
    implements
        Builder<
          AdminCostReportDtoOutputTotals,
          AdminCostReportDtoOutputTotalsBuilder
        > {
  _$AdminCostReportDtoOutputTotals? _$v;

  String? _discounts;
  String? get discounts => _$this._discounts;
  set discounts(String? discounts) => _$this._discounts = discounts;

  String? _compensation;
  String? get compensation => _$this._compensation;
  set compensation(String? compensation) => _$this._compensation = compensation;

  String? _operating;
  String? get operating => _$this._operating;
  set operating(String? operating) => _$this._operating = operating;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  AdminCostReportDtoOutputTotalsBuilder() {
    AdminCostReportDtoOutputTotals._defaults(this);
  }

  AdminCostReportDtoOutputTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _discounts = $v.discounts;
      _compensation = $v.compensation;
      _operating = $v.operating;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutputTotals other) {
    _$v = other as _$AdminCostReportDtoOutputTotals;
  }

  @override
  void update(void Function(AdminCostReportDtoOutputTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutputTotals build() => _build();

  _$AdminCostReportDtoOutputTotals _build() {
    final _$result =
        _$v ??
        _$AdminCostReportDtoOutputTotals._(
          discounts: BuiltValueNullFieldError.checkNotNull(
            discounts,
            r'AdminCostReportDtoOutputTotals',
            'discounts',
          ),
          compensation: BuiltValueNullFieldError.checkNotNull(
            compensation,
            r'AdminCostReportDtoOutputTotals',
            'compensation',
          ),
          operating: BuiltValueNullFieldError.checkNotNull(
            operating,
            r'AdminCostReportDtoOutputTotals',
            'operating',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminCostReportDtoOutputTotals',
            'total',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
