// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_receipt_dto_output_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantReceiptDtoOutputLinesInner
    extends AdminRestaurantReceiptDtoOutputLinesInner {
  @override
  final String currency;
  @override
  final String amount;
  @override
  final String base_;

  factory _$AdminRestaurantReceiptDtoOutputLinesInner([
    void Function(AdminRestaurantReceiptDtoOutputLinesInnerBuilder)? updates,
  ]) => (AdminRestaurantReceiptDtoOutputLinesInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantReceiptDtoOutputLinesInner._({
    required this.currency,
    required this.amount,
    required this.base_,
  }) : super._();
  @override
  AdminRestaurantReceiptDtoOutputLinesInner rebuild(
    void Function(AdminRestaurantReceiptDtoOutputLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantReceiptDtoOutputLinesInnerBuilder toBuilder() =>
      AdminRestaurantReceiptDtoOutputLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantReceiptDtoOutputLinesInner &&
        currency == other.currency &&
        amount == other.amount &&
        base_ == other.base_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, base_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantReceiptDtoOutputLinesInner',
          )
          ..add('currency', currency)
          ..add('amount', amount)
          ..add('base_', base_))
        .toString();
  }
}

class AdminRestaurantReceiptDtoOutputLinesInnerBuilder
    implements
        Builder<
          AdminRestaurantReceiptDtoOutputLinesInner,
          AdminRestaurantReceiptDtoOutputLinesInnerBuilder
        > {
  _$AdminRestaurantReceiptDtoOutputLinesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _base_;
  String? get base_ => _$this._base_;
  set base_(String? base_) => _$this._base_ = base_;

  AdminRestaurantReceiptDtoOutputLinesInnerBuilder() {
    AdminRestaurantReceiptDtoOutputLinesInner._defaults(this);
  }

  AdminRestaurantReceiptDtoOutputLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _base_ = $v.base_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantReceiptDtoOutputLinesInner other) {
    _$v = other as _$AdminRestaurantReceiptDtoOutputLinesInner;
  }

  @override
  void update(
    void Function(AdminRestaurantReceiptDtoOutputLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantReceiptDtoOutputLinesInner build() => _build();

  _$AdminRestaurantReceiptDtoOutputLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantReceiptDtoOutputLinesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRestaurantReceiptDtoOutputLinesInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRestaurantReceiptDtoOutputLinesInner',
            'amount',
          ),
          base_: BuiltValueNullFieldError.checkNotNull(
            base_,
            r'AdminRestaurantReceiptDtoOutputLinesInner',
            'base_',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
