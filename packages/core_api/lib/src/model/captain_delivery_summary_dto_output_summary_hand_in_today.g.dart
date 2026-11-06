// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_delivery_summary_dto_output_summary_hand_in_today.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDeliverySummaryDtoOutputSummaryHandInToday
    extends CaptainDeliverySummaryDtoOutputSummaryHandInToday {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainDeliverySummaryDtoOutputSummaryHandInToday([
    void Function(CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder)?
    updates,
  ]) =>
      (CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder()
            ..update(updates))
          ._build();

  _$CaptainDeliverySummaryDtoOutputSummaryHandInToday._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainDeliverySummaryDtoOutputSummaryHandInToday rebuild(
    void Function(CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder toBuilder() =>
      CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverySummaryDtoOutputSummaryHandInToday &&
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
            r'CaptainDeliverySummaryDtoOutputSummaryHandInToday',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder
    implements
        Builder<
          CaptainDeliverySummaryDtoOutputSummaryHandInToday,
          CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder
        > {
  _$CaptainDeliverySummaryDtoOutputSummaryHandInToday? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder() {
    CaptainDeliverySummaryDtoOutputSummaryHandInToday._defaults(this);
  }

  CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverySummaryDtoOutputSummaryHandInToday other) {
    _$v = other as _$CaptainDeliverySummaryDtoOutputSummaryHandInToday;
  }

  @override
  void update(
    void Function(CaptainDeliverySummaryDtoOutputSummaryHandInTodayBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverySummaryDtoOutputSummaryHandInToday build() => _build();

  _$CaptainDeliverySummaryDtoOutputSummaryHandInToday _build() {
    final _$result =
        _$v ??
        _$CaptainDeliverySummaryDtoOutputSummaryHandInToday._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainDeliverySummaryDtoOutputSummaryHandInToday',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainDeliverySummaryDtoOutputSummaryHandInToday',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
