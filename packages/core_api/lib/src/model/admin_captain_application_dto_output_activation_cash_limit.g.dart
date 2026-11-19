// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_cash_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivationCashLimit
    extends AdminCaptainApplicationDtoOutputActivationCashLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainApplicationDtoOutputActivationCashLimit([
    void Function(AdminCaptainApplicationDtoOutputActivationCashLimitBuilder)?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationCashLimitBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationCashLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationCashLimit rebuild(
    void Function(AdminCaptainApplicationDtoOutputActivationCashLimitBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationCashLimitBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivationCashLimit &&
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
            r'AdminCaptainApplicationDtoOutputActivationCashLimit',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationCashLimitBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationCashLimit,
          AdminCaptainApplicationDtoOutputActivationCashLimitBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationCashLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder() {
    AdminCaptainApplicationDtoOutputActivationCashLimit._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputActivationCashLimit other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivationCashLimit;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputActivationCashLimitBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationCashLimit build() => _build();

  _$AdminCaptainApplicationDtoOutputActivationCashLimit _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputActivationCashLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainApplicationDtoOutputActivationCashLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainApplicationDtoOutputActivationCashLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
