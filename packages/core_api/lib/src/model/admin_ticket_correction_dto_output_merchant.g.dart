// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_correction_dto_output_merchant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCorrectionDtoOutputMerchant
    extends AdminTicketCorrectionDtoOutputMerchant {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminTicketCorrectionDtoOutputMerchant([
    void Function(AdminTicketCorrectionDtoOutputMerchantBuilder)? updates,
  ]) => (AdminTicketCorrectionDtoOutputMerchantBuilder()..update(updates))
      ._build();

  _$AdminTicketCorrectionDtoOutputMerchant._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminTicketCorrectionDtoOutputMerchant rebuild(
    void Function(AdminTicketCorrectionDtoOutputMerchantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCorrectionDtoOutputMerchantBuilder toBuilder() =>
      AdminTicketCorrectionDtoOutputMerchantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCorrectionDtoOutputMerchant &&
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
            r'AdminTicketCorrectionDtoOutputMerchant',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminTicketCorrectionDtoOutputMerchantBuilder
    implements
        Builder<
          AdminTicketCorrectionDtoOutputMerchant,
          AdminTicketCorrectionDtoOutputMerchantBuilder
        > {
  _$AdminTicketCorrectionDtoOutputMerchant? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminTicketCorrectionDtoOutputMerchantBuilder() {
    AdminTicketCorrectionDtoOutputMerchant._defaults(this);
  }

  AdminTicketCorrectionDtoOutputMerchantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCorrectionDtoOutputMerchant other) {
    _$v = other as _$AdminTicketCorrectionDtoOutputMerchant;
  }

  @override
  void update(
    void Function(AdminTicketCorrectionDtoOutputMerchantBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCorrectionDtoOutputMerchant build() => _build();

  _$AdminTicketCorrectionDtoOutputMerchant _build() {
    final _$result =
        _$v ??
        _$AdminTicketCorrectionDtoOutputMerchant._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminTicketCorrectionDtoOutputMerchant',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminTicketCorrectionDtoOutputMerchant',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
