// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_history_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_placed =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('placed');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('accepted');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_ready =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('ready');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('pickedUp');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('arrived');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('delivered');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('rejected');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('cancelled');
const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_failed =
    const MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum._('failed');

MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived;
    case 'delivered':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered;
    case 'rejected':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected;
    case 'cancelled':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled;
    case 'failed':
      return _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum>
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum>(
      const <MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum>[
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_placed,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_ready,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled,
        _$merchantOrderHistoryDtoOutputOrdersInnerStatusEnum_failed,
      ],
    );

Serializer<MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum>
_$merchantOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer =
    _$MerchantOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer();

class _$MerchantOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum
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
    MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrderHistoryDtoOutputOrdersInner
    extends MerchantOrderHistoryDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final DateTime placedAt;
  @override
  final Date day;
  @override
  final MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum status;
  @override
  final bool testOrder;
  @override
  final bool redelivery;
  @override
  final int itemCount;
  @override
  final String currency;
  @override
  final String itemsValue;
  @override
  final MerchantOrderHistoryDtoOutputOrdersInnerOwner? owner;

  factory _$MerchantOrderHistoryDtoOutputOrdersInner([
    void Function(MerchantOrderHistoryDtoOutputOrdersInnerBuilder)? updates,
  ]) => (MerchantOrderHistoryDtoOutputOrdersInnerBuilder()..update(updates))
      ._build();

  _$MerchantOrderHistoryDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.placedAt,
    required this.day,
    required this.status,
    required this.testOrder,
    required this.redelivery,
    required this.itemCount,
    required this.currency,
    required this.itemsValue,
    this.owner,
  }) : super._();
  @override
  MerchantOrderHistoryDtoOutputOrdersInner rebuild(
    void Function(MerchantOrderHistoryDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderHistoryDtoOutputOrdersInnerBuilder toBuilder() =>
      MerchantOrderHistoryDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderHistoryDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        placedAt == other.placedAt &&
        day == other.day &&
        status == other.status &&
        testOrder == other.testOrder &&
        redelivery == other.redelivery &&
        itemCount == other.itemCount &&
        currency == other.currency &&
        itemsValue == other.itemsValue &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, testOrder.hashCode);
    _$hash = $jc(_$hash, redelivery.hashCode);
    _$hash = $jc(_$hash, itemCount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrderHistoryDtoOutputOrdersInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('placedAt', placedAt)
          ..add('day', day)
          ..add('status', status)
          ..add('testOrder', testOrder)
          ..add('redelivery', redelivery)
          ..add('itemCount', itemCount)
          ..add('currency', currency)
          ..add('itemsValue', itemsValue)
          ..add('owner', owner))
        .toString();
  }
}

class MerchantOrderHistoryDtoOutputOrdersInnerBuilder
    implements
        Builder<
          MerchantOrderHistoryDtoOutputOrdersInner,
          MerchantOrderHistoryDtoOutputOrdersInnerBuilder
        > {
  _$MerchantOrderHistoryDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  Date? _day;
  Date? get day => _$this._day;
  set day(Date? day) => _$this._day = day;

  MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum? _status;
  MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum? get status =>
      _$this._status;
  set status(MerchantOrderHistoryDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  bool? _testOrder;
  bool? get testOrder => _$this._testOrder;
  set testOrder(bool? testOrder) => _$this._testOrder = testOrder;

  bool? _redelivery;
  bool? get redelivery => _$this._redelivery;
  set redelivery(bool? redelivery) => _$this._redelivery = redelivery;

  int? _itemCount;
  int? get itemCount => _$this._itemCount;
  set itemCount(int? itemCount) => _$this._itemCount = itemCount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder? _owner;
  MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder get owner =>
      _$this._owner ??= MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder();
  set owner(MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder? owner) =>
      _$this._owner = owner;

  MerchantOrderHistoryDtoOutputOrdersInnerBuilder() {
    MerchantOrderHistoryDtoOutputOrdersInner._defaults(this);
  }

  MerchantOrderHistoryDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _placedAt = $v.placedAt;
      _day = $v.day;
      _status = $v.status;
      _testOrder = $v.testOrder;
      _redelivery = $v.redelivery;
      _itemCount = $v.itemCount;
      _currency = $v.currency;
      _itemsValue = $v.itemsValue;
      _owner = $v.owner?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderHistoryDtoOutputOrdersInner other) {
    _$v = other as _$MerchantOrderHistoryDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(MerchantOrderHistoryDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderHistoryDtoOutputOrdersInner build() => _build();

  _$MerchantOrderHistoryDtoOutputOrdersInner _build() {
    _$MerchantOrderHistoryDtoOutputOrdersInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrderHistoryDtoOutputOrdersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'number',
            ),
            placedAt: BuiltValueNullFieldError.checkNotNull(
              placedAt,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'placedAt',
            ),
            day: BuiltValueNullFieldError.checkNotNull(
              day,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'day',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'status',
            ),
            testOrder: BuiltValueNullFieldError.checkNotNull(
              testOrder,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'testOrder',
            ),
            redelivery: BuiltValueNullFieldError.checkNotNull(
              redelivery,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'redelivery',
            ),
            itemCount: BuiltValueNullFieldError.checkNotNull(
              itemCount,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'itemCount',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'currency',
            ),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'MerchantOrderHistoryDtoOutputOrdersInner',
              'itemsValue',
            ),
            owner: _owner?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        _owner?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrderHistoryDtoOutputOrdersInner',
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
