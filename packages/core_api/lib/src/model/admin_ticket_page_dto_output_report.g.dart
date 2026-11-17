// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputReport extends AdminTicketPageDtoOutputReport {
  @override
  final BuiltList<AdminTicketPageDtoOutputReportLinesInner> lines;
  @override
  final BuiltList<String> photoUrls;
  @override
  final AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner? item;
  @override
  final AdminTicketPageDtoOutputPickupDisputePickupPayment? shopPrice;

  factory _$AdminTicketPageDtoOutputReport([
    void Function(AdminTicketPageDtoOutputReportBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputReportBuilder()..update(updates))._build();

  _$AdminTicketPageDtoOutputReport._({
    required this.lines,
    required this.photoUrls,
    this.item,
    this.shopPrice,
  }) : super._();
  @override
  AdminTicketPageDtoOutputReport rebuild(
    void Function(AdminTicketPageDtoOutputReportBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputReportBuilder toBuilder() =>
      AdminTicketPageDtoOutputReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputReport &&
        lines == other.lines &&
        photoUrls == other.photoUrls &&
        item == other.item &&
        shopPrice == other.shopPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, photoUrls.hashCode);
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jc(_$hash, shopPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketPageDtoOutputReport')
          ..add('lines', lines)
          ..add('photoUrls', photoUrls)
          ..add('item', item)
          ..add('shopPrice', shopPrice))
        .toString();
  }
}

class AdminTicketPageDtoOutputReportBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputReport,
          AdminTicketPageDtoOutputReportBuilder
        > {
  _$AdminTicketPageDtoOutputReport? _$v;

  ListBuilder<AdminTicketPageDtoOutputReportLinesInner>? _lines;
  ListBuilder<AdminTicketPageDtoOutputReportLinesInner> get lines =>
      _$this._lines ??= ListBuilder<AdminTicketPageDtoOutputReportLinesInner>();
  set lines(ListBuilder<AdminTicketPageDtoOutputReportLinesInner>? lines) =>
      _$this._lines = lines;

  ListBuilder<String>? _photoUrls;
  ListBuilder<String> get photoUrls =>
      _$this._photoUrls ??= ListBuilder<String>();
  set photoUrls(ListBuilder<String>? photoUrls) =>
      _$this._photoUrls = photoUrls;

  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder? _item;
  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder get item =>
      _$this._item ??=
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder();
  set item(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder? item) =>
      _$this._item = item;

  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? _shopPrice;
  AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder get shopPrice =>
      _$this._shopPrice ??=
          AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder();
  set shopPrice(
    AdminTicketPageDtoOutputPickupDisputePickupPaymentBuilder? shopPrice,
  ) => _$this._shopPrice = shopPrice;

  AdminTicketPageDtoOutputReportBuilder() {
    AdminTicketPageDtoOutputReport._defaults(this);
  }

  AdminTicketPageDtoOutputReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _photoUrls = $v.photoUrls.toBuilder();
      _item = $v.item?.toBuilder();
      _shopPrice = $v.shopPrice?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputReport other) {
    _$v = other as _$AdminTicketPageDtoOutputReport;
  }

  @override
  void update(void Function(AdminTicketPageDtoOutputReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputReport build() => _build();

  _$AdminTicketPageDtoOutputReport _build() {
    _$AdminTicketPageDtoOutputReport _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketPageDtoOutputReport._(
            lines: lines.build(),
            photoUrls: photoUrls.build(),
            item: _item?.build(),
            shopPrice: _shopPrice?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'photoUrls';
        photoUrls.build();
        _$failedField = 'item';
        _item?.build();
        _$failedField = 'shopPrice';
        _shopPrice?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketPageDtoOutputReport',
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
