// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_item_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderItemReport
    extends AdminOrderDtoOutputOrderItemReport {
  @override
  final DateTime at;
  @override
  final BuiltList<AdminOrderDtoOutputOrderItemReportItemsInner> items;
  @override
  final MerchantOrdersDtoOutputOrdersInnerItemReportNote? note;

  factory _$AdminOrderDtoOutputOrderItemReport([
    void Function(AdminOrderDtoOutputOrderItemReportBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderItemReportBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderItemReport._({
    required this.at,
    required this.items,
    this.note,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderItemReport rebuild(
    void Function(AdminOrderDtoOutputOrderItemReportBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderItemReportBuilder toBuilder() =>
      AdminOrderDtoOutputOrderItemReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderItemReport &&
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
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderItemReport')
          ..add('at', at)
          ..add('items', items)
          ..add('note', note))
        .toString();
  }
}

class AdminOrderDtoOutputOrderItemReportBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderItemReport,
          AdminOrderDtoOutputOrderItemReportBuilder
        > {
  _$AdminOrderDtoOutputOrderItemReport? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  ListBuilder<AdminOrderDtoOutputOrderItemReportItemsInner>? _items;
  ListBuilder<AdminOrderDtoOutputOrderItemReportItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminOrderDtoOutputOrderItemReportItemsInner>();
  set items(ListBuilder<AdminOrderDtoOutputOrderItemReportItemsInner>? items) =>
      _$this._items = items;

  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder? _note;
  MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder get note =>
      _$this._note ??=
          MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder();
  set note(MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder? note) =>
      _$this._note = note;

  AdminOrderDtoOutputOrderItemReportBuilder() {
    AdminOrderDtoOutputOrderItemReport._defaults(this);
  }

  AdminOrderDtoOutputOrderItemReportBuilder get _$this {
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
  void replace(AdminOrderDtoOutputOrderItemReport other) {
    _$v = other as _$AdminOrderDtoOutputOrderItemReport;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderItemReportBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderItemReport build() => _build();

  _$AdminOrderDtoOutputOrderItemReport _build() {
    _$AdminOrderDtoOutputOrderItemReport _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderItemReport._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderItemReport',
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
          r'AdminOrderDtoOutputOrderItemReport',
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
