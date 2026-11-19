// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_orders_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_placed =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('placed');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_accepted =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('accepted');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_ready =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('ready');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('pickedUp');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_arrived =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('arrived');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_delivered =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('delivered');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_rejected =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('rejected');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_cancelled =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('cancelled');
const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_failed =
    const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._('failed');

AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_arrived;
    case 'delivered':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_delivered;
    case 'rejected':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_rejected;
    case 'cancelled':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_cancelled;
    case 'failed':
      return _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum>
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum>(
      const <AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum>[
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_placed,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_accepted,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_ready,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_arrived,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_delivered,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_rejected,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_cancelled,
        _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_failed,
      ],
    );

Serializer<AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum>
_$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnumSerializer =
    _$AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnumSerializer();

class _$AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum
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
    AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantOrdersDtoOutputOrdersInner
    extends AdminRestaurantOrdersDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final DateTime placedAt;
  @override
  final AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum status;
  @override
  final String total;
  @override
  final String currency;
  @override
  final bool testOrder;
  @override
  final bool redelivery;

  factory _$AdminRestaurantOrdersDtoOutputOrdersInner([
    void Function(AdminRestaurantOrdersDtoOutputOrdersInnerBuilder)? updates,
  ]) => (AdminRestaurantOrdersDtoOutputOrdersInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantOrdersDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.placedAt,
    required this.status,
    required this.total,
    required this.currency,
    required this.testOrder,
    required this.redelivery,
  }) : super._();
  @override
  AdminRestaurantOrdersDtoOutputOrdersInner rebuild(
    void Function(AdminRestaurantOrdersDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantOrdersDtoOutputOrdersInnerBuilder toBuilder() =>
      AdminRestaurantOrdersDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantOrdersDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        placedAt == other.placedAt &&
        status == other.status &&
        total == other.total &&
        currency == other.currency &&
        testOrder == other.testOrder &&
        redelivery == other.redelivery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, testOrder.hashCode);
    _$hash = $jc(_$hash, redelivery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('placedAt', placedAt)
          ..add('status', status)
          ..add('total', total)
          ..add('currency', currency)
          ..add('testOrder', testOrder)
          ..add('redelivery', redelivery))
        .toString();
  }
}

class AdminRestaurantOrdersDtoOutputOrdersInnerBuilder
    implements
        Builder<
          AdminRestaurantOrdersDtoOutputOrdersInner,
          AdminRestaurantOrdersDtoOutputOrdersInnerBuilder
        > {
  _$AdminRestaurantOrdersDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum? _status;
  AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  bool? _testOrder;
  bool? get testOrder => _$this._testOrder;
  set testOrder(bool? testOrder) => _$this._testOrder = testOrder;

  bool? _redelivery;
  bool? get redelivery => _$this._redelivery;
  set redelivery(bool? redelivery) => _$this._redelivery = redelivery;

  AdminRestaurantOrdersDtoOutputOrdersInnerBuilder() {
    AdminRestaurantOrdersDtoOutputOrdersInner._defaults(this);
  }

  AdminRestaurantOrdersDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _placedAt = $v.placedAt;
      _status = $v.status;
      _total = $v.total;
      _currency = $v.currency;
      _testOrder = $v.testOrder;
      _redelivery = $v.redelivery;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantOrdersDtoOutputOrdersInner other) {
    _$v = other as _$AdminRestaurantOrdersDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(AdminRestaurantOrdersDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantOrdersDtoOutputOrdersInner build() => _build();

  _$AdminRestaurantOrdersDtoOutputOrdersInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantOrdersDtoOutputOrdersInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'number',
          ),
          placedAt: BuiltValueNullFieldError.checkNotNull(
            placedAt,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'placedAt',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'status',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'total',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'currency',
          ),
          testOrder: BuiltValueNullFieldError.checkNotNull(
            testOrder,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'testOrder',
          ),
          redelivery: BuiltValueNullFieldError.checkNotNull(
            redelivery,
            r'AdminRestaurantOrdersDtoOutputOrdersInner',
            'redelivery',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
