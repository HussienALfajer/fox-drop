// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_statement_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainStatementListDtoOutput extends CaptainStatementListDtoOutput {
  @override
  final BuiltList<CaptainStatementListDtoOutputStatementsInner> statements;

  factory _$CaptainStatementListDtoOutput([
    void Function(CaptainStatementListDtoOutputBuilder)? updates,
  ]) => (CaptainStatementListDtoOutputBuilder()..update(updates))._build();

  _$CaptainStatementListDtoOutput._({required this.statements}) : super._();
  @override
  CaptainStatementListDtoOutput rebuild(
    void Function(CaptainStatementListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainStatementListDtoOutputBuilder toBuilder() =>
      CaptainStatementListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainStatementListDtoOutput &&
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
      r'CaptainStatementListDtoOutput',
    )..add('statements', statements)).toString();
  }
}

class CaptainStatementListDtoOutputBuilder
    implements
        Builder<
          CaptainStatementListDtoOutput,
          CaptainStatementListDtoOutputBuilder
        > {
  _$CaptainStatementListDtoOutput? _$v;

  ListBuilder<CaptainStatementListDtoOutputStatementsInner>? _statements;
  ListBuilder<CaptainStatementListDtoOutputStatementsInner> get statements =>
      _$this._statements ??=
          ListBuilder<CaptainStatementListDtoOutputStatementsInner>();
  set statements(
    ListBuilder<CaptainStatementListDtoOutputStatementsInner>? statements,
  ) => _$this._statements = statements;

  CaptainStatementListDtoOutputBuilder() {
    CaptainStatementListDtoOutput._defaults(this);
  }

  CaptainStatementListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statements = $v.statements.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainStatementListDtoOutput other) {
    _$v = other as _$CaptainStatementListDtoOutput;
  }

  @override
  void update(void Function(CaptainStatementListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainStatementListDtoOutput build() => _build();

  _$CaptainStatementListDtoOutput _build() {
    _$CaptainStatementListDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainStatementListDtoOutput._(statements: statements.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statements';
        statements.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainStatementListDtoOutput',
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
