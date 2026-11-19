// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposits_dto_output_applications_inner_deposit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositsDtoOutputApplicationsInnerDeposit
    extends AdminDepositsDtoOutputApplicationsInnerDeposit {
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? amount;
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? instalment;
  @override
  final String paid;
  @override
  final bool recorded;

  factory _$AdminDepositsDtoOutputApplicationsInnerDeposit([
    void Function(AdminDepositsDtoOutputApplicationsInnerDepositBuilder)?
    updates,
  ]) =>
      (AdminDepositsDtoOutputApplicationsInnerDepositBuilder()..update(updates))
          ._build();

  _$AdminDepositsDtoOutputApplicationsInnerDeposit._({
    this.amount,
    this.instalment,
    required this.paid,
    required this.recorded,
  }) : super._();
  @override
  AdminDepositsDtoOutputApplicationsInnerDeposit rebuild(
    void Function(AdminDepositsDtoOutputApplicationsInnerDepositBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositsDtoOutputApplicationsInnerDepositBuilder toBuilder() =>
      AdminDepositsDtoOutputApplicationsInnerDepositBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositsDtoOutputApplicationsInnerDeposit &&
        amount == other.amount &&
        instalment == other.instalment &&
        paid == other.paid &&
        recorded == other.recorded;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, instalment.hashCode);
    _$hash = $jc(_$hash, paid.hashCode);
    _$hash = $jc(_$hash, recorded.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDepositsDtoOutputApplicationsInnerDeposit',
          )
          ..add('amount', amount)
          ..add('instalment', instalment)
          ..add('paid', paid)
          ..add('recorded', recorded))
        .toString();
  }
}

class AdminDepositsDtoOutputApplicationsInnerDepositBuilder
    implements
        Builder<
          AdminDepositsDtoOutputApplicationsInnerDeposit,
          AdminDepositsDtoOutputApplicationsInnerDepositBuilder
        > {
  _$AdminDepositsDtoOutputApplicationsInnerDeposit? _$v;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? _amount;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get amount =>
      _$this._amount ??=
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set amount(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? amount,
  ) => _$this._amount = amount;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? _instalment;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get instalment =>
      _$this._instalment ??=
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set instalment(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? instalment,
  ) => _$this._instalment = instalment;

  String? _paid;
  String? get paid => _$this._paid;
  set paid(String? paid) => _$this._paid = paid;

  bool? _recorded;
  bool? get recorded => _$this._recorded;
  set recorded(bool? recorded) => _$this._recorded = recorded;

  AdminDepositsDtoOutputApplicationsInnerDepositBuilder() {
    AdminDepositsDtoOutputApplicationsInnerDeposit._defaults(this);
  }

  AdminDepositsDtoOutputApplicationsInnerDepositBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount?.toBuilder();
      _instalment = $v.instalment?.toBuilder();
      _paid = $v.paid;
      _recorded = $v.recorded;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositsDtoOutputApplicationsInnerDeposit other) {
    _$v = other as _$AdminDepositsDtoOutputApplicationsInnerDeposit;
  }

  @override
  void update(
    void Function(AdminDepositsDtoOutputApplicationsInnerDepositBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositsDtoOutputApplicationsInnerDeposit build() => _build();

  _$AdminDepositsDtoOutputApplicationsInnerDeposit _build() {
    _$AdminDepositsDtoOutputApplicationsInnerDeposit _$result;
    try {
      _$result =
          _$v ??
          _$AdminDepositsDtoOutputApplicationsInnerDeposit._(
            amount: _amount?.build(),
            instalment: _instalment?.build(),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'AdminDepositsDtoOutputApplicationsInnerDeposit',
              'paid',
            ),
            recorded: BuiltValueNullFieldError.checkNotNull(
              recorded,
              r'AdminDepositsDtoOutputApplicationsInnerDeposit',
              'recorded',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        _amount?.build();
        _$failedField = 'instalment';
        _instalment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDepositsDtoOutputApplicationsInnerDeposit',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
