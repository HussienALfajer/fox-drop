// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_outcome_to_collect_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount
    extends CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount([
    void Function(
      CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder,
    )?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount &&
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
            r'CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount,
          CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder() {
    CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount;
  }

  @override
  void update(
    void Function(
      CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmountBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount build() => _build();

  _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainActiveOrderDtoOutputOrderOutcomeToCollectAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
