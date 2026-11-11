// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_dto_output_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_placed =
    const CustomerOrderDtoOutputOrderStatusEnum._('placed');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_accepted =
    const CustomerOrderDtoOutputOrderStatusEnum._('accepted');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_ready =
    const CustomerOrderDtoOutputOrderStatusEnum._('ready');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_pickedUp =
    const CustomerOrderDtoOutputOrderStatusEnum._('pickedUp');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_arrived =
    const CustomerOrderDtoOutputOrderStatusEnum._('arrived');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_delivered =
    const CustomerOrderDtoOutputOrderStatusEnum._('delivered');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_rejected =
    const CustomerOrderDtoOutputOrderStatusEnum._('rejected');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_cancelled =
    const CustomerOrderDtoOutputOrderStatusEnum._('cancelled');
const CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnum_failed =
    const CustomerOrderDtoOutputOrderStatusEnum._('failed');

CustomerOrderDtoOutputOrderStatusEnum
_$customerOrderDtoOutputOrderStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$customerOrderDtoOutputOrderStatusEnum_placed;
    case 'accepted':
      return _$customerOrderDtoOutputOrderStatusEnum_accepted;
    case 'ready':
      return _$customerOrderDtoOutputOrderStatusEnum_ready;
    case 'pickedUp':
      return _$customerOrderDtoOutputOrderStatusEnum_pickedUp;
    case 'arrived':
      return _$customerOrderDtoOutputOrderStatusEnum_arrived;
    case 'delivered':
      return _$customerOrderDtoOutputOrderStatusEnum_delivered;
    case 'rejected':
      return _$customerOrderDtoOutputOrderStatusEnum_rejected;
    case 'cancelled':
      return _$customerOrderDtoOutputOrderStatusEnum_cancelled;
    case 'failed':
      return _$customerOrderDtoOutputOrderStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerOrderDtoOutputOrderStatusEnum>
_$customerOrderDtoOutputOrderStatusEnumValues =
    BuiltSet<CustomerOrderDtoOutputOrderStatusEnum>(
      const <CustomerOrderDtoOutputOrderStatusEnum>[
        _$customerOrderDtoOutputOrderStatusEnum_placed,
        _$customerOrderDtoOutputOrderStatusEnum_accepted,
        _$customerOrderDtoOutputOrderStatusEnum_ready,
        _$customerOrderDtoOutputOrderStatusEnum_pickedUp,
        _$customerOrderDtoOutputOrderStatusEnum_arrived,
        _$customerOrderDtoOutputOrderStatusEnum_delivered,
        _$customerOrderDtoOutputOrderStatusEnum_rejected,
        _$customerOrderDtoOutputOrderStatusEnum_cancelled,
        _$customerOrderDtoOutputOrderStatusEnum_failed,
      ],
    );

Serializer<CustomerOrderDtoOutputOrderStatusEnum>
_$customerOrderDtoOutputOrderStatusEnumSerializer =
    _$CustomerOrderDtoOutputOrderStatusEnumSerializer();

