// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposits_dto_output_applications_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositsDtoOutputApplicationsInner
    extends AdminDepositsDtoOutputApplicationsInner {
  @override
  final String applicationId;
  @override
  final String fullName;
  @override
  final AdminDepositsDtoOutputApplicationsInnerDeposit deposit;
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? suggested;
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? cashLimit;
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? suggestedCashLimit;

  factory _$AdminDepositsDtoOutputApplicationsInner([
    void Function(AdminDepositsDtoOutputApplicationsInnerBuilder)? updates,
  ]) => (AdminDepositsDtoOutputApplicationsInnerBuilder()..update(updates))
      ._build();

  _$AdminDepositsDtoOutputApplicationsInner._({
    required this.applicationId,
    required this.fullName,
    required this.deposit,
    this.suggested,
    this.cashLimit,
    this.suggestedCashLimit,
  }) : super._();
  @override
  AdminDepositsDtoOutputApplicationsInner rebuild(
    void Function(AdminDepositsDtoOutputApplicationsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositsDtoOutputApplicationsInnerBuilder toBuilder() =>
      AdminDepositsDtoOutputApplicationsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositsDtoOutputApplicationsInner &&
        applicationId == other.applicationId &&
        fullName == other.fullName &&
        deposit == other.deposit &&
        suggested == other.suggested &&
        cashLimit == other.cashLimit &&
        suggestedCashLimit == other.suggestedCashLimit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, deposit.hashCode);
    _$hash = $jc(_$hash, suggested.hashCode);
    _$hash = $jc(_$hash, cashLimit.hashCode);
    _$hash = $jc(_$hash, suggestedCashLimit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDepositsDtoOutputApplicationsInner',
          )
          ..add('applicationId', applicationId)
          ..add('fullName', fullName)
          ..add('deposit', deposit)
          ..add('suggested', suggested)
          ..add('cashLimit', cashLimit)
          ..add('suggestedCashLimit', suggestedCashLimit))
        .toString();
  }
}

class AdminDepositsDtoOutputApplicationsInnerBuilder
    implements
        Builder<
          AdminDepositsDtoOutputApplicationsInner,
          AdminDepositsDtoOutputApplicationsInnerBuilder
        > {
  _$AdminDepositsDtoOutputApplicationsInner? _$v;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  AdminDepositsDtoOutputApplicationsInnerDepositBuilder? _deposit;
  AdminDepositsDtoOutputApplicationsInnerDepositBuilder get deposit =>
      _$this._deposit ??=
          AdminDepositsDtoOutputApplicationsInnerDepositBuilder();
  set deposit(AdminDepositsDtoOutputApplicationsInnerDepositBuilder? deposit) =>
      _$this._deposit = deposit;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? _suggested;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get suggested =>
      _$this._suggested ??=
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set suggested(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? suggested,
  ) => _$this._suggested = suggested;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? _cashLimit;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get cashLimit =>
      _$this._cashLimit ??=
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set cashLimit(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? cashLimit,
  ) => _$this._cashLimit = cashLimit;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder?
  _suggestedCashLimit;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder
  get suggestedCashLimit => _$this._suggestedCashLimit ??=
      AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set suggestedCashLimit(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder?
    suggestedCashLimit,
  ) => _$this._suggestedCashLimit = suggestedCashLimit;

  AdminDepositsDtoOutputApplicationsInnerBuilder() {
    AdminDepositsDtoOutputApplicationsInner._defaults(this);
  }

  AdminDepositsDtoOutputApplicationsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applicationId = $v.applicationId;
      _fullName = $v.fullName;
      _deposit = $v.deposit.toBuilder();
      _suggested = $v.suggested?.toBuilder();
      _cashLimit = $v.cashLimit?.toBuilder();
      _suggestedCashLimit = $v.suggestedCashLimit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositsDtoOutputApplicationsInner other) {
    _$v = other as _$AdminDepositsDtoOutputApplicationsInner;
  }

  @override
  void update(
    void Function(AdminDepositsDtoOutputApplicationsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositsDtoOutputApplicationsInner build() => _build();

  _$AdminDepositsDtoOutputApplicationsInner _build() {
    _$AdminDepositsDtoOutputApplicationsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminDepositsDtoOutputApplicationsInner._(
            applicationId: BuiltValueNullFieldError.checkNotNull(
              applicationId,
              r'AdminDepositsDtoOutputApplicationsInner',
              'applicationId',
            ),
            fullName: BuiltValueNullFieldError.checkNotNull(
              fullName,
              r'AdminDepositsDtoOutputApplicationsInner',
              'fullName',
            ),
            deposit: deposit.build(),
            suggested: _suggested?.build(),
            cashLimit: _cashLimit?.build(),
            suggestedCashLimit: _suggestedCashLimit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'deposit';
        deposit.build();
        _$failedField = 'suggested';
        _suggested?.build();
        _$failedField = 'cashLimit';
        _cashLimit?.build();
        _$failedField = 'suggestedCashLimit';
        _suggestedCashLimit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDepositsDtoOutputApplicationsInner',
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
