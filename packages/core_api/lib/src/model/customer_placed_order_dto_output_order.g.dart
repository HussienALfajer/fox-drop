// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_placed_order_dto_output_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_placed =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('placed');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_accepted =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('accepted');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_ready =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('ready');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_pickedUp =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('pickedUp');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_arrived =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('arrived');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_delivered =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('delivered');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_rejected =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('rejected');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_cancelled =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('cancelled');
const CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnum_failed =
    const CustomerPlacedOrderDtoOutputOrderStatusEnum._('failed');

CustomerPlacedOrderDtoOutputOrderStatusEnum
_$customerPlacedOrderDtoOutputOrderStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_placed;
    case 'accepted':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_accepted;
    case 'ready':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_ready;
    case 'pickedUp':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_pickedUp;
    case 'arrived':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_arrived;
    case 'delivered':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_delivered;
    case 'rejected':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_rejected;
    case 'cancelled':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_cancelled;
    case 'failed':
      return _$customerPlacedOrderDtoOutputOrderStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerPlacedOrderDtoOutputOrderStatusEnum>
_$customerPlacedOrderDtoOutputOrderStatusEnumValues =
    BuiltSet<CustomerPlacedOrderDtoOutputOrderStatusEnum>(
      const <CustomerPlacedOrderDtoOutputOrderStatusEnum>[
        _$customerPlacedOrderDtoOutputOrderStatusEnum_placed,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_accepted,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_ready,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_pickedUp,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_arrived,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_delivered,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_rejected,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_cancelled,
        _$customerPlacedOrderDtoOutputOrderStatusEnum_failed,
      ],
    );

Serializer<CustomerPlacedOrderDtoOutputOrderStatusEnum>
_$customerPlacedOrderDtoOutputOrderStatusEnumSerializer =
    _$CustomerPlacedOrderDtoOutputOrderStatusEnumSerializer();

class _$CustomerPlacedOrderDtoOutputOrderStatusEnumSerializer
    implements
        PrimitiveSerializer<CustomerPlacedOrderDtoOutputOrderStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'pickedUp': 'picked_up',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'picked_up': 'pickedUp',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerPlacedOrderDtoOutputOrderStatusEnum,
  ];
  @override
  final String wireName = 'CustomerPlacedOrderDtoOutputOrderStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrderStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerPlacedOrderDtoOutputOrderStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerPlacedOrderDtoOutputOrderStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerPlacedOrderDtoOutputOrder
    extends CustomerPlacedOrderDtoOutputOrder {
  @override
  final String id;
  @override
  final String number;
  @override
  final CustomerPlacedOrderDtoOutputOrderStatusEnum status;
  @override
  final DateTime placedAt;
  @override
  final String restaurantId;
  @override
  final String currency;
  @override
  final CustomerPlacedOrderDtoOutputOrderMoney money;
  @override
  final BuiltList<CustomerPlacedOrderDtoOutputOrderLinesInner> lines;
  @override
  final String? payIn;
  @override
  final String? note;
  @override
  final CustomerPlacedOrderDtoOutputOrderEstimate estimate;
  @override
  final CustomerPlacedOrderDtoOutputOrderAddress address;

  factory _$CustomerPlacedOrderDtoOutputOrder([
    void Function(CustomerPlacedOrderDtoOutputOrderBuilder)? updates,
  ]) => (CustomerPlacedOrderDtoOutputOrderBuilder()..update(updates))._build();

  _$CustomerPlacedOrderDtoOutputOrder._({
    required this.id,
    required this.number,
    required this.status,
    required this.placedAt,
    required this.restaurantId,
    required this.currency,
    required this.money,
    required this.lines,
    this.payIn,
    this.note,
    required this.estimate,
    required this.address,
  }) : super._();
  @override
  CustomerPlacedOrderDtoOutputOrder rebuild(
    void Function(CustomerPlacedOrderDtoOutputOrderBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlacedOrderDtoOutputOrderBuilder toBuilder() =>
      CustomerPlacedOrderDtoOutputOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlacedOrderDtoOutputOrder &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        placedAt == other.placedAt &&
        restaurantId == other.restaurantId &&
        currency == other.currency &&
        money == other.money &&
        lines == other.lines &&
        payIn == other.payIn &&
        note == other.note &&
        estimate == other.estimate &&
        address == other.address;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, money.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerPlacedOrderDtoOutputOrder')
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('placedAt', placedAt)
          ..add('restaurantId', restaurantId)
          ..add('currency', currency)
          ..add('money', money)
          ..add('lines', lines)
          ..add('payIn', payIn)
          ..add('note', note)
          ..add('estimate', estimate)
          ..add('address', address))
        .toString();
  }
}

