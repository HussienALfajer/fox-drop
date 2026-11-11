// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_peak_bonus_dto_output_active_inner_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPeakBonusDtoOutputActiveInnerAmount
    extends CaptainPeakBonusDtoOutputActiveInnerAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainPeakBonusDtoOutputActiveInnerAmount([
    void Function(CaptainPeakBonusDtoOutputActiveInnerAmountBuilder)? updates,
  ]) => (CaptainPeakBonusDtoOutputActiveInnerAmountBuilder()..update(updates))
      ._build();

  _$CaptainPeakBonusDtoOutputActiveInnerAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainPeakBonusDtoOutputActiveInnerAmount rebuild(
    void Function(CaptainPeakBonusDtoOutputActiveInnerAmountBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPeakBonusDtoOutputActiveInnerAmountBuilder toBuilder() =>
      CaptainPeakBonusDtoOutputActiveInnerAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPeakBonusDtoOutputActiveInnerAmount &&
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
            r'CaptainPeakBonusDtoOutputActiveInnerAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainPeakBonusDtoOutputActiveInnerAmountBuilder
    implements
        Builder<
          CaptainPeakBonusDtoOutputActiveInnerAmount,
          CaptainPeakBonusDtoOutputActiveInnerAmountBuilder
        > {
  _$CaptainPeakBonusDtoOutputActiveInnerAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainPeakBonusDtoOutputActiveInnerAmountBuilder() {
    CaptainPeakBonusDtoOutputActiveInnerAmount._defaults(this);
  }

  CaptainPeakBonusDtoOutputActiveInnerAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPeakBonusDtoOutputActiveInnerAmount other) {
    _$v = other as _$CaptainPeakBonusDtoOutputActiveInnerAmount;
  }

  @override
  void update(
    void Function(CaptainPeakBonusDtoOutputActiveInnerAmountBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPeakBonusDtoOutputActiveInnerAmount build() => _build();

  _$CaptainPeakBonusDtoOutputActiveInnerAmount _build() {
    final _$result =
        _$v ??
        _$CaptainPeakBonusDtoOutputActiveInnerAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainPeakBonusDtoOutputActiveInnerAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainPeakBonusDtoOutputActiveInnerAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
