// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner_earnings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutputCaptainsInnerEarnings
    extends AdminCaptainListDtoOutputCaptainsInnerEarnings {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainListDtoOutputCaptainsInnerEarnings([
    void Function(AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder)?
    updates,
  ]) =>
      (AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder()..update(updates))
          ._build();

  _$AdminCaptainListDtoOutputCaptainsInnerEarnings._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInnerEarnings rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInnerEarnings &&
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
            r'AdminCaptainListDtoOutputCaptainsInnerEarnings',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInnerEarnings,
          AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInnerEarnings? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder() {
    AdminCaptainListDtoOutputCaptainsInnerEarnings._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInnerEarnings other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInnerEarnings;
  }

  @override
  void update(
    void Function(AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerEarnings build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInnerEarnings _build() {
    final _$result =
        _$v ??
        _$AdminCaptainListDtoOutputCaptainsInnerEarnings._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainListDtoOutputCaptainsInnerEarnings',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainListDtoOutputCaptainsInnerEarnings',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
