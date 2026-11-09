// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_delivery_summary_dto_output_summary_custody_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange
    extends CaptainDeliverySummaryDtoOutputSummaryCustodyChange {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange([
    void Function(CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder)?
    updates,
  ]) =>
      (CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder()
            ..update(updates))
          ._build();

  _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainDeliverySummaryDtoOutputSummaryCustodyChange rebuild(
    void Function(CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder toBuilder() =>
      CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverySummaryDtoOutputSummaryCustodyChange &&
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
            r'CaptainDeliverySummaryDtoOutputSummaryCustodyChange',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder
    implements
        Builder<
          CaptainDeliverySummaryDtoOutputSummaryCustodyChange,
          CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder
        > {
  _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder() {
    CaptainDeliverySummaryDtoOutputSummaryCustodyChange._defaults(this);
  }

  CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverySummaryDtoOutputSummaryCustodyChange other) {
    _$v = other as _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange;
  }

  @override
  void update(
    void Function(CaptainDeliverySummaryDtoOutputSummaryCustodyChangeBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverySummaryDtoOutputSummaryCustodyChange build() => _build();

  _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange _build() {
    final _$result =
        _$v ??
        _$CaptainDeliverySummaryDtoOutputSummaryCustodyChange._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainDeliverySummaryDtoOutputSummaryCustodyChange',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainDeliverySummaryDtoOutputSummaryCustodyChange',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
