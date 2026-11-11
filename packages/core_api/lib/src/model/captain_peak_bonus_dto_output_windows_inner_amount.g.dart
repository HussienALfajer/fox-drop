// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_peak_bonus_dto_output_windows_inner_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPeakBonusDtoOutputWindowsInnerAmount
    extends CaptainPeakBonusDtoOutputWindowsInnerAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainPeakBonusDtoOutputWindowsInnerAmount([
    void Function(CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder)? updates,
  ]) => (CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder()..update(updates))
      ._build();

  _$CaptainPeakBonusDtoOutputWindowsInnerAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainPeakBonusDtoOutputWindowsInnerAmount rebuild(
    void Function(CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder toBuilder() =>
      CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPeakBonusDtoOutputWindowsInnerAmount &&
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
            r'CaptainPeakBonusDtoOutputWindowsInnerAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder
    implements
        Builder<
          CaptainPeakBonusDtoOutputWindowsInnerAmount,
          CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder
        > {
  _$CaptainPeakBonusDtoOutputWindowsInnerAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder() {
    CaptainPeakBonusDtoOutputWindowsInnerAmount._defaults(this);
  }

  CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPeakBonusDtoOutputWindowsInnerAmount other) {
    _$v = other as _$CaptainPeakBonusDtoOutputWindowsInnerAmount;
  }

  @override
  void update(
    void Function(CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPeakBonusDtoOutputWindowsInnerAmount build() => _build();

  _$CaptainPeakBonusDtoOutputWindowsInnerAmount _build() {
    final _$result =
        _$v ??
        _$CaptainPeakBonusDtoOutputWindowsInnerAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainPeakBonusDtoOutputWindowsInnerAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainPeakBonusDtoOutputWindowsInnerAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
