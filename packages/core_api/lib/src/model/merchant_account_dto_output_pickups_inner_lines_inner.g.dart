// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account_dto_output_pickups_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccountDtoOutputPickupsInnerLinesInner
    extends MerchantAccountDtoOutputPickupsInnerLinesInner {
  @override
  final String currency;
  @override
  final String amount;

  factory _$MerchantAccountDtoOutputPickupsInnerLinesInner([
    void Function(MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder)?
    updates,
  ]) =>
      (MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder()..update(updates))
          ._build();

  _$MerchantAccountDtoOutputPickupsInnerLinesInner._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  MerchantAccountDtoOutputPickupsInnerLinesInner rebuild(
    void Function(MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder toBuilder() =>
      MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccountDtoOutputPickupsInnerLinesInner &&
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
            r'MerchantAccountDtoOutputPickupsInnerLinesInner',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder
    implements
        Builder<
          MerchantAccountDtoOutputPickupsInnerLinesInner,
          MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder
        > {
  _$MerchantAccountDtoOutputPickupsInnerLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder() {
    MerchantAccountDtoOutputPickupsInnerLinesInner._defaults(this);
  }

  MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccountDtoOutputPickupsInnerLinesInner other) {
    _$v = other as _$MerchantAccountDtoOutputPickupsInnerLinesInner;
  }

  @override
  void update(
    void Function(MerchantAccountDtoOutputPickupsInnerLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccountDtoOutputPickupsInnerLinesInner build() => _build();

  _$MerchantAccountDtoOutputPickupsInnerLinesInner _build() {
    final _$result =
        _$v ??
        _$MerchantAccountDtoOutputPickupsInnerLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantAccountDtoOutputPickupsInnerLinesInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantAccountDtoOutputPickupsInnerLinesInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
