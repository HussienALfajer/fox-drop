// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_receipts_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputReceiptsInnerLinesInner
    extends CaptainCustodyDtoOutputReceiptsInnerLinesInner {
  @override
  final String currency;
  @override
  final String amount;

  factory _$CaptainCustodyDtoOutputReceiptsInnerLinesInner([
    void Function(CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ]) =>
      (CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder()..update(updates))
          ._build();

  _$CaptainCustodyDtoOutputReceiptsInnerLinesInner._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  CaptainCustodyDtoOutputReceiptsInnerLinesInner rebuild(
    void Function(CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder toBuilder() =>
      CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputReceiptsInnerLinesInner &&
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
            r'CaptainCustodyDtoOutputReceiptsInnerLinesInner',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputReceiptsInnerLinesInner,
          CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder
        > {
  _$CaptainCustodyDtoOutputReceiptsInnerLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder() {
    CaptainCustodyDtoOutputReceiptsInnerLinesInner._defaults(this);
  }

  CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputReceiptsInnerLinesInner other) {
    _$v = other as _$CaptainCustodyDtoOutputReceiptsInnerLinesInner;
  }

  @override
  void update(
    void Function(CaptainCustodyDtoOutputReceiptsInnerLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputReceiptsInnerLinesInner build() => _build();

  _$CaptainCustodyDtoOutputReceiptsInnerLinesInner _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputReceiptsInnerLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCustodyDtoOutputReceiptsInnerLinesInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputReceiptsInnerLinesInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
