// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output_codes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCostReportDtoOutputCodesInner
    extends AdminCostReportDtoOutputCodesInner {
  @override
  final String? codeId;
  @override
  final String? code;
  @override
  final int orders;
  @override
  final String amount;

  factory _$AdminCostReportDtoOutputCodesInner([
    void Function(AdminCostReportDtoOutputCodesInnerBuilder)? updates,
  ]) => (AdminCostReportDtoOutputCodesInnerBuilder()..update(updates))._build();

  _$AdminCostReportDtoOutputCodesInner._({
    this.codeId,
    this.code,
    required this.orders,
    required this.amount,
  }) : super._();
  @override
  AdminCostReportDtoOutputCodesInner rebuild(
    void Function(AdminCostReportDtoOutputCodesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputCodesInnerBuilder toBuilder() =>
      AdminCostReportDtoOutputCodesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutputCodesInner &&
        codeId == other.codeId &&
        code == other.code &&
        orders == other.orders &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codeId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCostReportDtoOutputCodesInner')
          ..add('codeId', codeId)
          ..add('code', code)
          ..add('orders', orders)
          ..add('amount', amount))
        .toString();
  }
}

class AdminCostReportDtoOutputCodesInnerBuilder
    implements
        Builder<
          AdminCostReportDtoOutputCodesInner,
          AdminCostReportDtoOutputCodesInnerBuilder
        > {
  _$AdminCostReportDtoOutputCodesInner? _$v;

  String? _codeId;
  String? get codeId => _$this._codeId;
  set codeId(String? codeId) => _$this._codeId = codeId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminCostReportDtoOutputCodesInnerBuilder() {
    AdminCostReportDtoOutputCodesInner._defaults(this);
  }

  AdminCostReportDtoOutputCodesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codeId = $v.codeId;
      _code = $v.code;
      _orders = $v.orders;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutputCodesInner other) {
    _$v = other as _$AdminCostReportDtoOutputCodesInner;
  }

  @override
  void update(
    void Function(AdminCostReportDtoOutputCodesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutputCodesInner build() => _build();

  _$AdminCostReportDtoOutputCodesInner _build() {
    final _$result =
        _$v ??
        _$AdminCostReportDtoOutputCodesInner._(
          codeId: codeId,
          code: code,
          orders: BuiltValueNullFieldError.checkNotNull(
            orders,
            r'AdminCostReportDtoOutputCodesInner',
            'orders',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCostReportDtoOutputCodesInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
