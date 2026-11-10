// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_ended_charge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputEndedCharge
    extends CaptainActiveOrderDtoOutputEndedCharge {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainActiveOrderDtoOutputEndedCharge([
    void Function(CaptainActiveOrderDtoOutputEndedChargeBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputEndedChargeBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputEndedCharge._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputEndedCharge rebuild(
    void Function(CaptainActiveOrderDtoOutputEndedChargeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputEndedChargeBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputEndedChargeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputEndedCharge &&
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
            r'CaptainActiveOrderDtoOutputEndedCharge',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputEndedChargeBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputEndedCharge,
          CaptainActiveOrderDtoOutputEndedChargeBuilder
        > {
  _$CaptainActiveOrderDtoOutputEndedCharge? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainActiveOrderDtoOutputEndedChargeBuilder() {
    CaptainActiveOrderDtoOutputEndedCharge._defaults(this);
  }

  CaptainActiveOrderDtoOutputEndedChargeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputEndedCharge other) {
    _$v = other as _$CaptainActiveOrderDtoOutputEndedCharge;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputEndedChargeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputEndedCharge build() => _build();

  _$CaptainActiveOrderDtoOutputEndedCharge _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputEndedCharge._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainActiveOrderDtoOutputEndedCharge',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainActiveOrderDtoOutputEndedCharge',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
