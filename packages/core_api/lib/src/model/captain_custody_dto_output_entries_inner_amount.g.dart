// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_entries_inner_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputEntriesInnerAmount
    extends CaptainCustodyDtoOutputEntriesInnerAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCustodyDtoOutputEntriesInnerAmount([
    void Function(CaptainCustodyDtoOutputEntriesInnerAmountBuilder)? updates,
  ]) => (CaptainCustodyDtoOutputEntriesInnerAmountBuilder()..update(updates))
      ._build();

  _$CaptainCustodyDtoOutputEntriesInnerAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCustodyDtoOutputEntriesInnerAmount rebuild(
    void Function(CaptainCustodyDtoOutputEntriesInnerAmountBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputEntriesInnerAmountBuilder toBuilder() =>
      CaptainCustodyDtoOutputEntriesInnerAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputEntriesInnerAmount &&
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
            r'CaptainCustodyDtoOutputEntriesInnerAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCustodyDtoOutputEntriesInnerAmountBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputEntriesInnerAmount,
          CaptainCustodyDtoOutputEntriesInnerAmountBuilder
        > {
  _$CaptainCustodyDtoOutputEntriesInnerAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCustodyDtoOutputEntriesInnerAmountBuilder() {
    CaptainCustodyDtoOutputEntriesInnerAmount._defaults(this);
  }

  CaptainCustodyDtoOutputEntriesInnerAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputEntriesInnerAmount other) {
    _$v = other as _$CaptainCustodyDtoOutputEntriesInnerAmount;
  }

  @override
  void update(
    void Function(CaptainCustodyDtoOutputEntriesInnerAmountBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputEntriesInnerAmount build() => _build();

  _$CaptainCustodyDtoOutputEntriesInnerAmount _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputEntriesInnerAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputEntriesInnerAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCustodyDtoOutputEntriesInnerAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
