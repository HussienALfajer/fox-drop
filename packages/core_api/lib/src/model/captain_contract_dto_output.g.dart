// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_contract_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainContractDtoOutput extends CaptainContractDtoOutput {
  @override
  final CaptainContractDtoOutputContract? contract;
  @override
  final BuiltList<CaptainContractDtoOutputKitInner> kit;
  @override
  final CaptainContractDtoOutputDeposit deposit;

  factory _$CaptainContractDtoOutput([
    void Function(CaptainContractDtoOutputBuilder)? updates,
  ]) => (CaptainContractDtoOutputBuilder()..update(updates))._build();

  _$CaptainContractDtoOutput._({
    this.contract,
    required this.kit,
    required this.deposit,
  }) : super._();
  @override
  CaptainContractDtoOutput rebuild(
    void Function(CaptainContractDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainContractDtoOutputBuilder toBuilder() =>
      CaptainContractDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainContractDtoOutput &&
        contract == other.contract &&
        kit == other.kit &&
        deposit == other.deposit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contract.hashCode);
    _$hash = $jc(_$hash, kit.hashCode);
    _$hash = $jc(_$hash, deposit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainContractDtoOutput')
          ..add('contract', contract)
          ..add('kit', kit)
          ..add('deposit', deposit))
        .toString();
  }
}

class CaptainContractDtoOutputBuilder
    implements
        Builder<CaptainContractDtoOutput, CaptainContractDtoOutputBuilder> {
  _$CaptainContractDtoOutput? _$v;

  CaptainContractDtoOutputContractBuilder? _contract;
  CaptainContractDtoOutputContractBuilder get contract =>
      _$this._contract ??= CaptainContractDtoOutputContractBuilder();
  set contract(CaptainContractDtoOutputContractBuilder? contract) =>
      _$this._contract = contract;

  ListBuilder<CaptainContractDtoOutputKitInner>? _kit;
  ListBuilder<CaptainContractDtoOutputKitInner> get kit =>
      _$this._kit ??= ListBuilder<CaptainContractDtoOutputKitInner>();
  set kit(ListBuilder<CaptainContractDtoOutputKitInner>? kit) =>
      _$this._kit = kit;

  CaptainContractDtoOutputDepositBuilder? _deposit;
  CaptainContractDtoOutputDepositBuilder get deposit =>
      _$this._deposit ??= CaptainContractDtoOutputDepositBuilder();
  set deposit(CaptainContractDtoOutputDepositBuilder? deposit) =>
      _$this._deposit = deposit;

  CaptainContractDtoOutputBuilder() {
    CaptainContractDtoOutput._defaults(this);
  }

  CaptainContractDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contract = $v.contract?.toBuilder();
      _kit = $v.kit.toBuilder();
      _deposit = $v.deposit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainContractDtoOutput other) {
    _$v = other as _$CaptainContractDtoOutput;
  }

  @override
  void update(void Function(CaptainContractDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainContractDtoOutput build() => _build();

  _$CaptainContractDtoOutput _build() {
    _$CaptainContractDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainContractDtoOutput._(
            contract: _contract?.build(),
            kit: kit.build(),
            deposit: deposit.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contract';
        _contract?.build();
        _$failedField = 'kit';
        kit.build();
        _$failedField = 'deposit';
        deposit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainContractDtoOutput',
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
