// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementDtoOutput extends AdminSettlementDtoOutput {
  @override
  final AdminSettlementDtoOutputStatement statement;
  @override
  final BuiltList<AdminSettlementDtoOutputReceiptsInner> receipts;

  factory _$AdminSettlementDtoOutput([
    void Function(AdminSettlementDtoOutputBuilder)? updates,
  ]) => (AdminSettlementDtoOutputBuilder()..update(updates))._build();

  _$AdminSettlementDtoOutput._({
    required this.statement,
    required this.receipts,
  }) : super._();
  @override
  AdminSettlementDtoOutput rebuild(
    void Function(AdminSettlementDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementDtoOutputBuilder toBuilder() =>
      AdminSettlementDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementDtoOutput &&
        statement == other.statement &&
        receipts == other.receipts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, statement.hashCode);
    _$hash = $jc(_$hash, receipts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSettlementDtoOutput')
          ..add('statement', statement)
          ..add('receipts', receipts))
        .toString();
  }
}

class AdminSettlementDtoOutputBuilder
    implements
        Builder<AdminSettlementDtoOutput, AdminSettlementDtoOutputBuilder> {
  _$AdminSettlementDtoOutput? _$v;

  AdminSettlementDtoOutputStatementBuilder? _statement;
  AdminSettlementDtoOutputStatementBuilder get statement =>
      _$this._statement ??= AdminSettlementDtoOutputStatementBuilder();
  set statement(AdminSettlementDtoOutputStatementBuilder? statement) =>
      _$this._statement = statement;

  ListBuilder<AdminSettlementDtoOutputReceiptsInner>? _receipts;
  ListBuilder<AdminSettlementDtoOutputReceiptsInner> get receipts =>
      _$this._receipts ??= ListBuilder<AdminSettlementDtoOutputReceiptsInner>();
  set receipts(ListBuilder<AdminSettlementDtoOutputReceiptsInner>? receipts) =>
      _$this._receipts = receipts;

  AdminSettlementDtoOutputBuilder() {
    AdminSettlementDtoOutput._defaults(this);
  }

  AdminSettlementDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statement = $v.statement.toBuilder();
      _receipts = $v.receipts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementDtoOutput other) {
    _$v = other as _$AdminSettlementDtoOutput;
  }

  @override
  void update(void Function(AdminSettlementDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementDtoOutput build() => _build();

  _$AdminSettlementDtoOutput _build() {
    _$AdminSettlementDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementDtoOutput._(
            statement: statement.build(),
            receipts: receipts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statement';
        statement.build();
        _$failedField = 'receipts';
        receipts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSettlementDtoOutput',
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
