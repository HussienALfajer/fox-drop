// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_delivery_net_received.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderDeliveryNetReceived
    extends AdminOrderDtoOutputOrderDeliveryNetReceived {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminOrderDtoOutputOrderDeliveryNetReceived([
    void Function(AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderDeliveryNetReceived._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderDeliveryNetReceived rebuild(
    void Function(AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder toBuilder() =>
      AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderDeliveryNetReceived &&
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
            r'AdminOrderDtoOutputOrderDeliveryNetReceived',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderDeliveryNetReceived,
          AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder
        > {
  _$AdminOrderDtoOutputOrderDeliveryNetReceived? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder() {
    AdminOrderDtoOutputOrderDeliveryNetReceived._defaults(this);
  }

  AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderDeliveryNetReceived other) {
    _$v = other as _$AdminOrderDtoOutputOrderDeliveryNetReceived;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderDeliveryNetReceivedBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderDeliveryNetReceived build() => _build();

  _$AdminOrderDtoOutputOrderDeliveryNetReceived _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderDeliveryNetReceived._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOrderDtoOutputOrderDeliveryNetReceived',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOrderDtoOutputOrderDeliveryNetReceived',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
