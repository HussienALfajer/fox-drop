// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_dto_output_earnings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementPreviewDtoOutputEarnings
    extends AdminSettlementPreviewDtoOutputEarnings {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminSettlementPreviewDtoOutputEarnings([
    void Function(AdminSettlementPreviewDtoOutputEarningsBuilder)? updates,
  ]) => (AdminSettlementPreviewDtoOutputEarningsBuilder()..update(updates))
      ._build();

  _$AdminSettlementPreviewDtoOutputEarnings._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminSettlementPreviewDtoOutputEarnings rebuild(
    void Function(AdminSettlementPreviewDtoOutputEarningsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewDtoOutputEarningsBuilder toBuilder() =>
      AdminSettlementPreviewDtoOutputEarningsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewDtoOutputEarnings &&
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
            r'AdminSettlementPreviewDtoOutputEarnings',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminSettlementPreviewDtoOutputEarningsBuilder
    implements
        Builder<
          AdminSettlementPreviewDtoOutputEarnings,
          AdminSettlementPreviewDtoOutputEarningsBuilder
        > {
  _$AdminSettlementPreviewDtoOutputEarnings? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminSettlementPreviewDtoOutputEarningsBuilder() {
    AdminSettlementPreviewDtoOutputEarnings._defaults(this);
  }

  AdminSettlementPreviewDtoOutputEarningsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewDtoOutputEarnings other) {
    _$v = other as _$AdminSettlementPreviewDtoOutputEarnings;
  }

  @override
  void update(
    void Function(AdminSettlementPreviewDtoOutputEarningsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewDtoOutputEarnings build() => _build();

  _$AdminSettlementPreviewDtoOutputEarnings _build() {
    final _$result =
        _$v ??
        _$AdminSettlementPreviewDtoOutputEarnings._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminSettlementPreviewDtoOutputEarnings',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettlementPreviewDtoOutputEarnings',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
