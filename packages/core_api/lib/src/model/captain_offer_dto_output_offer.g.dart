// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_offer_dto_output_offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainOfferDtoOutputOfferStatusEnum
_$captainOfferDtoOutputOfferStatusEnum_open =
    const CaptainOfferDtoOutputOfferStatusEnum._('open');
const CaptainOfferDtoOutputOfferStatusEnum
_$captainOfferDtoOutputOfferStatusEnum_accepted =
    const CaptainOfferDtoOutputOfferStatusEnum._('accepted');
const CaptainOfferDtoOutputOfferStatusEnum
_$captainOfferDtoOutputOfferStatusEnum_declined =
    const CaptainOfferDtoOutputOfferStatusEnum._('declined');
const CaptainOfferDtoOutputOfferStatusEnum
_$captainOfferDtoOutputOfferStatusEnum_expired =
    const CaptainOfferDtoOutputOfferStatusEnum._('expired');
const CaptainOfferDtoOutputOfferStatusEnum
_$captainOfferDtoOutputOfferStatusEnum_withdrawn =
    const CaptainOfferDtoOutputOfferStatusEnum._('withdrawn');

CaptainOfferDtoOutputOfferStatusEnum
_$captainOfferDtoOutputOfferStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$captainOfferDtoOutputOfferStatusEnum_open;
    case 'accepted':
      return _$captainOfferDtoOutputOfferStatusEnum_accepted;
    case 'declined':
      return _$captainOfferDtoOutputOfferStatusEnum_declined;
    case 'expired':
      return _$captainOfferDtoOutputOfferStatusEnum_expired;
    case 'withdrawn':
      return _$captainOfferDtoOutputOfferStatusEnum_withdrawn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainOfferDtoOutputOfferStatusEnum>
_$captainOfferDtoOutputOfferStatusEnumValues =
    BuiltSet<CaptainOfferDtoOutputOfferStatusEnum>(
      const <CaptainOfferDtoOutputOfferStatusEnum>[
        _$captainOfferDtoOutputOfferStatusEnum_open,
        _$captainOfferDtoOutputOfferStatusEnum_accepted,
        _$captainOfferDtoOutputOfferStatusEnum_declined,
        _$captainOfferDtoOutputOfferStatusEnum_expired,
        _$captainOfferDtoOutputOfferStatusEnum_withdrawn,
      ],
    );

Serializer<CaptainOfferDtoOutputOfferStatusEnum>
_$captainOfferDtoOutputOfferStatusEnumSerializer =
    _$CaptainOfferDtoOutputOfferStatusEnumSerializer();

class _$CaptainOfferDtoOutputOfferStatusEnumSerializer
    implements PrimitiveSerializer<CaptainOfferDtoOutputOfferStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
    'withdrawn': 'withdrawn',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
    'withdrawn': 'withdrawn',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainOfferDtoOutputOfferStatusEnum,
  ];
  @override
  final String wireName = 'CaptainOfferDtoOutputOfferStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainOfferDtoOutputOfferStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainOfferDtoOutputOfferStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainOfferDtoOutputOfferStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainOfferDtoOutputOffer extends CaptainOfferDtoOutputOffer {
  @override
  final String id;
  @override
  final CaptainOfferDtoOutputOfferStatusEnum status;
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
  final AdminPickerDtoOutputCaptainsInnerCustodyLimit? pay;
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
  @override
  final CaptainCurrentOfferDtoOutputOfferHandover? handover;
  @override
  final bool aboveMaxPickup;

  factory _$CaptainOfferDtoOutputOffer([
    void Function(CaptainOfferDtoOutputOfferBuilder)? updates,
  ]) => (CaptainOfferDtoOutputOfferBuilder()..update(updates))._build();

  _$CaptainOfferDtoOutputOffer._({
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
    this.handover,
    required this.aboveMaxPickup,
  }) : super._();
  @override
  CaptainOfferDtoOutputOffer rebuild(
    void Function(CaptainOfferDtoOutputOfferBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOfferDtoOutputOfferBuilder toBuilder() =>
      CaptainOfferDtoOutputOfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOfferDtoOutputOffer &&
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
        preparation == other.preparation &&
        handover == other.handover &&
        aboveMaxPickup == other.aboveMaxPickup;
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
    _$hash = $jc(_$hash, handover.hashCode);
    _$hash = $jc(_$hash, aboveMaxPickup.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainOfferDtoOutputOffer')
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
          ..add('preparation', preparation)
          ..add('handover', handover)
          ..add('aboveMaxPickup', aboveMaxPickup))
        .toString();
  }
}

