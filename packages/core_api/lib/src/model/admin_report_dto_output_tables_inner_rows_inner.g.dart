// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_tables_inner_rows_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDtoOutputTablesInnerRowsInner
    extends AdminReportDtoOutputTablesInnerRowsInner {
  @override
  final String? code;
  @override
  final String? label;
  @override
  final String? currency;
  @override
  final BuiltList<String?> cells;

  factory _$AdminReportDtoOutputTablesInnerRowsInner([
    void Function(AdminReportDtoOutputTablesInnerRowsInnerBuilder)? updates,
  ]) => (AdminReportDtoOutputTablesInnerRowsInnerBuilder()..update(updates))
      ._build();

  _$AdminReportDtoOutputTablesInnerRowsInner._({
    this.code,
    this.label,
    this.currency,
    required this.cells,
  }) : super._();
  @override
  AdminReportDtoOutputTablesInnerRowsInner rebuild(
    void Function(AdminReportDtoOutputTablesInnerRowsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputTablesInnerRowsInnerBuilder toBuilder() =>
      AdminReportDtoOutputTablesInnerRowsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputTablesInnerRowsInner &&
        code == other.code &&
        label == other.label &&
        currency == other.currency &&
        cells == other.cells;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, cells.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminReportDtoOutputTablesInnerRowsInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('currency', currency)
          ..add('cells', cells))
        .toString();
  }
}

class AdminReportDtoOutputTablesInnerRowsInnerBuilder
    implements
        Builder<
          AdminReportDtoOutputTablesInnerRowsInner,
          AdminReportDtoOutputTablesInnerRowsInnerBuilder
        > {
  _$AdminReportDtoOutputTablesInnerRowsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  ListBuilder<String?>? _cells;
  ListBuilder<String?> get cells => _$this._cells ??= ListBuilder<String?>();
  set cells(ListBuilder<String?>? cells) => _$this._cells = cells;

  AdminReportDtoOutputTablesInnerRowsInnerBuilder() {
    AdminReportDtoOutputTablesInnerRowsInner._defaults(this);
  }

  AdminReportDtoOutputTablesInnerRowsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _currency = $v.currency;
      _cells = $v.cells.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputTablesInnerRowsInner other) {
    _$v = other as _$AdminReportDtoOutputTablesInnerRowsInner;
  }

  @override
  void update(
    void Function(AdminReportDtoOutputTablesInnerRowsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputTablesInnerRowsInner build() => _build();

  _$AdminReportDtoOutputTablesInnerRowsInner _build() {
    _$AdminReportDtoOutputTablesInnerRowsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminReportDtoOutputTablesInnerRowsInner._(
            code: code,
            label: label,
            currency: currency,
            cells: cells.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cells';
        cells.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminReportDtoOutputTablesInnerRowsInner',
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
