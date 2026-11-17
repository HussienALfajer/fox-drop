// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output_compensation_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCostReportDtoOutputCompensationReasonsInner
    extends AdminCostReportDtoOutputCompensationReasonsInner {
  @override
  final String reason;
  @override
  final String? label;
  @override
  final int orders;
  @override
  final String amount;

  factory _$AdminCostReportDtoOutputCompensationReasonsInner([
    void Function(AdminCostReportDtoOutputCompensationReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminCostReportDtoOutputCompensationReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCostReportDtoOutputCompensationReasonsInner._({
    required this.reason,
    this.label,
    required this.orders,
    required this.amount,
  }) : super._();
  @override
  AdminCostReportDtoOutputCompensationReasonsInner rebuild(
    void Function(AdminCostReportDtoOutputCompensationReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputCompensationReasonsInnerBuilder toBuilder() =>
      AdminCostReportDtoOutputCompensationReasonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutputCompensationReasonsInner &&
        reason == other.reason &&
        label == other.label &&
        orders == other.orders &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCostReportDtoOutputCompensationReasonsInner',
          )
          ..add('reason', reason)
          ..add('label', label)
          ..add('orders', orders)
          ..add('amount', amount))
        .toString();
  }
}

class AdminCostReportDtoOutputCompensationReasonsInnerBuilder
    implements
        Builder<
          AdminCostReportDtoOutputCompensationReasonsInner,
          AdminCostReportDtoOutputCompensationReasonsInnerBuilder
        > {
  _$AdminCostReportDtoOutputCompensationReasonsInner? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminCostReportDtoOutputCompensationReasonsInnerBuilder() {
    AdminCostReportDtoOutputCompensationReasonsInner._defaults(this);
  }

  AdminCostReportDtoOutputCompensationReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _label = $v.label;
      _orders = $v.orders;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutputCompensationReasonsInner other) {
    _$v = other as _$AdminCostReportDtoOutputCompensationReasonsInner;
  }

  @override
  void update(
    void Function(AdminCostReportDtoOutputCompensationReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutputCompensationReasonsInner build() => _build();

  _$AdminCostReportDtoOutputCompensationReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminCostReportDtoOutputCompensationReasonsInner._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCostReportDtoOutputCompensationReasonsInner',
            'reason',
          ),
          label: label,
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminCostReportDtoOutputCompensationReasonsInner',
            'orders',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCostReportDtoOutputCompensationReasonsInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
