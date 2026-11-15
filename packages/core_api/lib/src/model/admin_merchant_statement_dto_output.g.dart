// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_merchant_statement_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMerchantStatementDtoOutput
    extends AdminMerchantStatementDtoOutput {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final DateTime cutoff;
  @override
  final DateTime? periodFrom;
  @override
  final DateTime createdAt;
  @override
  final String currency;
  @override
  final int orders;
  @override
  final String itemsValue;
  @override
  final String commission;
  @override
  final String discountShare;
  @override
  final String exceptions;
  @override
  final String weekTotal;
  @override
  final String previousDue;
  @override
  final String paid;
  @override
  final String earlierUnpaid;
  @override
  final String totalDue;
  @override
  final BuiltList<AdminMerchantStatementDtoOutputLinesInner> lines;

  factory _$AdminMerchantStatementDtoOutput([
    void Function(AdminMerchantStatementDtoOutputBuilder)? updates,
  ]) => (AdminMerchantStatementDtoOutputBuilder()..update(updates))._build();

  _$AdminMerchantStatementDtoOutput._({
    required this.id,
    required this.cityId,
    required this.restaurantId,
    required this.restaurantName,
    required this.cutoff,
    this.periodFrom,
    required this.createdAt,
    required this.currency,
    required this.orders,
    required this.itemsValue,
    required this.commission,
    required this.discountShare,
    required this.exceptions,
    required this.weekTotal,
    required this.previousDue,
    required this.paid,
    required this.earlierUnpaid,
    required this.totalDue,
    required this.lines,
  }) : super._();
  @override
  AdminMerchantStatementDtoOutput rebuild(
    void Function(AdminMerchantStatementDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMerchantStatementDtoOutputBuilder toBuilder() =>
      AdminMerchantStatementDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMerchantStatementDtoOutput &&
        id == other.id &&
        cityId == other.cityId &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        cutoff == other.cutoff &&
        periodFrom == other.periodFrom &&
        createdAt == other.createdAt &&
        currency == other.currency &&
        orders == other.orders &&
        itemsValue == other.itemsValue &&
        commission == other.commission &&
        discountShare == other.discountShare &&
        exceptions == other.exceptions &&
        weekTotal == other.weekTotal &&
        previousDue == other.previousDue &&
        paid == other.paid &&
        earlierUnpaid == other.earlierUnpaid &&
        totalDue == other.totalDue &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, cutoff.hashCode);
    _$hash = $jc(_$hash, periodFrom.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discountShare.hashCode);
    _$hash = $jc(_$hash, exceptions.hashCode);
    _$hash = $jc(_$hash, weekTotal.hashCode);
    _$hash = $jc(_$hash, previousDue.hashCode);
    _$hash = $jc(_$hash, paid.hashCode);
    _$hash = $jc(_$hash, earlierUnpaid.hashCode);
    _$hash = $jc(_$hash, totalDue.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMerchantStatementDtoOutput')
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('cutoff', cutoff)
          ..add('periodFrom', periodFrom)
          ..add('createdAt', createdAt)
          ..add('currency', currency)
          ..add('orders', orders)
          ..add('itemsValue', itemsValue)
          ..add('commission', commission)
          ..add('discountShare', discountShare)
          ..add('exceptions', exceptions)
          ..add('weekTotal', weekTotal)
          ..add('previousDue', previousDue)
          ..add('paid', paid)
          ..add('earlierUnpaid', earlierUnpaid)
          ..add('totalDue', totalDue)
          ..add('lines', lines))
        .toString();
  }
}

