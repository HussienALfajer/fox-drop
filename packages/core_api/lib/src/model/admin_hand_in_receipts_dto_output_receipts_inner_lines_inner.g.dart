// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_receipts_dto_output_receipts_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner
    extends AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner {
  @override
  final String currency;
  @override
  final String expected;
  @override
  final String amount;
  @override
  final String remaining;

  factory _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner([
    void Function(AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ]) =>
      (AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner._({
    required this.currency,
    required this.expected,
    required this.amount,
    required this.remaining,
  }) : super._();
  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner rebuild(
    void Function(AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder toBuilder() =>
      AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner &&
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
            r'AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner',
          )
          ..add('currency', currency)
          ..add('expected', expected)
          ..add('amount', amount)
          ..add('remaining', remaining))
        .toString();
  }
}

class AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder
    implements
        Builder<
          AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner,
          AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder
        > {
  _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner? _$v;

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

  AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder() {
    AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner._defaults(this);
  }

  AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder get _$this {
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
  void replace(AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner other) {
    _$v = other as _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner;
  }

  @override
  void update(
    void Function(AdminHandInReceiptsDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner build() => _build();

  _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner',
            'currency',
          ),
          expected: BuiltValueNullFieldError.checkNotNull(
            expected,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner',
            'expected',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner',
            'amount',
          ),
          remaining: BuiltValueNullFieldError.checkNotNull(
            remaining,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerLinesInner',
            'remaining',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
