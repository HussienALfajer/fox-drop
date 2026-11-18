// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_operations_dto_minimum_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftOperationsDtoMinimumOrder
    extends AdminDraftOperationsDtoMinimumOrder {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDraftOperationsDtoMinimumOrder([
    void Function(AdminDraftOperationsDtoMinimumOrderBuilder)? updates,
  ]) =>
      (AdminDraftOperationsDtoMinimumOrderBuilder()..update(updates))._build();

  _$AdminDraftOperationsDtoMinimumOrder._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminDraftOperationsDtoMinimumOrder rebuild(
    void Function(AdminDraftOperationsDtoMinimumOrderBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftOperationsDtoMinimumOrderBuilder toBuilder() =>
      AdminDraftOperationsDtoMinimumOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftOperationsDtoMinimumOrder &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftOperationsDtoMinimumOrder')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDraftOperationsDtoMinimumOrderBuilder
    implements
        Builder<
          AdminDraftOperationsDtoMinimumOrder,
          AdminDraftOperationsDtoMinimumOrderBuilder
        > {
  _$AdminDraftOperationsDtoMinimumOrder? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDraftOperationsDtoMinimumOrderBuilder() {
    AdminDraftOperationsDtoMinimumOrder._defaults(this);
  }

  AdminDraftOperationsDtoMinimumOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftOperationsDtoMinimumOrder other) {
    _$v = other as _$AdminDraftOperationsDtoMinimumOrder;
  }

  @override
  void update(
    void Function(AdminDraftOperationsDtoMinimumOrderBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftOperationsDtoMinimumOrder build() => _build();

  _$AdminDraftOperationsDtoMinimumOrder _build() {
    final _$result =
        _$v ??
        _$AdminDraftOperationsDtoMinimumOrder._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDraftOperationsDtoMinimumOrder',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDraftOperationsDtoMinimumOrder',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
