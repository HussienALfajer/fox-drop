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
const CaptainCurrentOfferDtoOutputOfferStatusEnum
_$captainCurrentOfferDtoOutputOfferStatusEnum_withdrawn =
    const CaptainCurrentOfferDtoOutputOfferStatusEnum._('withdrawn');

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
    case 'withdrawn':
      return _$captainCurrentOfferDtoOutputOfferStatusEnum_withdrawn;
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
        _$captainCurrentOfferDtoOutputOfferStatusEnum_withdrawn,
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
  final AdminPickerDtoOutputCaptainsInnerCustodyLimit? pay;
  @override
  final AdminPickerDtoOutputCaptainsInnerCustodyLimit? peakBonus;
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
    this.peakBonus,
    required this.restaurant,
    required this.customer,
    required this.pickupPayment,
    required this.collect,
    required this.preparation,
    this.handover,
    required this.aboveMaxPickup,
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
        peakBonus == other.peakBonus &&
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
    _$hash = $jc(_$hash, peakBonus.hashCode);
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
    return (newBuiltValueToStringHelper(r'CaptainCurrentOfferDtoOutputOffer')
          ..add('id', id)
          ..add('status', status)
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('fromOperations', fromOperations)
          ..add('offeredAt', offeredAt)
          ..add('expiresAt', expiresAt)
          ..add('pay', pay)
          ..add('peakBonus', peakBonus)
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

  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? _pay;
  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder get pay =>
      _$this._pay ??= AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder();
  set pay(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? pay) =>
      _$this._pay = pay;

  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? _peakBonus;
  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder get peakBonus =>
      _$this._peakBonus ??=
          AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder();
  set peakBonus(
    AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? peakBonus,
  ) => _$this._peakBonus = peakBonus;

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
      _peakBonus = $v.peakBonus?.toBuilder();
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
            peakBonus: _peakBonus?.build(),
            restaurant: restaurant.build(),
            customer: customer.build(),
            pickupPayment: pickupPayment.build(),
            collect: collect.build(),
            preparation: preparation.build(),
            handover: _handover?.build(),
            aboveMaxPickup: BuiltValueNullFieldError.checkNotNull(
              aboveMaxPickup,
              r'CaptainCurrentOfferDtoOutputOffer',
              'aboveMaxPickup',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pay';
        _pay?.build();
        _$failedField = 'peakBonus';
        _peakBonus?.build();
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
