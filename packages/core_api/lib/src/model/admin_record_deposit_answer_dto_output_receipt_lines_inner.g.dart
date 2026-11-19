// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_deposit_answer_dto_output_receipt_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner
    extends AdminRecordDepositAnswerDtoOutputReceiptLinesInner {
  @override
  final String currency;
  @override
  final String expected;
  @override
  final String amount;
  @override
  final String remaining;

  factory _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner([
    void Function(AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder)?
    updates,
  ]) =>
      (AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner._({
    required this.currency,
    required this.expected,
    required this.amount,
    required this.remaining,
  }) : super._();
  @override
  AdminRecordDepositAnswerDtoOutputReceiptLinesInner rebuild(
    void Function(AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder toBuilder() =>
      AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDepositAnswerDtoOutputReceiptLinesInner &&
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
            r'AdminRecordDepositAnswerDtoOutputReceiptLinesInner',
          )
          ..add('currency', currency)
          ..add('expected', expected)
          ..add('amount', amount)
          ..add('remaining', remaining))
        .toString();
  }
}

class AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder
    implements
        Builder<
          AdminRecordDepositAnswerDtoOutputReceiptLinesInner,
          AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder
        > {
  _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner? _$v;

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

  AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder() {
    AdminRecordDepositAnswerDtoOutputReceiptLinesInner._defaults(this);
  }

  AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder get _$this {
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
  void replace(AdminRecordDepositAnswerDtoOutputReceiptLinesInner other) {
    _$v = other as _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner;
  }

  @override
  void update(
    void Function(AdminRecordDepositAnswerDtoOutputReceiptLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDepositAnswerDtoOutputReceiptLinesInner build() => _build();

  _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminRecordDepositAnswerDtoOutputReceiptLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRecordDepositAnswerDtoOutputReceiptLinesInner',
            'currency',
          ),
          expected: BuiltValueNullFieldError.checkNotNull(
            expected,
            r'AdminRecordDepositAnswerDtoOutputReceiptLinesInner',
            'expected',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRecordDepositAnswerDtoOutputReceiptLinesInner',
            'amount',
          ),
          remaining: BuiltValueNullFieldError.checkNotNull(
            remaining,
            r'AdminRecordDepositAnswerDtoOutputReceiptLinesInner',
            'remaining',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
