// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settle_dto_payout_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettleDtoPayoutRatesInner extends AdminSettleDtoPayoutRatesInner {
  @override
  final String currency;
  @override
  final String rateVersionId;

  factory _$AdminSettleDtoPayoutRatesInner([
    void Function(AdminSettleDtoPayoutRatesInnerBuilder)? updates,
  ]) => (AdminSettleDtoPayoutRatesInnerBuilder()..update(updates))._build();

  _$AdminSettleDtoPayoutRatesInner._({
    required this.currency,
    required this.rateVersionId,
  }) : super._();
  @override
  AdminSettleDtoPayoutRatesInner rebuild(
    void Function(AdminSettleDtoPayoutRatesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettleDtoPayoutRatesInnerBuilder toBuilder() =>
      AdminSettleDtoPayoutRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettleDtoPayoutRatesInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSettleDtoPayoutRatesInner')
          ..add('currency', currency)
          ..add('rateVersionId', rateVersionId))
        .toString();
  }
}

class AdminSettleDtoPayoutRatesInnerBuilder
    implements
        Builder<
          AdminSettleDtoPayoutRatesInner,
          AdminSettleDtoPayoutRatesInnerBuilder
        > {
  _$AdminSettleDtoPayoutRatesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _rateVersionId;
  String? get rateVersionId => _$this._rateVersionId;
  set rateVersionId(String? rateVersionId) =>
      _$this._rateVersionId = rateVersionId;

  AdminSettleDtoPayoutRatesInnerBuilder() {
    AdminSettleDtoPayoutRatesInner._defaults(this);
  }

  AdminSettleDtoPayoutRatesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _rateVersionId = $v.rateVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettleDtoPayoutRatesInner other) {
    _$v = other as _$AdminSettleDtoPayoutRatesInner;
  }

  @override
  void update(void Function(AdminSettleDtoPayoutRatesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettleDtoPayoutRatesInner build() => _build();

  _$AdminSettleDtoPayoutRatesInner _build() {
    final _$result =
        _$v ??
        _$AdminSettleDtoPayoutRatesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettleDtoPayoutRatesInner',
            'currency',
          ),
          rateVersionId: BuiltValueNullFieldError.checkNotNull(
            rateVersionId,
            r'AdminSettleDtoPayoutRatesInner',
            'rateVersionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