class _$CustomerOrderDtoOutputOrderStatusEnumSerializer
    implements PrimitiveSerializer<CustomerOrderDtoOutputOrderStatusEnum> {
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
    CustomerOrderDtoOutputOrderStatusEnum,
  ];
  @override
  final String wireName = 'CustomerOrderDtoOutputOrderStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderDtoOutputOrderStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerOrderDtoOutputOrderStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerOrderDtoOutputOrderStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerOrderDtoOutputOrder extends CustomerOrderDtoOutputOrder {
  @override
  final String id;
  @override
  final String number;
  @override
  final CustomerOrderDtoOutputOrderStatusEnum status;
  @override
  final int version;
  @override
  final DateTime placedAt;
  @override
  final DateTime? promisedAt;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerDoorPing? doorPing;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerItemReport? itemReport;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerCancellation? cancellation;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerRejection? rejection;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerOutcome? outcome;
  @override
  final CustomerOrderDtoOutputOrderDelivery? delivery;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerRestaurant restaurant;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerCaptain? captain;
  @override
  final String currency;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerMoney money;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> equivalents;
  @override
  final BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner> lines;
  @override
  final BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner>
  removedLines;
  @override
  final bool edited;
  @override
  final String? payIn;
  @override
  final String? note;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerEstimate estimate;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerAddress address;

  factory _$CustomerOrderDtoOutputOrder([
    void Function(CustomerOrderDtoOutputOrderBuilder)? updates,
  ]) => (CustomerOrderDtoOutputOrderBuilder()..update(updates))._build();

  _$CustomerOrderDtoOutputOrder._({
    required this.id,
    required this.number,
    required this.status,
    required this.version,
    required this.placedAt,
    this.promisedAt,
    this.doorPing,
    this.itemReport,
    this.cancellation,
    this.rejection,
    this.outcome,
    this.delivery,
    required this.restaurant,
    this.captain,
    required this.currency,
    required this.money,
    required this.equivalents,
    required this.lines,
    required this.removedLines,
    required this.edited,
    this.payIn,
    this.note,
    required this.estimate,
    required this.address,
  }) : super._();
  @override
  CustomerOrderDtoOutputOrder rebuild(
    void Function(CustomerOrderDtoOutputOrderBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderDtoOutputOrderBuilder toBuilder() =>
      CustomerOrderDtoOutputOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderDtoOutputOrder &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        version == other.version &&
        placedAt == other.placedAt &&
        promisedAt == other.promisedAt &&
        doorPing == other.doorPing &&
        itemReport == other.itemReport &&
        cancellation == other.cancellation &&
        rejection == other.rejection &&
        outcome == other.outcome &&
        delivery == other.delivery &&
        restaurant == other.restaurant &&
        captain == other.captain &&
        currency == other.currency &&
        money == other.money &&
        equivalents == other.equivalents &&
        lines == other.lines &&
        removedLines == other.removedLines &&
        edited == other.edited &&
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
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, promisedAt.hashCode);
    _$hash = $jc(_$hash, doorPing.hashCode);
    _$hash = $jc(_$hash, itemReport.hashCode);
    _$hash = $jc(_$hash, cancellation.hashCode);
    _$hash = $jc(_$hash, rejection.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, money.hashCode);
    _$hash = $jc(_$hash, equivalents.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, removedLines.hashCode);
    _$hash = $jc(_$hash, edited.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerOrderDtoOutputOrder')
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('version', version)
          ..add('placedAt', placedAt)
          ..add('promisedAt', promisedAt)
          ..add('doorPing', doorPing)
          ..add('itemReport', itemReport)
          ..add('cancellation', cancellation)
          ..add('rejection', rejection)
          ..add('outcome', outcome)
          ..add('delivery', delivery)
          ..add('restaurant', restaurant)
          ..add('captain', captain)
          ..add('currency', currency)
          ..add('money', money)
          ..add('equivalents', equivalents)
          ..add('lines', lines)
          ..add('removedLines', removedLines)
          ..add('edited', edited)
          ..add('payIn', payIn)
          ..add('note', note)
          ..add('estimate', estimate)
          ..add('address', address))
        .toString();
  }
}

