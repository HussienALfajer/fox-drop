// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_dues.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputDues extends AdminCustomerDtoOutputDues {
  @override
  final String amount;
  @override
  final String? currency;

  factory _$AdminCustomerDtoOutputDues([
    void Function(AdminCustomerDtoOutputDuesBuilder)? updates,
  ]) => (AdminCustomerDtoOutputDuesBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputDues._({required this.amount, this.currency})
    : super._();
  @override
  AdminCustomerDtoOutputDues rebuild(
    void Function(AdminCustomerDtoOutputDuesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputDuesBuilder toBuilder() =>
      AdminCustomerDtoOutputDuesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputDues &&
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
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputDues')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCustomerDtoOutputDuesBuilder
    implements
        Builder<AdminCustomerDtoOutputDues, AdminCustomerDtoOutputDuesBuilder> {
  _$AdminCustomerDtoOutputDues? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCustomerDtoOutputDuesBuilder() {
    AdminCustomerDtoOutputDues._defaults(this);
  }

  AdminCustomerDtoOutputDuesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputDues other) {
    _$v = other as _$AdminCustomerDtoOutputDues;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputDuesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputDues build() => _build();

  _$AdminCustomerDtoOutputDues _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputDues._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCustomerDtoOutputDues',
            'amount',
          ),
          currency: currency,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
