// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_board_dto_output_orders_inner_total.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBoardDtoOutputOrdersInnerTotal
    extends AdminBoardDtoOutputOrdersInnerTotal {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminBoardDtoOutputOrdersInnerTotal([
    void Function(AdminBoardDtoOutputOrdersInnerTotalBuilder)? updates,
  ]) =>
      (AdminBoardDtoOutputOrdersInnerTotalBuilder()..update(updates))._build();

  _$AdminBoardDtoOutputOrdersInnerTotal._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminBoardDtoOutputOrdersInnerTotal rebuild(
    void Function(AdminBoardDtoOutputOrdersInnerTotalBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBoardDtoOutputOrdersInnerTotalBuilder toBuilder() =>
      AdminBoardDtoOutputOrdersInnerTotalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBoardDtoOutputOrdersInnerTotal &&
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
    return (newBuiltValueToStringHelper(r'AdminBoardDtoOutputOrdersInnerTotal')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminBoardDtoOutputOrdersInnerTotalBuilder
    implements
        Builder<
          AdminBoardDtoOutputOrdersInnerTotal,
          AdminBoardDtoOutputOrdersInnerTotalBuilder
        > {
  _$AdminBoardDtoOutputOrdersInnerTotal? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminBoardDtoOutputOrdersInnerTotalBuilder() {
    AdminBoardDtoOutputOrdersInnerTotal._defaults(this);
  }

  AdminBoardDtoOutputOrdersInnerTotalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBoardDtoOutputOrdersInnerTotal other) {
    _$v = other as _$AdminBoardDtoOutputOrdersInnerTotal;
  }

  @override
  void update(
    void Function(AdminBoardDtoOutputOrdersInnerTotalBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBoardDtoOutputOrdersInnerTotal build() => _build();

  _$AdminBoardDtoOutputOrdersInnerTotal _build() {
    final _$result =
        _$v ??
        _$AdminBoardDtoOutputOrdersInnerTotal._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminBoardDtoOutputOrdersInnerTotal',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminBoardDtoOutputOrdersInnerTotal',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
