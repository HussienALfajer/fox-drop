// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_bulk_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuBulkPreviewDtoOutput
    extends MerchantMenuBulkPreviewDtoOutput {
  @override
  final String currency;
  @override
  final String roundingUnit;
  @override
  final BuiltList<MerchantMenuBulkPreviewDtoOutputRowsInner> rows;
  @override
  final int changed;
  @override
  final int unchanged;
  @override
  final int refused;

  factory _$MerchantMenuBulkPreviewDtoOutput([
    void Function(MerchantMenuBulkPreviewDtoOutputBuilder)? updates,
  ]) => (MerchantMenuBulkPreviewDtoOutputBuilder()..update(updates))._build();

  _$MerchantMenuBulkPreviewDtoOutput._({
    required this.currency,
    required this.roundingUnit,
    required this.rows,
    required this.changed,
    required this.unchanged,
    required this.refused,
  }) : super._();
  @override
  MerchantMenuBulkPreviewDtoOutput rebuild(
    void Function(MerchantMenuBulkPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuBulkPreviewDtoOutputBuilder toBuilder() =>
      MerchantMenuBulkPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuBulkPreviewDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantMenuBulkPreviewDtoOutput')
          ..add('currency', currency)
          ..add('roundingUnit', roundingUnit)
          ..add('rows', rows)
          ..add('changed', changed)
          ..add('unchanged', unchanged)
          ..add('refused', refused))
        .toString();
  }
}

class MerchantMenuBulkPreviewDtoOutputBuilder
    implements
        Builder<
          MerchantMenuBulkPreviewDtoOutput,
          MerchantMenuBulkPreviewDtoOutputBuilder
        > {
  _$MerchantMenuBulkPreviewDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _roundingUnit;
  String? get roundingUnit => _$this._roundingUnit;
  set roundingUnit(String? roundingUnit) => _$this._roundingUnit = roundingUnit;

  ListBuilder<MerchantMenuBulkPreviewDtoOutputRowsInner>? _rows;
  ListBuilder<MerchantMenuBulkPreviewDtoOutputRowsInner> get rows =>
      _$this._rows ??= ListBuilder<MerchantMenuBulkPreviewDtoOutputRowsInner>();
  set rows(ListBuilder<MerchantMenuBulkPreviewDtoOutputRowsInner>? rows) =>
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

  MerchantMenuBulkPreviewDtoOutputBuilder() {
    MerchantMenuBulkPreviewDtoOutput._defaults(this);
  }

  MerchantMenuBulkPreviewDtoOutputBuilder get _$this {
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
  void replace(MerchantMenuBulkPreviewDtoOutput other) {
    _$v = other as _$MerchantMenuBulkPreviewDtoOutput;
  }

  @override
  void update(void Function(MerchantMenuBulkPreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuBulkPreviewDtoOutput build() => _build();

  _$MerchantMenuBulkPreviewDtoOutput _build() {
    _$MerchantMenuBulkPreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuBulkPreviewDtoOutput._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantMenuBulkPreviewDtoOutput',
              'currency',
            ),
            roundingUnit: BuiltValueNullFieldError.checkNotNull(
              roundingUnit,
              r'MerchantMenuBulkPreviewDtoOutput',
              'roundingUnit',
            ),
            rows: rows.build(),
            changed: BuiltValueNullFieldError.checkNotNull(
              changed,
              r'MerchantMenuBulkPreviewDtoOutput',
              'changed',
            ),
            unchanged: BuiltValueNullFieldError.checkNotNull(
              unchanged,
              r'MerchantMenuBulkPreviewDtoOutput',
              'unchanged',
            ),
            refused: BuiltValueNullFieldError.checkNotNull(
              refused,
              r'MerchantMenuBulkPreviewDtoOutput',
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
          r'MerchantMenuBulkPreviewDtoOutput',
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
