// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_item_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerItemReport
    extends MerchantOrdersDtoOutputOrdersInnerItemReport {
  @override
  final DateTime at;
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner> items;
  @override
  final MerchantOrdersDtoOutputOrdersInnerItemReportNote? note;

  factory _$MerchantOrdersDtoOutputOrdersInnerItemReport([
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerItemReportBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerItemReport._({
    required this.at,
    required this.items,
    this.note,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerItemReport rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerItemReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerItemReport &&
        at == other.at &&
        items == other.items &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerItemReport',
          )
          ..add('at', at)
          ..add('items', items)
          ..add('note', note))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerItemReportBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerItemReport,
          MerchantOrdersDtoOutputOrdersInnerItemReportBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerItemReport? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  ListBuilder<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner>? _items;
  ListBuilder<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner>
  get items => _$this._items ??=
      ListBuilder<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner>();
  set items(
    ListBuilder<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner>? items,
  ) => _$this._items = items;

  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder? _note;
  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder get note =>
      _$this._note ??=
          MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder();
  set note(MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder? note) =>
      _$this._note = note;

  MerchantOrdersDtoOutputOrdersInnerItemReportBuilder() {
    MerchantOrdersDtoOutputOrdersInnerItemReport._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerItemReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _items = $v.items.toBuilder();
      _note = $v.note?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerItemReport other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerItemReport;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerItemReportBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReport build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerItemReport _build() {
    _$MerchantOrdersDtoOutputOrdersInnerItemReport _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputOrdersInnerItemReport._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'MerchantOrdersDtoOutputOrdersInnerItemReport',
              'at',
            ),
            items: items.build(),
            note: _note?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
        _$failedField = 'note';
        _note?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutputOrdersInnerItemReport',
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
