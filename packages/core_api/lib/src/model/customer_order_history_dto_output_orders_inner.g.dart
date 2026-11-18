// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_history_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_placed =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('placed');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('accepted');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_ready =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('ready');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('pickedUp');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('arrived');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('delivered');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('rejected');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('cancelled');
const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_failed =
    const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._('failed');

CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived;
    case 'delivered':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered;
    case 'rejected':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected;
    case 'cancelled':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled;
    case 'failed':
      return _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum>
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum>(
      const <CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum>[
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_placed,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_ready,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled,
        _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_failed,
      ],
    );

Serializer<CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum>
_$customerOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer =
    _$CustomerOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer();

class _$CustomerOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum
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
    CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerOrderHistoryDtoOutputOrdersInner
    extends CustomerOrderHistoryDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerRestaurant restaurant;
  @override
  final DateTime placedAt;
  @override
  final CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum status;
  @override
  final bool active;
  @override
  final CaptainWentOfflineDtoOutputHandIn? total;
  @override
  final bool redelivery;

  factory _$CustomerOrderHistoryDtoOutputOrdersInner([
    void Function(CustomerOrderHistoryDtoOutputOrdersInnerBuilder)? updates,
  ]) => (CustomerOrderHistoryDtoOutputOrdersInnerBuilder()..update(updates))
      ._build();

  _$CustomerOrderHistoryDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.restaurant,
    required this.placedAt,
    required this.status,
    required this.active,
    this.total,
    required this.redelivery,
  }) : super._();
  @override
  CustomerOrderHistoryDtoOutputOrdersInner rebuild(
    void Function(CustomerOrderHistoryDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderHistoryDtoOutputOrdersInnerBuilder toBuilder() =>
      CustomerOrderHistoryDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderHistoryDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        restaurant == other.restaurant &&
        placedAt == other.placedAt &&
        status == other.status &&
        active == other.active &&
        total == other.total &&
        redelivery == other.redelivery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, redelivery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerOrderHistoryDtoOutputOrdersInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('restaurant', restaurant)
          ..add('placedAt', placedAt)
          ..add('status', status)
          ..add('active', active)
          ..add('total', total)
          ..add('redelivery', redelivery))
        .toString();
  }
}

class CustomerOrderHistoryDtoOutputOrdersInnerBuilder
    implements
        Builder<
          CustomerOrderHistoryDtoOutputOrdersInner,
          CustomerOrderHistoryDtoOutputOrdersInnerBuilder
        > {
  _$CustomerOrderHistoryDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder? _restaurant;
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder get restaurant =>
      _$this._restaurant ??=
          CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder();
  set restaurant(
    CustomerActiveOrdersDtoOutputOrdersInnerRestaurantBuilder? restaurant,
  ) => _$this._restaurant = restaurant;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum? _status;
  CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum? get status =>
      _$this._status;
  set status(CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  CaptainWentOfflineDtoOutputHandInBuilder? _total;
  CaptainWentOfflineDtoOutputHandInBuilder get total =>
      _$this._total ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set total(CaptainWentOfflineDtoOutputHandInBuilder? total) =>
      _$this._total = total;

  bool? _redelivery;
  bool? get redelivery => _$this._redelivery;
  set redelivery(bool? redelivery) => _$this._redelivery = redelivery;

  CustomerOrderHistoryDtoOutputOrdersInnerBuilder() {
    CustomerOrderHistoryDtoOutputOrdersInner._defaults(this);
  }

  CustomerOrderHistoryDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _restaurant = $v.restaurant.toBuilder();
      _placedAt = $v.placedAt;
      _status = $v.status;
      _active = $v.active;
      _total = $v.total?.toBuilder();
      _redelivery = $v.redelivery;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerOrderHistoryDtoOutputOrdersInner other) {
    _$v = other as _$CustomerOrderHistoryDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(CustomerOrderHistoryDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderHistoryDtoOutputOrdersInner build() => _build();

  _$CustomerOrderHistoryDtoOutputOrdersInner _build() {
    _$CustomerOrderHistoryDtoOutputOrdersInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerOrderHistoryDtoOutputOrdersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerOrderHistoryDtoOutputOrdersInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CustomerOrderHistoryDtoOutputOrdersInner',
              'number',
            ),
            restaurant: restaurant.build(),
            placedAt: BuiltValueNullFieldError.checkNotNull(
              placedAt,
              r'CustomerOrderHistoryDtoOutputOrdersInner',
              'placedAt',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CustomerOrderHistoryDtoOutputOrdersInner',
              'status',
            ),
            active: BuiltValueNullFieldError.checkNotNull(
              active,
              r'CustomerOrderHistoryDtoOutputOrdersInner',
              'active',
            ),
            total: _total?.build(),
            redelivery: BuiltValueNullFieldError.checkNotNull(
              redelivery,
              r'CustomerOrderHistoryDtoOutputOrdersInner',
              'redelivery',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurant';
        restaurant.build();

        _$failedField = 'total';
        _total?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerOrderHistoryDtoOutputOrdersInner',
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
