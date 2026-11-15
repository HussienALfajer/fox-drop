// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_dto_output_payout_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementPreviewDtoOutputPayoutRatesInner
    extends AdminSettlementPreviewDtoOutputPayoutRatesInner {
  @override
  final String currency;
  @override
  final String rateVersionId;

  factory _$AdminSettlementPreviewDtoOutputPayoutRatesInner([
    void Function(AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder)?
    updates,
  ]) =>
      (AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminSettlementPreviewDtoOutputPayoutRatesInner._({
    required this.currency,
    required this.rateVersionId,
  }) : super._();
  @override
  AdminSettlementPreviewDtoOutputPayoutRatesInner rebuild(
    void Function(AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder toBuilder() =>
      AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewDtoOutputPayoutRatesInner &&
        currency == other.currency &&
        rateVersionId == other.rateVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, rateVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSettlementPreviewDtoOutputPayoutRatesInner',
          )
          ..add('currency', currency)
          ..add('rateVersionId', rateVersionId))
        .toString();
  }
}

class AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder
    implements
        Builder<
          AdminSettlementPreviewDtoOutputPayoutRatesInner,
          AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder
        > {
  _$AdminSettlementPreviewDtoOutputPayoutRatesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _rateVersionId;
  String? get rateVersionId => _$this._rateVersionId;
  set rateVersionId(String? rateVersionId) =>
      _$this._rateVersionId = rateVersionId;

  AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder() {
    AdminSettlementPreviewDtoOutputPayoutRatesInner._defaults(this);
  }

  AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _rateVersionId = $v.rateVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewDtoOutputPayoutRatesInner other) {
    _$v = other as _$AdminSettlementPreviewDtoOutputPayoutRatesInner;
  }

  @override
  void update(
    void Function(AdminSettlementPreviewDtoOutputPayoutRatesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewDtoOutputPayoutRatesInner build() => _build();

  _$AdminSettlementPreviewDtoOutputPayoutRatesInner _build() {
    final _$result =
        _$v ??
        _$AdminSettlementPreviewDtoOutputPayoutRatesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettlementPreviewDtoOutputPayoutRatesInner',
            'currency',
          ),
          rateVersionId: BuiltValueNullFieldError.checkNotNull(
            rateVersionId,
            r'AdminSettlementPreviewDtoOutputPayoutRatesInner',
            'rateVersionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