class AdminMerchantStatementDtoOutputBuilder
    implements
        Builder<
          AdminMerchantStatementDtoOutput,
          AdminMerchantStatementDtoOutputBuilder
        > {
  _$AdminMerchantStatementDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  DateTime? _cutoff;
  DateTime? get cutoff => _$this._cutoff;
  set cutoff(DateTime? cutoff) => _$this._cutoff = cutoff;

  DateTime? _periodFrom;
  DateTime? get periodFrom => _$this._periodFrom;
  set periodFrom(DateTime? periodFrom) => _$this._periodFrom = periodFrom;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _discountShare;
  String? get discountShare => _$this._discountShare;
  set discountShare(String? discountShare) =>
      _$this._discountShare = discountShare;

  String? _exceptions;
  String? get exceptions => _$this._exceptions;
  set exceptions(String? exceptions) => _$this._exceptions = exceptions;

  String? _weekTotal;
  String? get weekTotal => _$this._weekTotal;
  set weekTotal(String? weekTotal) => _$this._weekTotal = weekTotal;

  String? _previousDue;
  String? get previousDue => _$this._previousDue;
  set previousDue(String? previousDue) => _$this._previousDue = previousDue;

  String? _paid;
  String? get paid => _$this._paid;
  set paid(String? paid) => _$this._paid = paid;

  String? _earlierUnpaid;
  String? get earlierUnpaid => _$this._earlierUnpaid;
  set earlierUnpaid(String? earlierUnpaid) =>
      _$this._earlierUnpaid = earlierUnpaid;

  String? _totalDue;
  String? get totalDue => _$this._totalDue;
  set totalDue(String? totalDue) => _$this._totalDue = totalDue;

  ListBuilder<AdminMerchantStatementDtoOutputLinesInner>? _lines;
  ListBuilder<AdminMerchantStatementDtoOutputLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminMerchantStatementDtoOutputLinesInner>();
  set lines(ListBuilder<AdminMerchantStatementDtoOutputLinesInner>? lines) =>
      _$this._lines = lines;

  AdminMerchantStatementDtoOutputBuilder() {
    AdminMerchantStatementDtoOutput._defaults(this);
  }

  AdminMerchantStatementDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _cutoff = $v.cutoff;
      _periodFrom = $v.periodFrom;
      _createdAt = $v.createdAt;
      _currency = $v.currency;
      _orders = $v.orders;
      _itemsValue = $v.itemsValue;
      _commission = $v.commission;
      _discountShare = $v.discountShare;
      _exceptions = $v.exceptions;
      _weekTotal = $v.weekTotal;
      _previousDue = $v.previousDue;
      _paid = $v.paid;
      _earlierUnpaid = $v.earlierUnpaid;
      _totalDue = $v.totalDue;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMerchantStatementDtoOutput other) {
    _$v = other as _$AdminMerchantStatementDtoOutput;
  }

  @override
  void update(void Function(AdminMerchantStatementDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMerchantStatementDtoOutput build() => _build();

  _$AdminMerchantStatementDtoOutput _build() {
    _$AdminMerchantStatementDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminMerchantStatementDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMerchantStatementDtoOutput',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminMerchantStatementDtoOutput',
              'cityId',
            ),
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminMerchantStatementDtoOutput',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminMerchantStatementDtoOutput',
              'restaurantName',
            ),
            cutoff: BuiltValueNullFieldError.checkNotNull(
              cutoff,
              r'AdminMerchantStatementDtoOutput',
              'cutoff',
            ),
            periodFrom: periodFrom,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminMerchantStatementDtoOutput',
              'createdAt',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminMerchantStatementDtoOutput',
              'currency',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'AdminMerchantStatementDtoOutput',
              'orders',
            ),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'AdminMerchantStatementDtoOutput',
              'itemsValue',
            ),
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'AdminMerchantStatementDtoOutput',
              'commission',
            ),
            discountShare: BuiltValueNullFieldError.checkNotNull(
              discountShare,
              r'AdminMerchantStatementDtoOutput',
              'discountShare',
            ),
            exceptions: BuiltValueNullFieldError.checkNotNull(
              exceptions,
              r'AdminMerchantStatementDtoOutput',
              'exceptions',
            ),
            weekTotal: BuiltValueNullFieldError.checkNotNull(
              weekTotal,
              r'AdminMerchantStatementDtoOutput',
              'weekTotal',
            ),
            previousDue: BuiltValueNullFieldError.checkNotNull(
              previousDue,
              r'AdminMerchantStatementDtoOutput',
              'previousDue',
            ),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'AdminMerchantStatementDtoOutput',
              'paid',
            ),
            earlierUnpaid: BuiltValueNullFieldError.checkNotNull(
              earlierUnpaid,
              r'AdminMerchantStatementDtoOutput',
              'earlierUnpaid',
            ),
            totalDue: BuiltValueNullFieldError.checkNotNull(
              totalDue,
              r'AdminMerchantStatementDtoOutput',
              'totalDue',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMerchantStatementDtoOutput',
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
