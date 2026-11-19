// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_table_preview_dto_output_in_force_base.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayTablePreviewDtoOutputInForceBase
    extends AdminPayTablePreviewDtoOutputInForceBase {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminPayTablePreviewDtoOutputInForceBase([
    void Function(AdminPayTablePreviewDtoOutputInForceBaseBuilder)? updates,
  ]) => (AdminPayTablePreviewDtoOutputInForceBaseBuilder()..update(updates))
      ._build();

  _$AdminPayTablePreviewDtoOutputInForceBase._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminPayTablePreviewDtoOutputInForceBase rebuild(
    void Function(AdminPayTablePreviewDtoOutputInForceBaseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablePreviewDtoOutputInForceBaseBuilder toBuilder() =>
      AdminPayTablePreviewDtoOutputInForceBaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablePreviewDtoOutputInForceBase &&
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
            r'AdminPayTablePreviewDtoOutputInForceBase',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminPayTablePreviewDtoOutputInForceBaseBuilder
    implements
        Builder<
          AdminPayTablePreviewDtoOutputInForceBase,
          AdminPayTablePreviewDtoOutputInForceBaseBuilder
        > {
  _$AdminPayTablePreviewDtoOutputInForceBase? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminPayTablePreviewDtoOutputInForceBaseBuilder() {
    AdminPayTablePreviewDtoOutputInForceBase._defaults(this);
  }

  AdminPayTablePreviewDtoOutputInForceBaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayTablePreviewDtoOutputInForceBase other) {
    _$v = other as _$AdminPayTablePreviewDtoOutputInForceBase;
  }

  @override
  void update(
    void Function(AdminPayTablePreviewDtoOutputInForceBaseBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablePreviewDtoOutputInForceBase build() => _build();

  _$AdminPayTablePreviewDtoOutputInForceBase _build() {
    final _$result =
        _$v ??
        _$AdminPayTablePreviewDtoOutputInForceBase._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminPayTablePreviewDtoOutputInForceBase',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminPayTablePreviewDtoOutputInForceBase',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
