// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_contract_dto_output_deposit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainContractDtoOutputDeposit
    extends CaptainContractDtoOutputDeposit {
  @override
  final CaptainContractDtoOutputDepositAmount? amount;
  @override
  final String paid;
  @override
  final CaptainContractDtoOutputDepositAmount? instalment;

  factory _$CaptainContractDtoOutputDeposit([
    void Function(CaptainContractDtoOutputDepositBuilder)? updates,
  ]) => (CaptainContractDtoOutputDepositBuilder()..update(updates))._build();

  _$CaptainContractDtoOutputDeposit._({
    this.amount,
    required this.paid,
    this.instalment,
  }) : super._();
  @override
  CaptainContractDtoOutputDeposit rebuild(
    void Function(CaptainContractDtoOutputDepositBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainContractDtoOutputDepositBuilder toBuilder() =>
      CaptainContractDtoOutputDepositBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainContractDtoOutputDeposit &&
        amount == other.amount &&
        paid == other.paid &&
        instalment == other.instalment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, paid.hashCode);
    _$hash = $jc(_$hash, instalment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainContractDtoOutputDeposit')
          ..add('amount', amount)
          ..add('paid', paid)
          ..add('instalment', instalment))
        .toString();
  }
}

class CaptainContractDtoOutputDepositBuilder
    implements
        Builder<
          CaptainContractDtoOutputDeposit,
          CaptainContractDtoOutputDepositBuilder
        > {
  _$CaptainContractDtoOutputDeposit? _$v;

  CaptainContractDtoOutputDepositAmountBuilder? _amount;
  CaptainContractDtoOutputDepositAmountBuilder get amount =>
      _$this._amount ??= CaptainContractDtoOutputDepositAmountBuilder();
  set amount(CaptainContractDtoOutputDepositAmountBuilder? amount) =>
      _$this._amount = amount;

  String? _paid;
  String? get paid => _$this._paid;
  set paid(String? paid) => _$this._paid = paid;

  CaptainContractDtoOutputDepositAmountBuilder? _instalment;
  CaptainContractDtoOutputDepositAmountBuilder get instalment =>
      _$this._instalment ??= CaptainContractDtoOutputDepositAmountBuilder();
  set instalment(CaptainContractDtoOutputDepositAmountBuilder? instalment) =>
      _$this._instalment = instalment;

  CaptainContractDtoOutputDepositBuilder() {
    CaptainContractDtoOutputDeposit._defaults(this);
  }

  CaptainContractDtoOutputDepositBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount?.toBuilder();
      _paid = $v.paid;
      _instalment = $v.instalment?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainContractDtoOutputDeposit other) {
    _$v = other as _$CaptainContractDtoOutputDeposit;
  }

  @override
  void update(void Function(CaptainContractDtoOutputDepositBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainContractDtoOutputDeposit build() => _build();

  _$CaptainContractDtoOutputDeposit _build() {
    _$CaptainContractDtoOutputDeposit _$result;
    try {
      _$result =
          _$v ??
          _$CaptainContractDtoOutputDeposit._(
            amount: _amount?.build(),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'CaptainContractDtoOutputDeposit',
              'paid',
            ),
            instalment: _instalment?.build(),
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
          r'CaptainContractDtoOutputDeposit',
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
