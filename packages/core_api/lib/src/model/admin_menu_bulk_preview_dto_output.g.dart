// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_bulk_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuBulkPreviewDtoOutput extends AdminMenuBulkPreviewDtoOutput {
  @override
  final String currency;
  @override
  final String roundingUnit;
  @override
  final BuiltList<AdminMenuBulkPreviewDtoOutputRowsInner> rows;
  @override
  final int changed;
  @override
  final int unchanged;
  @override
  final int refused;

  factory _$AdminMenuBulkPreviewDtoOutput([
    void Function(AdminMenuBulkPreviewDtoOutputBuilder)? updates,
  ]) => (AdminMenuBulkPreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuBulkPreviewDtoOutput._({
    required this.currency,
    required this.roundingUnit,
    required this.rows,
    required this.changed,
    required this.unchanged,
    required this.refused,
  }) : super._();
  @override
  AdminMenuBulkPreviewDtoOutput rebuild(
    void Function(AdminMenuBulkPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuBulkPreviewDtoOutputBuilder toBuilder() =>
      AdminMenuBulkPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuBulkPreviewDtoOutput &&
        currency == other.currency &&
        roundingUnit == other.roundingUnit &&
        rows == other.rows &&
        changed == other.changed &&
        unchanged == other.unchanged &&
        refused == other.refused;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, roundingUnit.hashCode);
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jc(_$hash, changed.hashCode);
    _$hash = $jc(_$hash, unchanged.hashCode);
    _$hash = $jc(_$hash, refused.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuBulkPreviewDtoOutput')
          ..add('currency', currency)
          ..add('roundingUnit', roundingUnit)
          ..add('rows', rows)
          ..add('changed', changed)
          ..add('unchanged', unchanged)
          ..add('refused', refused))
        .toString();
  }
}

class AdminMenuBulkPreviewDtoOutputBuilder
    implements
        Builder<
          AdminMenuBulkPreviewDtoOutput,
          AdminMenuBulkPreviewDtoOutputBuilder
        > {
  _$AdminMenuBulkPreviewDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _roundingUnit;
  String? get roundingUnit => _$this._roundingUnit;
  set roundingUnit(String? roundingUnit) => _$this._roundingUnit = roundingUnit;

  ListBuilder<AdminMenuBulkPreviewDtoOutputRowsInner>? _rows;
  ListBuilder<AdminMenuBulkPreviewDtoOutputRowsInner> get rows =>
      _$this._rows ??= ListBuilder<AdminMenuBulkPreviewDtoOutputRowsInner>();
  set rows(ListBuilder<AdminMenuBulkPreviewDtoOutputRowsInner>? rows) =>
      _$this._rows = rows;

  int? _changed;
  int? get changed => _$this._changed;
  set changed(int? changed) => _$this._changed = changed;

  int? _unchanged;
  int? get unchanged => _$this._unchanged;
  set unchanged(int? unchanged) => _$this._unchanged = unchanged;

  int? _refused;
  int? get refused => _$this._refused;
  set refused(int? refused) => _$this._refused = refused;

  AdminMenuBulkPreviewDtoOutputBuilder() {
    AdminMenuBulkPreviewDtoOutput._defaults(this);
  }

  AdminMenuBulkPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _roundingUnit = $v.roundingUnit;
      _rows = $v.rows.toBuilder();
      _changed = $v.changed;
      _unchanged = $v.unchanged;
      _refused = $v.refused;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuBulkPreviewDtoOutput other) {
    _$v = other as _$AdminMenuBulkPreviewDtoOutput;
  }

  @override
  void update(void Function(AdminMenuBulkPreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuBulkPreviewDtoOutput build() => _build();

  _$AdminMenuBulkPreviewDtoOutput _build() {
    _$AdminMenuBulkPreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuBulkPreviewDtoOutput._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminMenuBulkPreviewDtoOutput',
              'currency',
            ),
            roundingUnit: BuiltValueNullFieldError.checkNotNull(
              roundingUnit,
              r'AdminMenuBulkPreviewDtoOutput',
              'roundingUnit',
            ),
            rows: rows.build(),
            changed: BuiltValueNullFieldError.checkNotNull(
              changed,
              r'AdminMenuBulkPreviewDtoOutput',
              'changed',
            ),
            unchanged: BuiltValueNullFieldError.checkNotNull(
              unchanged,
              r'AdminMenuBulkPreviewDtoOutput',
              'unchanged',
            ),
            refused: BuiltValueNullFieldError.checkNotNull(
              refused,
              r'AdminMenuBulkPreviewDtoOutput',
              'refused',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rows';
        rows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuBulkPreviewDtoOutput',
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
