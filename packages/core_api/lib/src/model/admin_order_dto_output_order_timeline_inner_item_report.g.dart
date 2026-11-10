// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_timeline_inner_item_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderTimelineInnerItemReport
    extends AdminOrderDtoOutputOrderTimelineInnerItemReport {
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner> items;
  @override
  final MerchantOrdersDtoOutputOrdersInnerItemReportNote? note;

  factory _$AdminOrderDtoOutputOrderTimelineInnerItemReport([
    void Function(AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderTimelineInnerItemReport._({
    required this.items,
    this.note,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderTimelineInnerItemReport rebuild(
    void Function(AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder toBuilder() =>
      AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderTimelineInnerItemReport &&
        items == other.items &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderTimelineInnerItemReport',
          )
          ..add('items', items)
          ..add('note', note))
        .toString();
  }
}

class AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderTimelineInnerItemReport,
          AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder
        > {
  _$AdminOrderDtoOutputOrderTimelineInnerItemReport? _$v;

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

  AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder() {
    AdminOrderDtoOutputOrderTimelineInnerItemReport._defaults(this);
  }

  AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _note = $v.note?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderTimelineInnerItemReport other) {
    _$v = other as _$AdminOrderDtoOutputOrderTimelineInnerItemReport;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderTimelineInnerItemReport build() => _build();

  _$AdminOrderDtoOutputOrderTimelineInnerItemReport _build() {
    _$AdminOrderDtoOutputOrderTimelineInnerItemReport _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderTimelineInnerItemReport._(
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
          r'AdminOrderDtoOutputOrderTimelineInnerItemReport',
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