class CaptainOfferDtoOutputOfferBuilder
    implements
        Builder<CaptainOfferDtoOutputOffer, CaptainOfferDtoOutputOfferBuilder> {
  _$CaptainOfferDtoOutputOffer? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CaptainOfferDtoOutputOfferStatusEnum? _status;
  CaptainOfferDtoOutputOfferStatusEnum? get status => _$this._status;
  set status(CaptainOfferDtoOutputOfferStatusEnum? status) =>
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

  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? _pay;
  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder get pay =>
      _$this._pay ??= AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder();
  set pay(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? pay) =>
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

  CaptainCurrentOfferDtoOutputOfferHandoverBuilder? _handover;
  CaptainCurrentOfferDtoOutputOfferHandoverBuilder get handover =>
      _$this._handover ??= CaptainCurrentOfferDtoOutputOfferHandoverBuilder();
  set handover(CaptainCurrentOfferDtoOutputOfferHandoverBuilder? handover) =>
      _$this._handover = handover;

  bool? _aboveMaxPickup;
  bool? get aboveMaxPickup => _$this._aboveMaxPickup;
  set aboveMaxPickup(bool? aboveMaxPickup) =>
      _$this._aboveMaxPickup = aboveMaxPickup;

  CaptainOfferDtoOutputOfferBuilder() {
    CaptainOfferDtoOutputOffer._defaults(this);
  }

  CaptainOfferDtoOutputOfferBuilder get _$this {
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
      _handover = $v.handover?.toBuilder();
      _aboveMaxPickup = $v.aboveMaxPickup;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOfferDtoOutputOffer other) {
    _$v = other as _$CaptainOfferDtoOutputOffer;
  }

  @override
  void update(void Function(CaptainOfferDtoOutputOfferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOfferDtoOutputOffer build() => _build();

  _$CaptainOfferDtoOutputOffer _build() {
    _$CaptainOfferDtoOutputOffer _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOfferDtoOutputOffer._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CaptainOfferDtoOutputOffer',
              'id',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CaptainOfferDtoOutputOffer',
              'status',
            ),
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'CaptainOfferDtoOutputOffer',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CaptainOfferDtoOutputOffer',
              'number',
            ),
            fromOperations: BuiltValueNullFieldError.checkNotNull(
              fromOperations,
              r'CaptainOfferDtoOutputOffer',
              'fromOperations',
            ),
            offeredAt: BuiltValueNullFieldError.checkNotNull(
              offeredAt,
              r'CaptainOfferDtoOutputOffer',
              'offeredAt',
            ),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'CaptainOfferDtoOutputOffer',
              'expiresAt',
            ),
            pay: _pay?.build(),
            restaurant: restaurant.build(),
            customer: customer.build(),
            pickupPayment: pickupPayment.build(),
            collect: collect.build(),
            preparation: preparation.build(),
            handover: _handover?.build(),
            aboveMaxPickup: BuiltValueNullFieldError.checkNotNull(
              aboveMaxPickup,
              r'CaptainOfferDtoOutputOffer',
              'aboveMaxPickup',
            ),
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
        _$failedField = 'handover';
        _handover?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOfferDtoOutputOffer',
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
