// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_operations_minimum_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder
    extends AdminRestaurantDraftDtoOutputOperationsMinimumOrder {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder([
    void Function(AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputOperationsMinimumOrder rebuild(
    void Function(AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputOperationsMinimumOrder &&
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
            r'AdminRestaurantDraftDtoOutputOperationsMinimumOrder',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputOperationsMinimumOrder,
          AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder
        > {
  _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder() {
    AdminRestaurantDraftDtoOutputOperationsMinimumOrder._defaults(this);
  }

  AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputOperationsMinimumOrder other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputOperationsMinimumOrderBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsMinimumOrder build() => _build();

  _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftDtoOutputOperationsMinimumOrder._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRestaurantDraftDtoOutputOperationsMinimumOrder',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRestaurantDraftDtoOutputOperationsMinimumOrder',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
