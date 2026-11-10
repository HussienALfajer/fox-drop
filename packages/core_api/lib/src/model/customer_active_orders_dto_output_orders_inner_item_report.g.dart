// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_item_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport
    extends CustomerActiveOrdersDtoOutputOrdersInnerItemReport {
  @override
  final DateTime at;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport._({required this.at})
    : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerItemReport rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerItemReport &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerActiveOrdersDtoOutputOrdersInnerItemReport',
    )..add('at', at)).toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerItemReport,
          CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerItemReport._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerItemReport other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerItemReport build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerItemReport._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CustomerActiveOrdersDtoOutputOrdersInnerItemReport',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
