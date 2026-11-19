// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivation
    extends AdminCaptainApplicationDtoOutputActivation {
  @override
  final AdminCaptainApplicationDtoOutputActivationKit? kit;
  @override
  final AdminCaptainApplicationDtoOutputActivationCashLimit? cashLimit;
  @override
  final AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?
  suggestedCashLimit;
  @override
  final AdminCaptainApplicationDtoOutputActivationContract? contract;
  @override
  final AdminCaptainApplicationDtoOutputActivationDeposit deposit;
  @override
  final AdminCaptainApplicationDtoOutputActivationSuggestedCashLimit?
  suggestedDeposit;
  @override
  final BuiltList<String> missing;
  @override
  final String? captainId;
  @override
  final DateTime? activatedAt;

  factory _$AdminCaptainApplicationDtoOutputActivation([
    void Function(AdminCaptainApplicationDtoOutputActivationBuilder)? updates,
  ]) => (AdminCaptainApplicationDtoOutputActivationBuilder()..update(updates))
      ._build();

  _$AdminCaptainApplicationDtoOutputActivation._({
    this.kit,
    this.cashLimit,
    this.suggestedCashLimit,
    this.contract,
    required this.deposit,
    this.suggestedDeposit,
    required this.missing,
    this.captainId,
    this.activatedAt,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivation rebuild(
    void Function(AdminCaptainApplicationDtoOutputActivationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivation &&
        kit == other.kit &&
        cashLimit == other.cashLimit &&
        suggestedCashLimit == other.suggestedCashLimit &&
        contract == other.contract &&
        deposit == other.deposit &&
        suggestedDeposit == other.suggestedDeposit &&
        missing == other.missing &&
        captainId == other.captainId &&
        activatedAt == other.activatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kit.hashCode);
    _$hash = $jc(_$hash, cashLimit.hashCode);
    _$hash = $jc(_$hash, suggestedCashLimit.hashCode);
    _$hash = $jc(_$hash, contract.hashCode);
    _$hash = $jc(_$hash, deposit.hashCode);
    _$hash = $jc(_$hash, suggestedDeposit.hashCode);
    _$hash = $jc(_$hash, missing.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, activatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputActivation',
          )
          ..add('kit', kit)
          ..add('cashLimit', cashLimit)
          ..add('suggestedCashLimit', suggestedCashLimit)
          ..add('contract', contract)
          ..add('deposit', deposit)
          ..add('suggestedDeposit', suggestedDeposit)
          ..add('missing', missing)
          ..add('captainId', captainId)
          ..add('activatedAt', activatedAt))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivation,
          AdminCaptainApplicationDtoOutputActivationBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivation? _$v;

  AdminCaptainApplicationDtoOutputActivationKitBuilder? _kit;
  AdminCaptainApplicationDtoOutputActivationKitBuilder get kit =>
      _$this._kit ??= AdminCaptainApplicationDtoOutputActivationKitBuilder();
  set kit(AdminCaptainApplicationDtoOutputActivationKitBuilder? kit) =>
      _$this._kit = kit;

  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder? _cashLimit;
  AdminCaptainApplicationDtoOutputActivationCashLimitBuilder get cashLimit =>
      _$this._cashLimit ??=
          AdminCaptainApplicationDtoOutputActivationCashLimitBuilder();
  set cashLimit(
    AdminCaptainApplicationDtoOutputActivationCashLimitBuilder? cashLimit,
  ) => _$this._cashLimit = cashLimit;

  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder?
  _suggestedCashLimit;
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
  get suggestedCashLimit => _$this._suggestedCashLimit ??=
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder();
  set suggestedCashLimit(
    AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder?
    suggestedCashLimit,
  ) => _$this._suggestedCashLimit = suggestedCashLimit;

  AdminCaptainApplicationDtoOutputActivationContractBuilder? _contract;
  AdminCaptainApplicationDtoOutputActivationContractBuilder get contract =>
      _$this._contract ??=
          AdminCaptainApplicationDtoOutputActivationContractBuilder();
  set contract(
    AdminCaptainApplicationDtoOutputActivationContractBuilder? contract,
  ) => _$this._contract = contract;

  AdminCaptainApplicationDtoOutputActivationDepositBuilder? _deposit;
  AdminCaptainApplicationDtoOutputActivationDepositBuilder get deposit =>
      _$this._deposit ??=
          AdminCaptainApplicationDtoOutputActivationDepositBuilder();
  set deposit(
    AdminCaptainApplicationDtoOutputActivationDepositBuilder? deposit,
  ) => _$this._deposit = deposit;

  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder?
  _suggestedDeposit;
  AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder
  get suggestedDeposit => _$this._suggestedDeposit ??=
      AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder();
  set suggestedDeposit(
    AdminCaptainApplicationDtoOutputActivationSuggestedCashLimitBuilder?
    suggestedDeposit,
  ) => _$this._suggestedDeposit = suggestedDeposit;

  ListBuilder<String>? _missing;
  ListBuilder<String> get missing => _$this._missing ??= ListBuilder<String>();
  set missing(ListBuilder<String>? missing) => _$this._missing = missing;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  DateTime? _activatedAt;
  DateTime? get activatedAt => _$this._activatedAt;
  set activatedAt(DateTime? activatedAt) => _$this._activatedAt = activatedAt;

  AdminCaptainApplicationDtoOutputActivationBuilder() {
    AdminCaptainApplicationDtoOutputActivation._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kit = $v.kit?.toBuilder();
      _cashLimit = $v.cashLimit?.toBuilder();
      _suggestedCashLimit = $v.suggestedCashLimit?.toBuilder();
      _contract = $v.contract?.toBuilder();
      _deposit = $v.deposit.toBuilder();
      _suggestedDeposit = $v.suggestedDeposit?.toBuilder();
      _missing = $v.missing.toBuilder();
      _captainId = $v.captainId;
      _activatedAt = $v.activatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputActivation other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivation;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputActivationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivation build() => _build();

  _$AdminCaptainApplicationDtoOutputActivation _build() {
    _$AdminCaptainApplicationDtoOutputActivation _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationDtoOutputActivation._(
            kit: _kit?.build(),
            cashLimit: _cashLimit?.build(),
            suggestedCashLimit: _suggestedCashLimit?.build(),
            contract: _contract?.build(),
            deposit: deposit.build(),
            suggestedDeposit: _suggestedDeposit?.build(),
            missing: missing.build(),
            captainId: captainId,
            activatedAt: activatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kit';
        _kit?.build();
        _$failedField = 'cashLimit';
        _cashLimit?.build();
        _$failedField = 'suggestedCashLimit';
        _suggestedCashLimit?.build();
        _$failedField = 'contract';
        _contract?.build();
        _$failedField = 'deposit';
        deposit.build();
        _$failedField = 'suggestedDeposit';
        _suggestedDeposit?.build();
        _$failedField = 'missing';
        missing.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationDtoOutputActivation',
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
