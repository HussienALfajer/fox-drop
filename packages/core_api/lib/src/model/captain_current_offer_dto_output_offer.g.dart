// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainCurrentOfferDtoOutputOfferStatusEnum
_$captainCurrentOfferDtoOutputOfferStatusEnum_open =
    const CaptainCurrentOfferDtoOutputOfferStatusEnum._('open');
const CaptainCurrentOfferDtoOutputOfferStatusEnum
_$captainCurrentOfferDtoOutputOfferStatusEnum_accepted =
    const CaptainCurrentOfferDtoOutputOfferStatusEnum._('accepted');
const CaptainCurrentOfferDtoOutputOfferStatusEnum
_$captainCurrentOfferDtoOutputOfferStatusEnum_declined =
    const CaptainCurrentOfferDtoOutputOfferStatusEnum._('declined');
const CaptainCurrentOfferDtoOutputOfferStatusEnum
_$captainCurrentOfferDtoOutputOfferStatusEnum_expired =
    const CaptainCurrentOfferDtoOutputOfferStatusEnum._('expired');

CaptainCurrentOfferDtoOutputOfferStatusEnum
_$captainCurrentOfferDtoOutputOfferStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$captainCurrentOfferDtoOutputOfferStatusEnum_open;
    case 'accepted':
      return _$captainCurrentOfferDtoOutputOfferStatusEnum_accepted;
    case 'declined':
      return _$captainCurrentOfferDtoOutputOfferStatusEnum_declined;
    case 'expired':
      return _$captainCurrentOfferDtoOutputOfferStatusEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainCurrentOfferDtoOutputOfferStatusEnum>
_$captainCurrentOfferDtoOutputOfferStatusEnumValues =
    BuiltSet<CaptainCurrentOfferDtoOutputOfferStatusEnum>(
      const <CaptainCurrentOfferDtoOutputOfferStatusEnum>[
        _$captainCurrentOfferDtoOutputOfferStatusEnum_open,
        _$captainCurrentOfferDtoOutputOfferStatusEnum_accepted,
        _$captainCurrentOfferDtoOutputOfferStatusEnum_declined,
        _$captainCurrentOfferDtoOutputOfferStatusEnum_expired,
      ],
    );

Serializer<CaptainCurrentOfferDtoOutputOfferStatusEnum>
_$captainCurrentOfferDtoOutputOfferStatusEnumSerializer =
    _$CaptainCurrentOfferDtoOutputOfferStatusEnumSerializer();

