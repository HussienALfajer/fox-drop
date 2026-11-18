// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_choices_dto_output_default_minimum_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder
    extends AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder([
    void Function(
      AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder,
    )?
    updates,
  ]) =>
      (AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder rebuild(
    void Function(
      AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder toBuilder() =>
      AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder &&
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
            r'AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder
    implements
        Builder<
          AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder,
          AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder
        > {
  _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder() {
    AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder._defaults(this);
  }

  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder other) {
    _$v = other as _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder;
  }

  @override
  void update(
    void Function(
      AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder build() => _build();

  _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
