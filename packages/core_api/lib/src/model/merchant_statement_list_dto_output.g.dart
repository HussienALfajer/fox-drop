// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_statement_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantStatementListDtoOutput extends MerchantStatementListDtoOutput {
  @override
  final BuiltList<MerchantStatementListDtoOutputStatementsInner> statements;

  factory _$MerchantStatementListDtoOutput([
    void Function(MerchantStatementListDtoOutputBuilder)? updates,
  ]) => (MerchantStatementListDtoOutputBuilder()..update(updates))._build();

  _$MerchantStatementListDtoOutput._({required this.statements}) : super._();
  @override
  MerchantStatementListDtoOutput rebuild(
    void Function(MerchantStatementListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatementListDtoOutputBuilder toBuilder() =>
      MerchantStatementListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatementListDtoOutput &&
        statements == other.statements;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, statements.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantStatementListDtoOutput',
    )..add('statements', statements)).toString();
  }
}

class MerchantStatementListDtoOutputBuilder
    implements
        Builder<
          MerchantStatementListDtoOutput,
          MerchantStatementListDtoOutputBuilder
        > {
  _$MerchantStatementListDtoOutput? _$v;

  ListBuilder<MerchantStatementListDtoOutputStatementsInner>? _statements;
  ListBuilder<MerchantStatementListDtoOutputStatementsInner> get statements =>
      _$this._statements ??=
          ListBuilder<MerchantStatementListDtoOutputStatementsInner>();
  set statements(
    ListBuilder<MerchantStatementListDtoOutputStatementsInner>? statements,
  ) => _$this._statements = statements;

  MerchantStatementListDtoOutputBuilder() {
    MerchantStatementListDtoOutput._defaults(this);
  }

  MerchantStatementListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statements = $v.statements.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatementListDtoOutput other) {
    _$v = other as _$MerchantStatementListDtoOutput;
  }

  @override
  void update(void Function(MerchantStatementListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatementListDtoOutput build() => _build();

  _$MerchantStatementListDtoOutput _build() {
    _$MerchantStatementListDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantStatementListDtoOutput._(statements: statements.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statements';
        statements.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantStatementListDtoOutput',
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
