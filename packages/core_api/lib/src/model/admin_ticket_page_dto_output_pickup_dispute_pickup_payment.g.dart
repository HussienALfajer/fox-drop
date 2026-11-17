// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_pickup_dispute_pickup_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputPickupDisputePickupPayment
    extends AdminTicketPageDtoOutputPickupDisputePickupPayment {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminTicketPageDtoOutputPickupDisputePickupPayment([
    void Function(AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder)?
    updates,
  ]) =>
      (AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder()
            ..update(updates))
          ._build();

  _$AdminTicketPageDtoOutputPickupDisputePickupPayment._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminTicketPageDtoOutputPickupDisputePickupPayment rebuild(
    void Function(AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder toBuilder() =>
      AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputPickupDisputePickupPayment &&
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
            r'AdminTicketPageDtoOutputPickupDisputePickupPayment',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputPickupDisputePickupPayment,
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder
        > {
  _$AdminTicketPageDtoOutputPickupDisputePickupPayment? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder() {
    AdminTicketPageDtoOutputPickupDisputePickupPayment._defaults(this);
  }

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputPickupDisputePickupPayment other) {
    _$v = other as _$AdminTicketPageDtoOutputPickupDisputePickupPayment;
  }

  @override
  void update(
    void Function(AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputPickupDisputePickupPayment build() => _build();

  _$AdminTicketPageDtoOutputPickupDisputePickupPayment _build() {
    final _$result =
        _$v ??
        _$AdminTicketPageDtoOutputPickupDisputePickupPayment._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminTicketPageDtoOutputPickupDisputePickupPayment',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminTicketPageDtoOutputPickupDisputePickupPayment',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
