// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_orders_spent_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputOrdersSpentInner
    extends AdminCustomerDtoOutputOrdersSpentInner {
  @override
  final String currency;
  @override
  final String amount;

  factory _$AdminCustomerDtoOutputOrdersSpentInner([
    void Function(AdminCustomerDtoOutputOrdersSpentInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputOrdersSpentInnerBuilder()..update(updates))
      ._build();

  _$AdminCustomerDtoOutputOrdersSpentInner._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  AdminCustomerDtoOutputOrdersSpentInner rebuild(
    void Function(AdminCustomerDtoOutputOrdersSpentInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputOrdersSpentInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputOrdersSpentInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputOrdersSpentInner &&
        currency == other.currency &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCustomerDtoOutputOrdersSpentInner',
          )
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class AdminCustomerDtoOutputOrdersSpentInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputOrdersSpentInner,
          AdminCustomerDtoOutputOrdersSpentInnerBuilder
        > {
  _$AdminCustomerDtoOutputOrdersSpentInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminCustomerDtoOutputOrdersSpentInnerBuilder() {
    AdminCustomerDtoOutputOrdersSpentInner._defaults(this);
  }

  AdminCustomerDtoOutputOrdersSpentInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputOrdersSpentInner other) {
    _$v = other as _$AdminCustomerDtoOutputOrdersSpentInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputOrdersSpentInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputOrdersSpentInner build() => _build();

  _$AdminCustomerDtoOutputOrdersSpentInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputOrdersSpentInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCustomerDtoOutputOrdersSpentInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCustomerDtoOutputOrdersSpentInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
