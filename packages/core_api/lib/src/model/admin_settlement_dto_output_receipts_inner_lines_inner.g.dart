// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_dto_output_receipts_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementDtoOutputReceiptsInnerLinesInner
    extends AdminSettlementDtoOutputReceiptsInnerLinesInner {
  @override
  final String currency;
  @override
  final String expected;
  @override
  final String amount;
  @override
  final String remaining;

  factory _$AdminSettlementDtoOutputReceiptsInnerLinesInner([
    void Function(AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ]) =>
      (AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminSettlementDtoOutputReceiptsInnerLinesInner._({
    required this.currency,
    required this.expected,
    required this.amount,
    required this.remaining,
  }) : super._();
  @override
  AdminSettlementDtoOutputReceiptsInnerLinesInner rebuild(
    void Function(AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder toBuilder() =>
      AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementDtoOutputReceiptsInnerLinesInner &&
        currency == other.currency &&
        expected == other.expected &&
        amount == other.amount &&
        remaining == other.remaining;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, expected.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, remaining.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSettlementDtoOutputReceiptsInnerLinesInner',
          )
          ..add('currency', currency)
          ..add('expected', expected)
          ..add('amount', amount)
          ..add('remaining', remaining))
        .toString();
  }
}

class AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder
    implements
        Builder<
          AdminSettlementDtoOutputReceiptsInnerLinesInner,
          AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder
        > {
  _$AdminSettlementDtoOutputReceiptsInnerLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _expected;
  String? get expected => _$this._expected;
  set expected(String? expected) => _$this._expected = expected;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _remaining;
  String? get remaining => _$this._remaining;
  set remaining(String? remaining) => _$this._remaining = remaining;

  AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder() {
    AdminSettlementDtoOutputReceiptsInnerLinesInner._defaults(this);
  }

  AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _expected = $v.expected;
      _amount = $v.amount;
      _remaining = $v.remaining;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementDtoOutputReceiptsInnerLinesInner other) {
    _$v = other as _$AdminSettlementDtoOutputReceiptsInnerLinesInner;
  }

  @override
  void update(
    void Function(AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementDtoOutputReceiptsInnerLinesInner build() => _build();

  _$AdminSettlementDtoOutputReceiptsInnerLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminSettlementDtoOutputReceiptsInnerLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettlementDtoOutputReceiptsInnerLinesInner',
            'currency',
          ),
          expected: BuiltValueNullFieldError.checkNotNull(
            expected,
            r'AdminSettlementDtoOutputReceiptsInnerLinesInner',
            'expected',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminSettlementDtoOutputReceiptsInnerLinesInner',
            'amount',
          ),
          remaining: BuiltValueNullFieldError.checkNotNull(
            remaining,
            r'AdminSettlementDtoOutputReceiptsInnerLinesInner',
            'remaining',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
