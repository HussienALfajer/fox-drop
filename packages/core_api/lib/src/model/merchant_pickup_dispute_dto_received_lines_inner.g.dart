// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pickup_dispute_dto_received_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPickupDisputeDtoReceivedLinesInner
    extends MerchantPickupDisputeDtoReceivedLinesInner {
  @override
  final String amount;
  @override
  final String currency;

  factory _$MerchantPickupDisputeDtoReceivedLinesInner([
    void Function(MerchantPickupDisputeDtoReceivedLinesInnerBuilder)? updates,
  ]) => (MerchantPickupDisputeDtoReceivedLinesInnerBuilder()..update(updates))
      ._build();

  _$MerchantPickupDisputeDtoReceivedLinesInner._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  MerchantPickupDisputeDtoReceivedLinesInner rebuild(
    void Function(MerchantPickupDisputeDtoReceivedLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPickupDisputeDtoReceivedLinesInnerBuilder toBuilder() =>
      MerchantPickupDisputeDtoReceivedLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPickupDisputeDtoReceivedLinesInner &&
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
            r'MerchantPickupDisputeDtoReceivedLinesInner',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantPickupDisputeDtoReceivedLinesInnerBuilder
    implements
        Builder<
          MerchantPickupDisputeDtoReceivedLinesInner,
          MerchantPickupDisputeDtoReceivedLinesInnerBuilder
        > {
  _$MerchantPickupDisputeDtoReceivedLinesInner? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantPickupDisputeDtoReceivedLinesInnerBuilder() {
    MerchantPickupDisputeDtoReceivedLinesInner._defaults(this);
  }

  MerchantPickupDisputeDtoReceivedLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPickupDisputeDtoReceivedLinesInner other) {
    _$v = other as _$MerchantPickupDisputeDtoReceivedLinesInner;
  }

  @override
  void update(
    void Function(MerchantPickupDisputeDtoReceivedLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPickupDisputeDtoReceivedLinesInner build() => _build();

  _$MerchantPickupDisputeDtoReceivedLinesInner _build() {
    final _$result =
        _$v ??
        _$MerchantPickupDisputeDtoReceivedLinesInner._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantPickupDisputeDtoReceivedLinesInner',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantPickupDisputeDtoReceivedLinesInner',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
