// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_period_statement_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantPeriodStatementDtoOutput
    extends AdminRestaurantPeriodStatementDtoOutput {
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final String cityId;
  @override
  final String? currency;
  @override
  final String fromDay;
  @override
  final String toDay;
  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final String opening;
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
  final String paid;
  @override
  final String closing;
  @override
  final BuiltList<AdminRestaurantPeriodStatementDtoOutputLinesInner> lines;

  factory _$AdminRestaurantPeriodStatementDtoOutput([
    void Function(AdminRestaurantPeriodStatementDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantPeriodStatementDtoOutputBuilder()..update(updates))
      ._build();

  _$AdminRestaurantPeriodStatementDtoOutput._({
    required this.restaurantId,
    required this.restaurantName,
    required this.cityId,
    this.currency,
    required this.fromDay,
    required this.toDay,
    required this.from,
    required this.to,
    required this.opening,
    required this.orders,
    required this.itemsValue,
    required this.commission,
    required this.discountShare,
    required this.exceptions,
    required this.paid,
    required this.closing,
    required this.lines,
  }) : super._();
  @override
  AdminRestaurantPeriodStatementDtoOutput rebuild(
    void Function(AdminRestaurantPeriodStatementDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantPeriodStatementDtoOutputBuilder toBuilder() =>
      AdminRestaurantPeriodStatementDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantPeriodStatementDtoOutput &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        cityId == other.cityId &&
        currency == other.currency &&
        fromDay == other.fromDay &&
        toDay == other.toDay &&
        from == other.from &&
        to == other.to &&
        opening == other.opening &&
        orders == other.orders &&
        itemsValue == other.itemsValue &&
        commission == other.commission &&
        discountShare == other.discountShare &&
        exceptions == other.exceptions &&
        paid == other.paid &&
        closing == other.closing &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, fromDay.hashCode);
    _$hash = $jc(_$hash, toDay.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, opening.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discountShare.hashCode);
    _$hash = $jc(_$hash, exceptions.hashCode);
    _$hash = $jc(_$hash, paid.hashCode);
    _$hash = $jc(_$hash, closing.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantPeriodStatementDtoOutput',
          )
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('cityId', cityId)
          ..add('currency', currency)
          ..add('fromDay', fromDay)
          ..add('toDay', toDay)
          ..add('from', from)
          ..add('to', to)
          ..add('opening', opening)
          ..add('orders', orders)
          ..add('itemsValue', itemsValue)
          ..add('commission', commission)
          ..add('discountShare', discountShare)
          ..add('exceptions', exceptions)
          ..add('paid', paid)
          ..add('closing', closing)
          ..add('lines', lines))
        .toString();
  }
}

class AdminRestaurantPeriodStatementDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantPeriodStatementDtoOutput,
          AdminRestaurantPeriodStatementDtoOutputBuilder
        > {
  _$AdminRestaurantPeriodStatementDtoOutput? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _fromDay;
  String? get fromDay => _$this._fromDay;
  set fromDay(String? fromDay) => _$this._fromDay = fromDay;

  String? _toDay;
  String? get toDay => _$this._toDay;
  set toDay(String? toDay) => _$this._toDay = toDay;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  String? _opening;
  String? get opening => _$this._opening;
  set opening(String? opening) => _$this._opening = opening;

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

  String? _paid;
  String? get paid => _$this._paid;
  set paid(String? paid) => _$this._paid = paid;

  String? _closing;
  String? get closing => _$this._closing;
  set closing(String? closing) => _$this._closing = closing;

  ListBuilder<AdminRestaurantPeriodStatementDtoOutputLinesInner>? _lines;
  ListBuilder<AdminRestaurantPeriodStatementDtoOutputLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<AdminRestaurantPeriodStatementDtoOutputLinesInner>();
  set lines(
    ListBuilder<AdminRestaurantPeriodStatementDtoOutputLinesInner>? lines,
  ) => _$this._lines = lines;

  AdminRestaurantPeriodStatementDtoOutputBuilder() {
    AdminRestaurantPeriodStatementDtoOutput._defaults(this);
  }

  AdminRestaurantPeriodStatementDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _cityId = $v.cityId;
      _currency = $v.currency;
      _fromDay = $v.fromDay;
      _toDay = $v.toDay;
      _from = $v.from;
      _to = $v.to;
      _opening = $v.opening;
      _orders = $v.orders;
      _itemsValue = $v.itemsValue;
      _commission = $v.commission;
      _discountShare = $v.discountShare;
      _exceptions = $v.exceptions;
      _paid = $v.paid;
      _closing = $v.closing;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantPeriodStatementDtoOutput other) {
    _$v = other as _$AdminRestaurantPeriodStatementDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantPeriodStatementDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantPeriodStatementDtoOutput build() => _build();

  _$AdminRestaurantPeriodStatementDtoOutput _build() {
    _$AdminRestaurantPeriodStatementDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantPeriodStatementDtoOutput._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'restaurantName',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'cityId',
            ),
            currency: currency,
            fromDay: BuiltValueNullFieldError.checkNotNull(
              fromDay,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'fromDay',
            ),
            toDay: BuiltValueNullFieldError.checkNotNull(
              toDay,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'toDay',
            ),
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'to',
            ),
            opening: BuiltValueNullFieldError.checkNotNull(
              opening,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'opening',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'orders',
            ),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'itemsValue',
            ),
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'commission',
            ),
            discountShare: BuiltValueNullFieldError.checkNotNull(
              discountShare,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'discountShare',
            ),
            exceptions: BuiltValueNullFieldError.checkNotNull(
              exceptions,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'exceptions',
            ),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'paid',
            ),
            closing: BuiltValueNullFieldError.checkNotNull(
              closing,
              r'AdminRestaurantPeriodStatementDtoOutput',
              'closing',
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
          r'AdminRestaurantPeriodStatementDtoOutput',
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
