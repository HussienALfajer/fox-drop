// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account_state_dto_output_dues.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerAccountStateDtoOutputDues
    extends CustomerAccountStateDtoOutputDues {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CustomerAccountStateDtoOutputDues([
    void Function(CustomerAccountStateDtoOutputDuesBuilder)? updates,
  ]) => (CustomerAccountStateDtoOutputDuesBuilder()..update(updates))._build();

  _$CustomerAccountStateDtoOutputDues._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CustomerAccountStateDtoOutputDues rebuild(
    void Function(CustomerAccountStateDtoOutputDuesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAccountStateDtoOutputDuesBuilder toBuilder() =>
      CustomerAccountStateDtoOutputDuesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAccountStateDtoOutputDues &&
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
    return (newBuiltValueToStringHelper(r'CustomerAccountStateDtoOutputDues')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CustomerAccountStateDtoOutputDuesBuilder
    implements
        Builder<
          CustomerAccountStateDtoOutputDues,
          CustomerAccountStateDtoOutputDuesBuilder
        > {
  _$CustomerAccountStateDtoOutputDues? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerAccountStateDtoOutputDuesBuilder() {
    CustomerAccountStateDtoOutputDues._defaults(this);
  }

  CustomerAccountStateDtoOutputDuesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAccountStateDtoOutputDues other) {
    _$v = other as _$CustomerAccountStateDtoOutputDues;
  }

  @override
  void update(
    void Function(CustomerAccountStateDtoOutputDuesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAccountStateDtoOutputDues build() => _build();

  _$CustomerAccountStateDtoOutputDues _build() {
    final _$result =
        _$v ??
        _$CustomerAccountStateDtoOutputDues._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CustomerAccountStateDtoOutputDues',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CustomerAccountStateDtoOutputDues',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