class CustomerOrderDtoOutputOrderBuilder
    implements
        Builder<
          CustomerOrderDtoOutputOrder,
          CustomerOrderDtoOutputOrderBuilder
        > {
  _$CustomerOrderDtoOutputOrder? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerOrderDtoOutputOrderStatusEnum? _status;
  CustomerOrderDtoOutputOrderStatusEnum? get status => _$this._status;
  set status(CustomerOrderDtoOutputOrderStatusEnum? status) =>
      _$this._status = status;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  DateTime? _promisedAt;
  DateTime? get promisedAt => _$this._promisedAt;
  set promisedAt(DateTime? promisedAt) => _$this._promisedAt = promisedAt;

  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder? _doorPing;
  CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder get doorPing =>
      _$this._doorPing ??=
          CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder();
  set doorPing(
    CustomerActiveOrdersDtoOutputOrdersInnerDoorPingBuilder? doorPing,
  ) => _$this._doorPing = doorPing;

  CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder? _itemReport;
  CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder get itemReport =>
      _$this._itemReport ??=
          CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder();
  set itemReport(
    CustomerActiveOrdersDtoOutputOrdersInnerItemReportBuilder? itemReport,
  ) => _$this._itemReport = itemReport;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder? _cancellation;
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder
  get cancellation => _$this._cancellation ??=
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder();
  set cancellation(
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder? cancellation,
  ) => _$this._cancellation = cancellation;

  CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder? _rejection;
  CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder get rejection =>
      _$this._rejection ??=
          CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder();
  set rejection(
    CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder? rejection,
  ) => _$this._rejection = rejection;

  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder? _outcome;
  CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder get outcome =>
      _$this._outcome ??=
          CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder();
  set outcome(
    CustomerActiveOrdersDtoOutputOrdersInnerOutcomeBuilder? outcome,
  ) => _$this._outcome = outcome;

  CustomerOrderDtoOutputOrderDeliveryBuilder? _delivery;
  CustomerOrderDtoOutputOrderDeliveryBuilder get delivery =>
      _$this._delivery ??= CustomerOrderDtoOutputOrderDeliveryBuilder();
  set delivery(CustomerOrderDtoOutputOrderDeliveryBuilder? delivery) =>
      _$this._delivery = delivery;

  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder? _restaurant;
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder get restaurant =>
      _$this._restaurant ??=
          CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder();
  set restaurant(
    CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder? restaurant,
  ) => _$this._restaurant = restaurant;

  CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder? _captain;
  CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder get captain =>
      _$this._captain ??=
          CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder();
  set captain(
    CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder? captain,
  ) => _$this._captain = captain;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder? _money;
  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder get money =>
      _$this._money ??= CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder();
  set money(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder? money) =>
      _$this._money = money;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _equivalents;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get equivalents =>
      _$this._equivalents ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set equivalents(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? equivalents,
  ) => _$this._equivalents = equivalents;

  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>? _lines;
  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>();
  set lines(
    ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>? lines,
  ) => _$this._lines = lines;

  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner>?
  _removedLines;
  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner>
  get removedLines => _$this._removedLines ??=
      ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner>();
  set removedLines(
    ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner>?
    removedLines,
  ) => _$this._removedLines = removedLines;

  bool? _edited;
  bool? get edited => _$this._edited;
  set edited(bool? edited) => _$this._edited = edited;

  String? _payIn;
  String? get payIn => _$this._payIn;
  set payIn(String? payIn) => _$this._payIn = payIn;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder? _estimate;
  CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder get estimate =>
      _$this._estimate ??=
          CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder();
  set estimate(
    CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder? estimate,
  ) => _$this._estimate = estimate;

  CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder? _address;
  CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder get address =>
      _$this._address ??=
          CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder();
  set address(
    CustomerActiveOrdersDtoOutputOrdersInnerAddressBuilder? address,
  ) => _$this._address = address;

  CustomerOrderDtoOutputOrderBuilder() {
    CustomerOrderDtoOutputOrder._defaults(this);
  }

  CustomerOrderDtoOutputOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _version = $v.version;
      _placedAt = $v.placedAt;
      _promisedAt = $v.promisedAt;
      _doorPing = $v.doorPing?.toBuilder();
      _itemReport = $v.itemReport?.toBuilder();
      _cancellation = $v.cancellation?.toBuilder();
      _rejection = $v.rejection?.toBuilder();
      _outcome = $v.outcome?.toBuilder();
      _delivery = $v.delivery?.toBuilder();
      _restaurant = $v.restaurant.toBuilder();
      _captain = $v.captain?.toBuilder();
      _currency = $v.currency;
      _money = $v.money.toBuilder();
      _equivalents = $v.equivalents.toBuilder();
      _lines = $v.lines.toBuilder();
      _removedLines = $v.removedLines.toBuilder();
      _edited = $v.edited;
      _payIn = $v.payIn;
      _note = $v.note;
      _estimate = $v.estimate.toBuilder();
      _address = $v.address.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerOrderDtoOutputOrder other) {
    _$v = other as _$CustomerOrderDtoOutputOrder;
  }

  @override
  void update(void Function(CustomerOrderDtoOutputOrderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderDtoOutputOrder build() => _build();

  _$CustomerOrderDtoOutputOrder _build() {
    _$CustomerOrderDtoOutputOrder _$result;
    try {
      _$result =
          _$v ??
          _$CustomerOrderDtoOutputOrder._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerOrderDtoOutputOrder',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CustomerOrderDtoOutputOrder',
              'number',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CustomerOrderDtoOutputOrder',
              'status',
            ),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'CustomerOrderDtoOutputOrder',
              'version',
            ),
            placedAt: BuiltValueNullFieldError.checkNotNull(
              placedAt,
              r'CustomerOrderDtoOutputOrder',
              'placedAt',
            ),
            promisedAt: promisedAt,
            doorPing: _doorPing?.build(),
            itemReport: _itemReport?.build(),
            cancellation: _cancellation?.build(),
            rejection: _rejection?.build(),
            outcome: _outcome?.build(),
            delivery: _delivery?.build(),
            restaurant: restaurant.build(),
            captain: _captain?.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CustomerOrderDtoOutputOrder',
              'currency',
            ),
            money: money.build(),
            equivalents: equivalents.build(),
            lines: lines.build(),
            removedLines: removedLines.build(),
            edited: BuiltValueNullFieldError.checkNotNull(
              edited,
              r'CustomerOrderDtoOutputOrder',
              'edited',
            ),
            payIn: payIn,
            note: note,
            estimate: estimate.build(),
            address: address.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'doorPing';
        _doorPing?.build();
        _$failedField = 'itemReport';
        _itemReport?.build();
        _$failedField = 'cancellation';
        _cancellation?.build();
        _$failedField = 'rejection';
        _rejection?.build();
        _$failedField = 'outcome';
        _outcome?.build();
        _$failedField = 'delivery';
        _delivery?.build();
        _$failedField = 'restaurant';
        restaurant.build();
        _$failedField = 'captain';
        _captain?.build();

        _$failedField = 'money';
        money.build();
        _$failedField = 'equivalents';
        equivalents.build();
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'removedLines';
        removedLines.build();

        _$failedField = 'estimate';
        estimate.build();
        _$failedField = 'address';
        address.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerOrderDtoOutputOrder',
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
