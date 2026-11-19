// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner_custody_usage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage
    extends AdminCaptainListDtoOutputCaptainsInnerCustodyUsage {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage([
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder)?
    updates,
  ]) =>
      (AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyUsage rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInnerCustodyUsage &&
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
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyUsage',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInnerCustodyUsage,
          AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder() {
    AdminCaptainListDtoOutputCaptainsInnerCustodyUsage._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInnerCustodyUsage other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage;
  }

  @override
  void update(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyUsage build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage _build() {
    final _$result =
        _$v ??
        _$AdminCaptainListDtoOutputCaptainsInnerCustodyUsage._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyUsage',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyUsage',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
