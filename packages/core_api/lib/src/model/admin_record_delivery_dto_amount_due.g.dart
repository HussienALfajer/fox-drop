// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_delivery_dto_amount_due.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDeliveryDtoAmountDue
    extends AdminRecordDeliveryDtoAmountDue {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminRecordDeliveryDtoAmountDue([
    void Function(AdminRecordDeliveryDtoAmountDueBuilder)? updates,
  ]) => (AdminRecordDeliveryDtoAmountDueBuilder()..update(updates))._build();

  _$AdminRecordDeliveryDtoAmountDue._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminRecordDeliveryDtoAmountDue rebuild(
    void Function(AdminRecordDeliveryDtoAmountDueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDeliveryDtoAmountDueBuilder toBuilder() =>
      AdminRecordDeliveryDtoAmountDueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDeliveryDtoAmountDue &&
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
    return (newBuiltValueToStringHelper(r'AdminRecordDeliveryDtoAmountDue')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminRecordDeliveryDtoAmountDueBuilder
    implements
        Builder<
          AdminRecordDeliveryDtoAmountDue,
          AdminRecordDeliveryDtoAmountDueBuilder
        > {
  _$AdminRecordDeliveryDtoAmountDue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminRecordDeliveryDtoAmountDueBuilder() {
    AdminRecordDeliveryDtoAmountDue._defaults(this);
  }

  AdminRecordDeliveryDtoAmountDueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDeliveryDtoAmountDue other) {
    _$v = other as _$AdminRecordDeliveryDtoAmountDue;
  }

  @override
  void update(void Function(AdminRecordDeliveryDtoAmountDueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDeliveryDtoAmountDue build() => _build();

  _$AdminRecordDeliveryDtoAmountDue _build() {
    final _$result =
        _$v ??
        _$AdminRecordDeliveryDtoAmountDue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRecordDeliveryDtoAmountDue',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRecordDeliveryDtoAmountDue',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
