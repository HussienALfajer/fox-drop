// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_correction_dto_output_entries_inner_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCorrectionDtoOutputEntriesInnerAmount
    extends AdminTicketCorrectionDtoOutputEntriesInnerAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminTicketCorrectionDtoOutputEntriesInnerAmount([
    void Function(AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder)?
    updates,
  ]) =>
      (AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder()
            ..update(updates))
          ._build();

  _$AdminTicketCorrectionDtoOutputEntriesInnerAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminTicketCorrectionDtoOutputEntriesInnerAmount rebuild(
    void Function(AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder toBuilder() =>
      AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCorrectionDtoOutputEntriesInnerAmount &&
        amount == other.amount &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketCorrectionDtoOutputEntriesInnerAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder
    implements
        Builder<
          AdminTicketCorrectionDtoOutputEntriesInnerAmount,
          AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder
        > {
  _$AdminTicketCorrectionDtoOutputEntriesInnerAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder() {
    AdminTicketCorrectionDtoOutputEntriesInnerAmount._defaults(this);
  }

  AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCorrectionDtoOutputEntriesInnerAmount other) {
    _$v = other as _$AdminTicketCorrectionDtoOutputEntriesInnerAmount;
  }

  @override
  void update(
    void Function(AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCorrectionDtoOutputEntriesInnerAmount build() => _build();

  _$AdminTicketCorrectionDtoOutputEntriesInnerAmount _build() {
    final _$result =
        _$v ??
        _$AdminTicketCorrectionDtoOutputEntriesInnerAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminTicketCorrectionDtoOutputEntriesInnerAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminTicketCorrectionDtoOutputEntriesInnerAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
