// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputOrder extends AdminTicketPageDtoOutputOrder {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final String currency;
  @override
  final String total;
  @override
  final String itemsValue;
  @override
  final bool deliveredNormally;
  @override
  final BuiltList<AdminTicketPageDtoOutputOrderLinesInner> lines;
  @override
  final BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> received;
  @override
  final BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?> change;

  factory _$AdminTicketPageDtoOutputOrder([
    void Function(AdminTicketPageDtoOutputOrderBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputOrderBuilder()..update(updates))._build();

  _$AdminTicketPageDtoOutputOrder._({
    required this.orderId,
    required this.number,
    required this.currency,
    required this.total,
    required this.itemsValue,
    required this.deliveredNormally,
    required this.lines,
    required this.received,
    required this.change,
  }) : super._();
  @override
  AdminTicketPageDtoOutputOrder rebuild(
    void Function(AdminTicketPageDtoOutputOrderBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputOrderBuilder toBuilder() =>
      AdminTicketPageDtoOutputOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputOrder &&
        orderId == other.orderId &&
        number == other.number &&
        currency == other.currency &&
        total == other.total &&
        itemsValue == other.itemsValue &&
        deliveredNormally == other.deliveredNormally &&
        lines == other.lines &&
        received == other.received &&
        change == other.change;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, deliveredNormally.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketPageDtoOutputOrder')
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('currency', currency)
          ..add('total', total)
          ..add('itemsValue', itemsValue)
          ..add('deliveredNormally', deliveredNormally)
          ..add('lines', lines)
          ..add('received', received)
          ..add('change', change))
        .toString();
  }
}

class AdminTicketPageDtoOutputOrderBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputOrder,
          AdminTicketPageDtoOutputOrderBuilder
        > {
  _$AdminTicketPageDtoOutputOrder? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  bool? _deliveredNormally;
  bool? get deliveredNormally => _$this._deliveredNormally;
  set deliveredNormally(bool? deliveredNormally) =>
      _$this._deliveredNormally = deliveredNormally;

  ListBuilder<AdminTicketPageDtoOutputOrderLinesInner>? _lines;
  ListBuilder<AdminTicketPageDtoOutputOrderLinesInner> get lines =>
      _$this._lines ??= ListBuilder<AdminTicketPageDtoOutputOrderLinesInner>();
  set lines(ListBuilder<AdminTicketPageDtoOutputOrderLinesInner>? lines) =>
      _$this._lines = lines;

  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? _received;
  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>
  get received => _$this._received ??=
      ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>();
  set received(
    ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? received,
  ) => _$this._received = received;

  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? _change;
  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?> get change =>
      _$this._change ??=
          ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>();
  set change(
    ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>? change,
  ) => _$this._change = change;

  AdminTicketPageDtoOutputOrderBuilder() {
    AdminTicketPageDtoOutputOrder._defaults(this);
  }

  AdminTicketPageDtoOutputOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _currency = $v.currency;
      _total = $v.total;
      _itemsValue = $v.itemsValue;
      _deliveredNormally = $v.deliveredNormally;
      _lines = $v.lines.toBuilder();
      _received = $v.received.toBuilder();
      _change = $v.change.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputOrder other) {
    _$v = other as _$AdminTicketPageDtoOutputOrder;
  }

  @override
  void update(void Function(AdminTicketPageDtoOutputOrderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputOrder build() => _build();

  _$AdminTicketPageDtoOutputOrder _build() {
    _$AdminTicketPageDtoOutputOrder _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketPageDtoOutputOrder._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminTicketPageDtoOutputOrder',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminTicketPageDtoOutputOrder',
              'number',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminTicketPageDtoOutputOrder',
              'currency',
            ),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'AdminTicketPageDtoOutputOrder',
              'total',
            ),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'AdminTicketPageDtoOutputOrder',
              'itemsValue',
            ),
            deliveredNormally: BuiltValueNullFieldError.checkNotNull(
              deliveredNormally,
              r'AdminTicketPageDtoOutputOrder',
              'deliveredNormally',
            ),
            lines: lines.build(),
            received: received.build(),
            change: change.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'received';
        received.build();
        _$failedField = 'change';
        change.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketPageDtoOutputOrder',
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
