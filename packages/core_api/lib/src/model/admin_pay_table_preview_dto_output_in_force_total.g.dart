// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_table_preview_dto_output_in_force_total.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayTablePreviewDtoOutputInForceTotal
    extends AdminPayTablePreviewDtoOutputInForceTotal {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminPayTablePreviewDtoOutputInForceTotal([
    void Function(AdminPayTablePreviewDtoOutputInForceTotalBuilder)? updates,
  ]) => (AdminPayTablePreviewDtoOutputInForceTotalBuilder()..update(updates))
      ._build();

  _$AdminPayTablePreviewDtoOutputInForceTotal._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminPayTablePreviewDtoOutputInForceTotal rebuild(
    void Function(AdminPayTablePreviewDtoOutputInForceTotalBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablePreviewDtoOutputInForceTotalBuilder toBuilder() =>
      AdminPayTablePreviewDtoOutputInForceTotalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablePreviewDtoOutputInForceTotal &&
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
            r'AdminPayTablePreviewDtoOutputInForceTotal',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminPayTablePreviewDtoOutputInForceTotalBuilder
    implements
        Builder<
          AdminPayTablePreviewDtoOutputInForceTotal,
          AdminPayTablePreviewDtoOutputInForceTotalBuilder
        > {
  _$AdminPayTablePreviewDtoOutputInForceTotal? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminPayTablePreviewDtoOutputInForceTotalBuilder() {
    AdminPayTablePreviewDtoOutputInForceTotal._defaults(this);
  }

  AdminPayTablePreviewDtoOutputInForceTotalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayTablePreviewDtoOutputInForceTotal other) {
    _$v = other as _$AdminPayTablePreviewDtoOutputInForceTotal;
  }

  @override
  void update(
    void Function(AdminPayTablePreviewDtoOutputInForceTotalBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablePreviewDtoOutputInForceTotal build() => _build();

  _$AdminPayTablePreviewDtoOutputInForceTotal _build() {
    final _$result =
        _$v ??
        _$AdminPayTablePreviewDtoOutputInForceTotal._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminPayTablePreviewDtoOutputInForceTotal',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminPayTablePreviewDtoOutputInForceTotal',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
