// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner_custody_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit
    extends AdminCaptainListDtoOutputCaptainsInnerCustodyLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit([
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder)?
    updates,
  ]) =>
      (AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyLimit rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInnerCustodyLimit &&
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
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyLimit',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInnerCustodyLimit,
          AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder() {
    AdminCaptainListDtoOutputCaptainsInnerCustodyLimit._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInnerCustodyLimit other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit;
  }

  @override
  void update(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyLimit build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit _build() {
    final _$result =
        _$v ??
        _$AdminCaptainListDtoOutputCaptainsInnerCustodyLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
