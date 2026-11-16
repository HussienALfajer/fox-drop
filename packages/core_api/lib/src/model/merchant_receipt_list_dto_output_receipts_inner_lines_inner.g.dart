// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_receipt_list_dto_output_receipts_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner
    extends MerchantReceiptListDtoOutputReceiptsInnerLinesInner {
  @override
  final String currency;
  @override
  final String amount;
  @override
  final String base_;

  factory _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner([
    void Function(MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ]) =>
      (MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner._({
    required this.currency,
    required this.amount,
    required this.base_,
  }) : super._();
  @override
  MerchantReceiptListDtoOutputReceiptsInnerLinesInner rebuild(
    void Function(MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder toBuilder() =>
      MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReceiptListDtoOutputReceiptsInnerLinesInner &&
        currency == other.currency &&
        amount == other.amount &&
        base_ == other.base_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantReceiptListDtoOutputReceiptsInnerLinesInner',
          )
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('base_', base_))
        .toString();
  }
}

class MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder
    implements
        Builder<
          MerchantReceiptListDtoOutputReceiptsInnerLinesInner,
          MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder
        > {
  _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _base_;
  String? get base_ => _$this._base_;
  set base_(String? base_) => _$this._base_ = base_;

  MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder() {
    MerchantReceiptListDtoOutputReceiptsInnerLinesInner._defaults(this);
  }

  MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _base_ = $v.base_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReceiptListDtoOutputReceiptsInnerLinesInner other) {
    _$v = other as _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner;
  }

  @override
  void update(
    void Function(MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReceiptListDtoOutputReceiptsInnerLinesInner build() => _build();

  _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner _build() {
    final _$result =
        _$v ??
        _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantReceiptListDtoOutputReceiptsInnerLinesInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantReceiptListDtoOutputReceiptsInnerLinesInner',
            'amount',
          ),
          base_: BuiltValueNullFieldError.checkNotNull(
            base_,
            r'MerchantReceiptListDtoOutputReceiptsInnerLinesInner',
            'base_',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
