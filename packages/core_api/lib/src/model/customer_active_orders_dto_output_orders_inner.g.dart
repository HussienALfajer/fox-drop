// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_placed =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('placed');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_accepted =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('accepted');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_ready =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('ready');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_pickedUp =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('pickedUp');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_arrived =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('arrived');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_delivered =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('delivered');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_rejected =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('rejected');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_cancelled =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('cancelled');
const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_failed =
    const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._('failed');

CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_arrived;
    case 'delivered':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_delivered;
    case 'rejected':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_rejected;
    case 'cancelled':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_cancelled;
    case 'failed':
      return _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum>
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum>(
      const <CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum>[
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_placed,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_accepted,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_ready,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_arrived,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_delivered,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_rejected,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_cancelled,
        _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_failed,
      ],
    );

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum>
_$customerActiveOrdersDtoOutputOrdersInnerStatusEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerStatusEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum
        > {
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
    CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInner
    extends CustomerActiveOrdersDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum status;
  @override
  final int version;
  @override
  final DateTime placedAt;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerCancellation? cancellation;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerRestaurant restaurant;
  @override
  final String currency;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerMoney money;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> equivalents;
  @override
  final BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner> lines;
  @override
  final String? payIn;
  @override
  final String? note;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerEstimate estimate;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerAddress address;

  factory _$CustomerActiveOrdersDtoOutputOrdersInner([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerBuilder)? updates,
  ]) => (CustomerActiveOrdersDtoOutputOrdersInnerBuilder()..update(updates))
      ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.status,
    required this.version,
    required this.placedAt,
    this.cancellation,
    required this.restaurant,
    required this.currency,
    required this.money,
    required this.equivalents,
    required this.lines,
    this.payIn,
    this.note,
    required this.estimate,
    required this.address,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInner rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        version == other.version &&
        placedAt == other.placedAt &&
        cancellation == other.cancellation &&
        restaurant == other.restaurant &&
        currency == other.currency &&
        money == other.money &&
        equivalents == other.equivalents &&
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
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, cancellation.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, money.hashCode);
    _$hash = $jc(_$hash, equivalents.hashCode);
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
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('version', version)
          ..add('placedAt', placedAt)
          ..add('cancellation', cancellation)
          ..add('restaurant', restaurant)
          ..add('currency', currency)
          ..add('money', money)
          ..add('equivalents', equivalents)
          ..add('lines', lines)
          ..add('payIn', payIn)
          ..add('note', note)
          ..add('estimate', estimate)
          ..add('address', address))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInner,
          CustomerActiveOrdersDtoOutputOrdersInnerBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum? _status;
  CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum? get status =>
      _$this._status;
  set status(CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder? _cancellation;
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder
  get cancellation => _$this._cancellation ??=
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder();
  set cancellation(
    CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder? cancellation,
  ) => _$this._cancellation = cancellation;

  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder? _restaurant;
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder get restaurant =>
      _$this._restaurant ??=
          CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder();
  set restaurant(
    CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder? restaurant,
  ) => _$this._restaurant = restaurant;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder? _money;
  CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder get money =>
      _$this._money ??= CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder();
  set money(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder? money) =>
      _$this._money = money;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _equivalents;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get equivalents =>
      _$this._equivalents ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set equivalents(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? equivalents,
  ) => _$this._equivalents = equivalents;

  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>? _lines;
  ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>();
  set lines(
    ListBuilder<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner>? lines,
  ) => _$this._lines = lines;

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

  CustomerActiveOrdersDtoOutputOrdersInnerBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInner._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _version = $v.version;
      _placedAt = $v.placedAt;
      _cancellation = $v.cancellation?.toBuilder();
      _restaurant = $v.restaurant.toBuilder();
      _currency = $v.currency;
      _money = $v.money.toBuilder();
      _equivalents = $v.equivalents.toBuilder();
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
  void replace(CustomerActiveOrdersDtoOutputOrdersInner other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInner build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInner _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerActiveOrdersDtoOutputOrdersInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CustomerActiveOrdersDtoOutputOrdersInner',
              'number',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CustomerActiveOrdersDtoOutputOrdersInner',
              'status',
            ),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'CustomerActiveOrdersDtoOutputOrdersInner',
              'version',
            ),
            placedAt: BuiltValueNullFieldError.checkNotNull(
              placedAt,
              r'CustomerActiveOrdersDtoOutputOrdersInner',
              'placedAt',
            ),
            cancellation: _cancellation?.build(),
            restaurant: restaurant.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'CustomerActiveOrdersDtoOutputOrdersInner',
              'currency',
            ),
            money: money.build(),
            equivalents: equivalents.build(),
            lines: lines.build(),
            payIn: payIn,
            note: note,
            estimate: estimate.build(),
            address: address.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cancellation';
        _cancellation?.build();
        _$failedField = 'restaurant';
        restaurant.build();

        _$failedField = 'money';
        money.build();
        _$failedField = 'equivalents';
        equivalents.build();
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'estimate';
        estimate.build();
        _$failedField = 'address';
        address.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInner',
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