class CustomerPlacedOrderDtoOutputOrderBuilder
    implements
        Builder<
          CustomerPlacedOrderDtoOutputOrder,
          CustomerPlacedOrderDtoOutputOrderBuilder
        > {
  _$CustomerPlacedOrderDtoOutputOrder? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerPlacedOrderDtoOutputOrderStatusEnum? _status;
  CustomerPlacedOrderDtoOutputOrderStatusEnum? get status => _$this._status;
  set status(CustomerPlacedOrderDtoOutputOrderStatusEnum? status) =>
      _$this._status = status;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerPlacedOrderDtoOutputOrderMoneyBuilder? _money;
  CustomerPlacedOrderDtoOutputOrderMoneyBuilder get money =>
      _$this._money ??= CustomerPlacedOrderDtoOutputOrderMoneyBuilder();
  set money(CustomerPlacedOrderDtoOutputOrderMoneyBuilder? money) =>
      _$this._money = money;

  ListBuilder<CustomerPlacedOrderDtoOutputOrderLinesInner>? _lines;
  ListBuilder<CustomerPlacedOrderDtoOutputOrderLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<CustomerPlacedOrderDtoOutputOrderLinesInner>();
  set lines(ListBuilder<CustomerPlacedOrderDtoOutputOrderLinesInner>? lines) =>
      _$this._lines = lines;

  String? _payIn;
  String? get payIn => _$this._payIn;
  set payIn(String? payIn) => _$this._payIn = payIn;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CustomerPlacedOrderDtoOutputOrderEstimateBuilder? _estimate;
  CustomerPlacedOrderDtoOutputOrderEstimateBuilder get estimate =>
      _$this._estimate ??= CustomerPlacedOrderDtoOutputOrderEstimateBuilder();
  set estimate(CustomerPlacedOrderDtoOutputOrderEstimateBuilder? estimate) =>
      _$this._estimate = estimate;

  CustomerPlacedOrderDtoOutputOrderAddressBuilder? _address;
  CustomerPlacedOrderDtoOutputOrderAddressBuilder get address =>
      _$this._address ??= CustomerPlacedOrderDtoOutputOrderAddressBuilder();
  set address(CustomerPlacedOrderDtoOutputOrderAddressBuilder? address) =>
      _$this._address = address;

  CustomerPlacedOrderDtoOutputOrderBuilder() {
    CustomerPlacedOrderDtoOutputOrder._defaults(this);
  }

  CustomerPlacedOrderDtoOutputOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _placedAt = $v.placedAt;
      _restaurantId = $v.restaurantId;
      _currency = $v.currency;
      _money = $v.money.toBuilder();
      _lines = $v.lines.toBuilder();
      _payIn = $v.payIn;
      _note = $v.note;
      _estimate = $v.estimate.toBuilder();
      _address = $v.address.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlacedOrderDtoOutputOrder other) {
    _$v = other as _$CustomerPlacedOrderDtoOutputOrder;
  }

  @override
  void update(
    void Function(CustomerPlacedOrderDtoOutputOrderBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlacedOrderDtoOutputOrder build() => _build();

  _$CustomerPlacedOrderDtoOutputOrder _build() {
    _$CustomerPlacedOrderDtoOutputOrder _$result;
    try {
      _$result =
          _$v ??
          _$CustomerPlacedOrderDtoOutputOrder._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerPlacedOrderDtoOutputOrder',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CustomerPlacedOrderDtoOutputOrder',
              'number',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CustomerPlacedOrderDtoOutputOrder',
              'status',
            ),
            placedAt: BuiltValueNullFieldError.checkNotNull(
              placedAt,
              r'CustomerPlacedOrderDtoOutputOrder',
              'placedAt',
            ),
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'CustomerPlacedOrderDtoOutputOrder',
              'restaurantId',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CustomerPlacedOrderDtoOutputOrder',
              'currency',
            ),
            money: money.build(),
            lines: lines.build(),
            payIn: payIn,
            note: note,
            estimate: estimate.build(),
            address: address.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'money';
        money.build();
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'estimate';
        estimate.build();
        _$failedField = 'address';
        address.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerPlacedOrderDtoOutputOrder',
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