class _$CaptainCurrentOfferDtoOutputOfferStatusEnumSerializer
    implements
        PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainCurrentOfferDtoOutputOfferStatusEnum,
  ];
  @override
  final String wireName = 'CaptainCurrentOfferDtoOutputOfferStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainCurrentOfferDtoOutputOfferStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainCurrentOfferDtoOutputOfferStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainCurrentOfferDtoOutputOffer
    extends CaptainCurrentOfferDtoOutputOffer {
  @override
  final String id;
  @override
  final CaptainCurrentOfferDtoOutputOfferStatusEnum status;
  @override
  final String orderId;
  @override
  final String number;
  @override
  final bool fromOperations;
  @override
  final DateTime offeredAt;
  @override
  final DateTime expiresAt;
  @override
  final CaptainCurrentOfferDtoOutputOfferPay? pay;
  @override
  final CaptainCurrentOfferDtoOutputOfferRestaurant restaurant;
  @override
  final CaptainCurrentOfferDtoOutputOfferCustomer customer;
  @override
  final CaptainCurrentOfferDtoOutputOfferPickupPayment pickupPayment;
  @override
  final CaptainCurrentOfferDtoOutputOfferCollect collect;
  @override
  final CaptainCurrentOfferDtoOutputOfferPreparation preparation;

  factory _$CaptainCurrentOfferDtoOutputOffer([
    void Function(CaptainCurrentOfferDtoOutputOfferBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputOfferBuilder()..update(updates))._build();

  _$CaptainCurrentOfferDtoOutputOffer._({
    required this.id,
    required this.status,
    required this.orderId,
    required this.number,
    required this.fromOperations,
    required this.offeredAt,
    required this.expiresAt,
    this.pay,
    required this.restaurant,
    required this.customer,
    required this.pickupPayment,
    required this.collect,
    required this.preparation,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOffer rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOffer &&
        id == other.id &&
        status == other.status &&
        orderId == other.orderId &&
        number == other.number &&
        fromOperations == other.fromOperations &&
        offeredAt == other.offeredAt &&
        expiresAt == other.expiresAt &&
        pay == other.pay &&
        restaurant == other.restaurant &&
        customer == other.customer &&
        pickupPayment == other.pickupPayment &&
        collect == other.collect &&
        preparation == other.preparation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, fromOperations.hashCode);
    _$hash = $jc(_$hash, offeredAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, pay.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, pickupPayment.hashCode);
    _$hash = $jc(_$hash, collect.hashCode);
    _$hash = $jc(_$hash, preparation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCurrentOfferDtoOutputOffer')
          ..add('id', id)
          ..add('status', status)
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('fromOperations', fromOperations)
          ..add('offeredAt', offeredAt)
          ..add('expiresAt', expiresAt)
          ..add('pay', pay)
          ..add('restaurant', restaurant)
          ..add('customer', customer)
          ..add('pickupPayment', pickupPayment)
          ..add('collect', collect)
          ..add('preparation', preparation))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOffer,
          CaptainCurrentOfferDtoOutputOfferBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOffer? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CaptainCurrentOfferDtoOutputOfferStatusEnum? _status;
  CaptainCurrentOfferDtoOutputOfferStatusEnum? get status => _$this._status;
  set status(CaptainCurrentOfferDtoOutputOfferStatusEnum? status) =>
      _$this._status = status;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  bool? _fromOperations;
  bool? get fromOperations => _$this._fromOperations;
  set fromOperations(bool? fromOperations) =>
      _$this._fromOperations = fromOperations;

  DateTime? _offeredAt;
  DateTime? get offeredAt => _$this._offeredAt;
  set offeredAt(DateTime? offeredAt) => _$this._offeredAt = offeredAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CaptainCurrentOfferDtoOutputOfferPayBuilder? _pay;
  CaptainCurrentOfferDtoOutputOfferPayBuilder get pay =>
      _$this._pay ??= CaptainCurrentOfferDtoOutputOfferPayBuilder();
  set pay(CaptainCurrentOfferDtoOutputOfferPayBuilder? pay) =>
      _$this._pay = pay;

  CaptainCurrentOfferDtoOutputOfferRestaurantBuilder? _restaurant;
  CaptainCurrentOfferDtoOutputOfferRestaurantBuilder get restaurant =>
      _$this._restaurant ??=
          CaptainCurrentOfferDtoOutputOfferRestaurantBuilder();
  set restaurant(
    CaptainCurrentOfferDtoOutputOfferRestaurantBuilder? restaurant,
  ) => _$this._restaurant = restaurant;

  CaptainCurrentOfferDtoOutputOfferCustomerBuilder? _customer;
  CaptainCurrentOfferDtoOutputOfferCustomerBuilder get customer =>
      _$this._customer ??= CaptainCurrentOfferDtoOutputOfferCustomerBuilder();
  set customer(CaptainCurrentOfferDtoOutputOfferCustomerBuilder? customer) =>
      _$this._customer = customer;

  CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder? _pickupPayment;
  CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder get pickupPayment =>
      _$this._pickupPayment ??=
          CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder();
  set pickupPayment(
    CaptainCurrentOfferDtoOutputOfferPickupPaymentBuilder? pickupPayment,
  ) => _$this._pickupPayment = pickupPayment;

  CaptainCurrentOfferDtoOutputOfferCollectBuilder? _collect;
  CaptainCurrentOfferDtoOutputOfferCollectBuilder get collect =>
      _$this._collect ??= CaptainCurrentOfferDtoOutputOfferCollectBuilder();
  set collect(CaptainCurrentOfferDtoOutputOfferCollectBuilder? collect) =>
      _$this._collect = collect;

  CaptainCurrentOfferDtoOutputOfferPreparationBuilder? _preparation;
  CaptainCurrentOfferDtoOutputOfferPreparationBuilder get preparation =>
      _$this._preparation ??=
          CaptainCurrentOfferDtoOutputOfferPreparationBuilder();
  set preparation(
    CaptainCurrentOfferDtoOutputOfferPreparationBuilder? preparation,
  ) => _$this._preparation = preparation;

  CaptainCurrentOfferDtoOutputOfferBuilder() {
    CaptainCurrentOfferDtoOutputOffer._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _orderId = $v.orderId;
      _number = $v.number;
      _fromOperations = $v.fromOperations;
      _offeredAt = $v.offeredAt;
      _expiresAt = $v.expiresAt;
      _pay = $v.pay?.toBuilder();
      _restaurant = $v.restaurant.toBuilder();
      _customer = $v.customer.toBuilder();
      _pickupPayment = $v.pickupPayment.toBuilder();
      _collect = $v.collect.toBuilder();
      _preparation = $v.preparation.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOffer other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOffer;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOffer build() => _build();

  _$CaptainCurrentOfferDtoOutputOffer _build() {
    _$CaptainCurrentOfferDtoOutputOffer _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCurrentOfferDtoOutputOffer._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainCurrentOfferDtoOutputOffer',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CaptainCurrentOfferDtoOutputOffer',
              'status',
            ),
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'CaptainCurrentOfferDtoOutputOffer',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CaptainCurrentOfferDtoOutputOffer',
              'number',
            ),
            fromOperations: BuiltValueNullFieldError.checkNotNull(
              fromOperations,
              r'CaptainCurrentOfferDtoOutputOffer',
              'fromOperations',
            ),
            offeredAt: BuiltValueNullFieldError.checkNotNull(
              offeredAt,
              r'CaptainCurrentOfferDtoOutputOffer',
              'offeredAt',
            ),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'CaptainCurrentOfferDtoOutputOffer',
              'expiresAt',
            ),
            pay: _pay?.build(),
            restaurant: restaurant.build(),
            customer: customer.build(),
            pickupPayment: pickupPayment.build(),
            collect: collect.build(),
            preparation: preparation.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pay';
        _pay?.build();
        _$failedField = 'restaurant';
        restaurant.build();
        _$failedField = 'customer';
        customer.build();
        _$failedField = 'pickupPayment';
        pickupPayment.build();
        _$failedField = 'collect';
        collect.build();
        _$failedField = 'preparation';
        preparation.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCurrentOfferDtoOutputOffer',
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
