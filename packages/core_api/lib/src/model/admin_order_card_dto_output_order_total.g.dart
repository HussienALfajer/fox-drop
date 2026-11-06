// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output_order_total.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCardDtoOutputOrderTotal
    extends AdminOrderCardDtoOutputOrderTotal {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminOrderCardDtoOutputOrderTotal([
    void Function(AdminOrderCardDtoOutputOrderTotalBuilder)? updates,
  ]) => (AdminOrderCardDtoOutputOrderTotalBuilder()..update(updates))._build();

  _$AdminOrderCardDtoOutputOrderTotal._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminOrderCardDtoOutputOrderTotal rebuild(
    void Function(AdminOrderCardDtoOutputOrderTotalBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputOrderTotalBuilder toBuilder() =>
      AdminOrderCardDtoOutputOrderTotalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutputOrderTotal &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderCardDtoOutputOrderTotal')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminOrderCardDtoOutputOrderTotalBuilder
    implements
        Builder<
          AdminOrderCardDtoOutputOrderTotal,
          AdminOrderCardDtoOutputOrderTotalBuilder
        > {
  _$AdminOrderCardDtoOutputOrderTotal? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOrderCardDtoOutputOrderTotalBuilder() {
    AdminOrderCardDtoOutputOrderTotal._defaults(this);
  }

  AdminOrderCardDtoOutputOrderTotalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutputOrderTotal other) {
    _$v = other as _$AdminOrderCardDtoOutputOrderTotal;
  }

  @override
  void update(
    void Function(AdminOrderCardDtoOutputOrderTotalBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutputOrderTotal build() => _build();

  _$AdminOrderCardDtoOutputOrderTotal _build() {
    final _$result =
        _$v ??
        _$AdminOrderCardDtoOutputOrderTotal._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOrderCardDtoOutputOrderTotal',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOrderCardDtoOutputOrderTotal',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
