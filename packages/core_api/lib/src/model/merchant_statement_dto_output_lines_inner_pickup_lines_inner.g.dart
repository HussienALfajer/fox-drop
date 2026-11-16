// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_statement_dto_output_lines_inner_pickup_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantStatementDtoOutputLinesInnerPickupLinesInner
    extends MerchantStatementDtoOutputLinesInnerPickupLinesInner {
  @override
  final String currency;
  @override
  final String amount;

  factory _$MerchantStatementDtoOutputLinesInnerPickupLinesInner([
    void Function(MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder)?
    updates,
  ]) =>
      (MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantStatementDtoOutputLinesInnerPickupLinesInner._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  MerchantStatementDtoOutputLinesInnerPickupLinesInner rebuild(
    void Function(MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder toBuilder() =>
      MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatementDtoOutputLinesInnerPickupLinesInner &&
        currency == other.currency &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantStatementDtoOutputLinesInnerPickupLinesInner',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder
    implements
        Builder<
          MerchantStatementDtoOutputLinesInnerPickupLinesInner,
          MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder
        > {
  _$MerchantStatementDtoOutputLinesInnerPickupLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder() {
    MerchantStatementDtoOutputLinesInnerPickupLinesInner._defaults(this);
  }

  MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatementDtoOutputLinesInnerPickupLinesInner other) {
    _$v = other as _$MerchantStatementDtoOutputLinesInnerPickupLinesInner;
  }

  @override
  void update(
    void Function(MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatementDtoOutputLinesInnerPickupLinesInner build() => _build();

  _$MerchantStatementDtoOutputLinesInnerPickupLinesInner _build() {
    final _$result =
        _$v ??
        _$MerchantStatementDtoOutputLinesInnerPickupLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantStatementDtoOutputLinesInnerPickupLinesInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantStatementDtoOutputLinesInnerPickupLinesInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
