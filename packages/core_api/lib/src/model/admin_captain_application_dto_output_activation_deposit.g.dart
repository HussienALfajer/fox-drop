// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_deposit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivationDeposit
    extends AdminCaptainApplicationDtoOutputActivationDeposit {
  @override
  final AdminCaptainApplicationDtoOutputActivationCashLimit? amount;
  @override
  final AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?
  instalment;
  @override
  final String paid;
  @override
  final bool recorded;

  factory _$AdminCaptainApplicationDtoOutputActivationDeposit([
    void Function(AdminCaptainApplicationDtoOutputActivationDepositBuilder)?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationDepositBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationDeposit._({
    this.amount,
    this.instalment,
    required this.paid,
    required this.recorded,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationDeposit rebuild(
    void Function(AdminCaptainApplicationDtoOutputActivationDepositBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationDepositBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationDepositBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivationDeposit &&
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
            r'AdminCaptainApplicationDtoOutputActivationDeposit',
          )
          ..add('amount', amount)
          ..add('instalment', instalment)
          ..add('paid', paid)
          ..add('recorded', recorded))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationDepositBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationDeposit,
          AdminCaptainApplicationDtoOutputActivationDepositBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationDeposit? _$v;

  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder? _amount;
  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder get amount =>
      _$this._amount ??=
          AdminCaptainApplicationDtoOutputActivationCashLimitBuilder();
  set amount(
    AdminCaptainApplicationDtoOutputActivationCashLimitBuilder? amount,
  ) => _$this._amount = amount;

  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder?
  _instalment;
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
  get instalment => _$this._instalment ??=
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder();
  set instalment(
    AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder?
    instalment,
  ) => _$this._instalment = instalment;

  String? _paid;
  String? get paid => _$this._paid;
  set paid(String? paid) => _$this._paid = paid;

  bool? _recorded;
  bool? get recorded => _$this._recorded;
  set recorded(bool? recorded) => _$this._recorded = recorded;

  AdminCaptainApplicationDtoOutputActivationDepositBuilder() {
    AdminCaptainApplicationDtoOutputActivationDeposit._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationDepositBuilder get _$this {
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
  void replace(AdminCaptainApplicationDtoOutputActivationDeposit other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivationDeposit;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputActivationDepositBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationDeposit build() => _build();

  _$AdminCaptainApplicationDtoOutputActivationDeposit _build() {
    _$AdminCaptainApplicationDtoOutputActivationDeposit _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationDtoOutputActivationDeposit._(
            amount: _amount?.build(),
            instalment: _instalment?.build(),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'AdminCaptainApplicationDtoOutputActivationDeposit',
              'paid',
            ),
            recorded: BuiltValueNullFieldError.checkNotNull(
              recorded,
              r'AdminCaptainApplicationDtoOutputActivationDeposit',
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
          r'AdminCaptainApplicationDtoOutputActivationDeposit',
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
