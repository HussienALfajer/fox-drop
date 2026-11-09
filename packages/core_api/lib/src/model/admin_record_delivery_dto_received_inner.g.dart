// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_delivery_dto_received_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDeliveryDtoReceivedInner
    extends AdminRecordDeliveryDtoReceivedInner {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminRecordDeliveryDtoReceivedInner([
    void Function(AdminRecordDeliveryDtoReceivedInnerBuilder)? updates,
  ]) =>
      (AdminRecordDeliveryDtoReceivedInnerBuilder()..update(updates))._build();

  _$AdminRecordDeliveryDtoReceivedInner._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminRecordDeliveryDtoReceivedInner rebuild(
    void Function(AdminRecordDeliveryDtoReceivedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDeliveryDtoReceivedInnerBuilder toBuilder() =>
      AdminRecordDeliveryDtoReceivedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDeliveryDtoReceivedInner &&
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
    return (newBuiltValueToStringHelper(r'AdminRecordDeliveryDtoReceivedInner')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminRecordDeliveryDtoReceivedInnerBuilder
    implements
        Builder<
          AdminRecordDeliveryDtoReceivedInner,
          AdminRecordDeliveryDtoReceivedInnerBuilder
        > {
  _$AdminRecordDeliveryDtoReceivedInner? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminRecordDeliveryDtoReceivedInnerBuilder() {
    AdminRecordDeliveryDtoReceivedInner._defaults(this);
  }

  AdminRecordDeliveryDtoReceivedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDeliveryDtoReceivedInner other) {
    _$v = other as _$AdminRecordDeliveryDtoReceivedInner;
  }

  @override
  void update(
    void Function(AdminRecordDeliveryDtoReceivedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDeliveryDtoReceivedInner build() => _build();

  _$AdminRecordDeliveryDtoReceivedInner _build() {
    final _$result =
        _$v ??
        _$AdminRecordDeliveryDtoReceivedInner._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRecordDeliveryDtoReceivedInner',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRecordDeliveryDtoReceivedInner',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
