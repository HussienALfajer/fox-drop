// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_suggested_cash_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit
    extends AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit([
    void Function(
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder,
    )?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit rebuild(
    void Function(
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
  toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit &&
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
            r'AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit,
          AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder() {
    AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit._defaults(
      this,
    );
  }

  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit other,
  ) {
    _$v =
        other as _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit;
  }

  @override
  void update(
    void Function(
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit build() =>
      _build();

  _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
