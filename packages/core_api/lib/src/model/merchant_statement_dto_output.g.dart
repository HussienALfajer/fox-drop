// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_statement_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantStatementDtoOutputStatusEnum
_$merchantStatementDtoOutputStatusEnum_unpaid =
    const MerchantStatementDtoOutputStatusEnum._('unpaid');
const MerchantStatementDtoOutputStatusEnum
_$merchantStatementDtoOutputStatusEnum_partlyPaid =
    const MerchantStatementDtoOutputStatusEnum._('partlyPaid');
const MerchantStatementDtoOutputStatusEnum
_$merchantStatementDtoOutputStatusEnum_paid =
    const MerchantStatementDtoOutputStatusEnum._('paid');

MerchantStatementDtoOutputStatusEnum
_$merchantStatementDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'unpaid':
      return _$merchantStatementDtoOutputStatusEnum_unpaid;
    case 'partlyPaid':
      return _$merchantStatementDtoOutputStatusEnum_partlyPaid;
    case 'paid':
      return _$merchantStatementDtoOutputStatusEnum_paid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantStatementDtoOutputStatusEnum>
_$merchantStatementDtoOutputStatusEnumValues =
    BuiltSet<MerchantStatementDtoOutputStatusEnum>(
      const <MerchantStatementDtoOutputStatusEnum>[
        _$merchantStatementDtoOutputStatusEnum_unpaid,
        _$merchantStatementDtoOutputStatusEnum_partlyPaid,
        _$merchantStatementDtoOutputStatusEnum_paid,
      ],
    );

Serializer<MerchantStatementDtoOutputStatusEnum>
_$merchantStatementDtoOutputStatusEnumSerializer =
    _$MerchantStatementDtoOutputStatusEnumSerializer();

class _$MerchantStatementDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<MerchantStatementDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unpaid': 'unpaid',
    'partlyPaid': 'partly_paid',
    'paid': 'paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'unpaid': 'unpaid',
    'partly_paid': 'partlyPaid',
    'paid': 'paid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantStatementDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'MerchantStatementDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantStatementDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantStatementDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantStatementDtoOutput extends MerchantStatementDtoOutput {
  @override
  final String id;
  @override
  final String restaurantName;
  @override
  final DateTime cutoff;
  @override
  final DateTime? periodFrom;
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
  final MerchantStatementDtoOutputStatusEnum? status;
  @override
  final String unpaid;
  @override
  final BuiltList<MerchantStatementDtoOutputLinesInner> lines;

  factory _$MerchantStatementDtoOutput([
    void Function(MerchantStatementDtoOutputBuilder)? updates,
  ]) => (MerchantStatementDtoOutputBuilder()..update(updates))._build();

  _$MerchantStatementDtoOutput._({
    required this.id,
    required this.restaurantName,
    required this.cutoff,
    this.periodFrom,
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
    this.status,
    required this.unpaid,
    required this.lines,
  }) : super._();
  @override
  MerchantStatementDtoOutput rebuild(
    void Function(MerchantStatementDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantStatementDtoOutputBuilder toBuilder() =>
      MerchantStatementDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantStatementDtoOutput &&
        id == other.id &&
        restaurantName == other.restaurantName &&
        cutoff == other.cutoff &&
        periodFrom == other.periodFrom &&
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
        status == other.status &&
        unpaid == other.unpaid &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, cutoff.hashCode);
    _$hash = $jc(_$hash, periodFrom.hashCode);
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
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, unpaid.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantStatementDtoOutput')
          ..add('id', id)
          ..add('restaurantName', restaurantName)
          ..add('cutoff', cutoff)
          ..add('periodFrom', periodFrom)
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
          ..add('status', status)
          ..add('unpaid', unpaid)
          ..add('lines', lines))
        .toString();
  }
}

class MerchantStatementDtoOutputBuilder
    implements
        Builder<MerchantStatementDtoOutput, MerchantStatementDtoOutputBuilder> {
  _$MerchantStatementDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  MerchantStatementDtoOutputStatusEnum? _status;
  MerchantStatementDtoOutputStatusEnum? get status => _$this._status;
  set status(MerchantStatementDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _unpaid;
  String? get unpaid => _$this._unpaid;
  set unpaid(String? unpaid) => _$this._unpaid = unpaid;

  ListBuilder<MerchantStatementDtoOutputLinesInner>? _lines;
  ListBuilder<MerchantStatementDtoOutputLinesInner> get lines =>
      _$this._lines ??= ListBuilder<MerchantStatementDtoOutputLinesInner>();
  set lines(ListBuilder<MerchantStatementDtoOutputLinesInner>? lines) =>
      _$this._lines = lines;

  MerchantStatementDtoOutputBuilder() {
    MerchantStatementDtoOutput._defaults(this);
  }

  MerchantStatementDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _restaurantName = $v.restaurantName;
      _cutoff = $v.cutoff;
      _periodFrom = $v.periodFrom;
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
      _status = $v.status;
      _unpaid = $v.unpaid;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantStatementDtoOutput other) {
    _$v = other as _$MerchantStatementDtoOutput;
  }

  @override
  void update(void Function(MerchantStatementDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantStatementDtoOutput build() => _build();

  _$MerchantStatementDtoOutput _build() {
    _$MerchantStatementDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantStatementDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantStatementDtoOutput',
              'id',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'MerchantStatementDtoOutput',
              'restaurantName',
            ),
            cutoff: BuiltValueNullFieldError.checkNotNull(
              cutoff,
              r'MerchantStatementDtoOutput',
              'cutoff',
            ),
            periodFrom: periodFrom,
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantStatementDtoOutput',
              'currency',
            ),
            orders: BuiltValueNullFieldError.checkNotNull(
              orders,
              r'MerchantStatementDtoOutput',
              'orders',
            ),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'MerchantStatementDtoOutput',
              'itemsValue',
            ),
            commission: BuiltValueNullFieldError.checkNotNull(
              commission,
              r'MerchantStatementDtoOutput',
              'commission',
            ),
            discountShare: BuiltValueNullFieldError.checkNotNull(
              discountShare,
              r'MerchantStatementDtoOutput',
              'discountShare',
            ),
            exceptions: BuiltValueNullFieldError.checkNotNull(
              exceptions,
              r'MerchantStatementDtoOutput',
              'exceptions',
            ),
            weekTotal: BuiltValueNullFieldError.checkNotNull(
              weekTotal,
              r'MerchantStatementDtoOutput',
              'weekTotal',
            ),
            previousDue: BuiltValueNullFieldError.checkNotNull(
              previousDue,
              r'MerchantStatementDtoOutput',
              'previousDue',
            ),
            paid: BuiltValueNullFieldError.checkNotNull(
              paid,
              r'MerchantStatementDtoOutput',
              'paid',
            ),
            earlierUnpaid: BuiltValueNullFieldError.checkNotNull(
              earlierUnpaid,
              r'MerchantStatementDtoOutput',
              'earlierUnpaid',
            ),
            totalDue: BuiltValueNullFieldError.checkNotNull(
              totalDue,
              r'MerchantStatementDtoOutput',
              'totalDue',
            ),
            status: status,
            unpaid: BuiltValueNullFieldError.checkNotNull(
              unpaid,
              r'MerchantStatementDtoOutput',
              'unpaid',
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
          r'MerchantStatementDtoOutput',
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
