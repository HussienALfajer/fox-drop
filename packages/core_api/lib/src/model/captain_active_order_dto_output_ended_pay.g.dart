// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_ended_pay.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputEndedPay
    extends CaptainActiveOrderDtoOutputEndedPay {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainActiveOrderDtoOutputEndedPay([
    void Function(CaptainActiveOrderDtoOutputEndedPayBuilder)? updates,
  ]) =>
      (CaptainActiveOrderDtoOutputEndedPayBuilder()..update(updates))._build();

  _$CaptainActiveOrderDtoOutputEndedPay._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputEndedPay rebuild(
    void Function(CaptainActiveOrderDtoOutputEndedPayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputEndedPayBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputEndedPayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputEndedPay &&
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
    return (newBuiltValueToStringHelper(r'CaptainActiveOrderDtoOutputEndedPay')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputEndedPayBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputEndedPay,
          CaptainActiveOrderDtoOutputEndedPayBuilder
        > {
  _$CaptainActiveOrderDtoOutputEndedPay? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainActiveOrderDtoOutputEndedPayBuilder() {
    CaptainActiveOrderDtoOutputEndedPay._defaults(this);
  }

  CaptainActiveOrderDtoOutputEndedPayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputEndedPay other) {
    _$v = other as _$CaptainActiveOrderDtoOutputEndedPay;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputEndedPayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputEndedPay build() => _build();

  _$CaptainActiveOrderDtoOutputEndedPay _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputEndedPay._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainActiveOrderDtoOutputEndedPay',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainActiveOrderDtoOutputEndedPay',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
