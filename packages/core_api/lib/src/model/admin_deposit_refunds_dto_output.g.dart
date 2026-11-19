// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_deposit_refunds_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDepositRefundsDtoOutput extends AdminDepositRefundsDtoOutput {
  @override
  final BuiltList<AdminDepositRefundsDtoOutputContractsInner> contracts;

  factory _$AdminDepositRefundsDtoOutput([
    void Function(AdminDepositRefundsDtoOutputBuilder)? updates,
  ]) => (AdminDepositRefundsDtoOutputBuilder()..update(updates))._build();

  _$AdminDepositRefundsDtoOutput._({required this.contracts}) : super._();
  @override
  AdminDepositRefundsDtoOutput rebuild(
    void Function(AdminDepositRefundsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDepositRefundsDtoOutputBuilder toBuilder() =>
      AdminDepositRefundsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDepositRefundsDtoOutput &&
        contracts == other.contracts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contracts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminDepositRefundsDtoOutput',
    )..add('contracts', contracts)).toString();
  }
}

class AdminDepositRefundsDtoOutputBuilder
    implements
        Builder<
          AdminDepositRefundsDtoOutput,
          AdminDepositRefundsDtoOutputBuilder
        > {
  _$AdminDepositRefundsDtoOutput? _$v;

  ListBuilder<AdminDepositRefundsDtoOutputContractsInner>? _contracts;
  ListBuilder<AdminDepositRefundsDtoOutputContractsInner> get contracts =>
      _$this._contracts ??=
          ListBuilder<AdminDepositRefundsDtoOutputContractsInner>();
  set contracts(
    ListBuilder<AdminDepositRefundsDtoOutputContractsInner>? contracts,
  ) => _$this._contracts = contracts;

  AdminDepositRefundsDtoOutputBuilder() {
    AdminDepositRefundsDtoOutput._defaults(this);
  }

  AdminDepositRefundsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contracts = $v.contracts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDepositRefundsDtoOutput other) {
    _$v = other as _$AdminDepositRefundsDtoOutput;
  }

  @override
  void update(void Function(AdminDepositRefundsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDepositRefundsDtoOutput build() => _build();

  _$AdminDepositRefundsDtoOutput _build() {
    _$AdminDepositRefundsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminDepositRefundsDtoOutput._(contracts: contracts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contracts';
        contracts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDepositRefundsDtoOutput',
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
