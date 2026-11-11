// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_ended.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainActiveOrderDtoOutputEndedOutcomeEnum
_$captainActiveOrderDtoOutputEndedOutcomeEnum_free =
    const CaptainActiveOrderDtoOutputEndedOutcomeEnum._('free');
const CaptainActiveOrderDtoOutputEndedOutcomeEnum
_$captainActiveOrderDtoOutputEndedOutcomeEnum_fake =
    const CaptainActiveOrderDtoOutputEndedOutcomeEnum._('fake');
const CaptainActiveOrderDtoOutputEndedOutcomeEnum
_$captainActiveOrderDtoOutputEndedOutcomeEnum_damaged =
    const CaptainActiveOrderDtoOutputEndedOutcomeEnum._('damaged');
const CaptainActiveOrderDtoOutputEndedOutcomeEnum
_$captainActiveOrderDtoOutputEndedOutcomeEnum_wrongRefused =
    const CaptainActiveOrderDtoOutputEndedOutcomeEnum._('wrongRefused');
const CaptainActiveOrderDtoOutputEndedOutcomeEnum
_$captainActiveOrderDtoOutputEndedOutcomeEnum_failedOther =
    const CaptainActiveOrderDtoOutputEndedOutcomeEnum._('failedOther');

CaptainActiveOrderDtoOutputEndedOutcomeEnum
_$captainActiveOrderDtoOutputEndedOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'free':
      return _$captainActiveOrderDtoOutputEndedOutcomeEnum_free;
    case 'fake':
      return _$captainActiveOrderDtoOutputEndedOutcomeEnum_fake;
    case 'damaged':
      return _$captainActiveOrderDtoOutputEndedOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$captainActiveOrderDtoOutputEndedOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$captainActiveOrderDtoOutputEndedOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputEndedOutcomeEnum>
_$captainActiveOrderDtoOutputEndedOutcomeEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputEndedOutcomeEnum>(
      const <CaptainActiveOrderDtoOutputEndedOutcomeEnum>[
        _$captainActiveOrderDtoOutputEndedOutcomeEnum_free,
        _$captainActiveOrderDtoOutputEndedOutcomeEnum_fake,
        _$captainActiveOrderDtoOutputEndedOutcomeEnum_damaged,
        _$captainActiveOrderDtoOutputEndedOutcomeEnum_wrongRefused,
        _$captainActiveOrderDtoOutputEndedOutcomeEnum_failedOther,
      ],
    );

const CaptainActiveOrderDtoOutputEndedStatusEnum
_$captainActiveOrderDtoOutputEndedStatusEnum_delivered =
    const CaptainActiveOrderDtoOutputEndedStatusEnum._('delivered');
const CaptainActiveOrderDtoOutputEndedStatusEnum
_$captainActiveOrderDtoOutputEndedStatusEnum_failed =
    const CaptainActiveOrderDtoOutputEndedStatusEnum._('failed');

CaptainActiveOrderDtoOutputEndedStatusEnum
_$captainActiveOrderDtoOutputEndedStatusEnumValueOf(String name) {
  switch (name) {
    case 'delivered':
      return _$captainActiveOrderDtoOutputEndedStatusEnum_delivered;
    case 'failed':
      return _$captainActiveOrderDtoOutputEndedStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputEndedStatusEnum>
_$captainActiveOrderDtoOutputEndedStatusEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputEndedStatusEnum>(
      const <CaptainActiveOrderDtoOutputEndedStatusEnum>[
        _$captainActiveOrderDtoOutputEndedStatusEnum_delivered,
        _$captainActiveOrderDtoOutputEndedStatusEnum_failed,
      ],
    );

const CaptainActiveOrderDtoOutputEndedFoodEnum
_$captainActiveOrderDtoOutputEndedFoodEnum_keptByCaptain =
    const CaptainActiveOrderDtoOutputEndedFoodEnum._('keptByCaptain');
const CaptainActiveOrderDtoOutputEndedFoodEnum
_$captainActiveOrderDtoOutputEndedFoodEnum_returnedToRestaurant =
    const CaptainActiveOrderDtoOutputEndedFoodEnum._('returnedToRestaurant');
const CaptainActiveOrderDtoOutputEndedFoodEnum
_$captainActiveOrderDtoOutputEndedFoodEnum_destroyed =
    const CaptainActiveOrderDtoOutputEndedFoodEnum._('destroyed');

CaptainActiveOrderDtoOutputEndedFoodEnum
_$captainActiveOrderDtoOutputEndedFoodEnumValueOf(String name) {
  switch (name) {
    case 'keptByCaptain':
      return _$captainActiveOrderDtoOutputEndedFoodEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$captainActiveOrderDtoOutputEndedFoodEnum_returnedToRestaurant;
    case 'destroyed':
      return _$captainActiveOrderDtoOutputEndedFoodEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainActiveOrderDtoOutputEndedFoodEnum>
_$captainActiveOrderDtoOutputEndedFoodEnumValues =
    BuiltSet<CaptainActiveOrderDtoOutputEndedFoodEnum>(
      const <CaptainActiveOrderDtoOutputEndedFoodEnum>[
        _$captainActiveOrderDtoOutputEndedFoodEnum_keptByCaptain,
        _$captainActiveOrderDtoOutputEndedFoodEnum_returnedToRestaurant,
        _$captainActiveOrderDtoOutputEndedFoodEnum_destroyed,
      ],
    );

Serializer<CaptainActiveOrderDtoOutputEndedOutcomeEnum>
_$captainActiveOrderDtoOutputEndedOutcomeEnumSerializer =
    _$CaptainActiveOrderDtoOutputEndedOutcomeEnumSerializer();
Serializer<CaptainActiveOrderDtoOutputEndedStatusEnum>
_$captainActiveOrderDtoOutputEndedStatusEnumSerializer =
    _$CaptainActiveOrderDtoOutputEndedStatusEnumSerializer();
Serializer<CaptainActiveOrderDtoOutputEndedFoodEnum>
_$captainActiveOrderDtoOutputEndedFoodEnumSerializer =
    _$CaptainActiveOrderDtoOutputEndedFoodEnumSerializer();

class _$CaptainActiveOrderDtoOutputEndedOutcomeEnumSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputEndedOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrongRefused': 'wrong_refused',
    'failedOther': 'failed_other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrong_refused': 'wrongRefused',
    'failed_other': 'failedOther',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputEndedOutcomeEnum,
  ];
  @override
  final String wireName = 'CaptainActiveOrderDtoOutputEndedOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputEndedOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputEndedOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputEndedOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputEndedStatusEnumSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputEndedStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'delivered': 'delivered',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'delivered': 'delivered',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputEndedStatusEnum,
  ];
  @override
  final String wireName = 'CaptainActiveOrderDtoOutputEndedStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputEndedStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputEndedStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputEndedStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputEndedFoodEnumSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputEndedFoodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'keptByCaptain': 'kept_by_captain',
    'returnedToRestaurant': 'returned_to_restaurant',
    'destroyed': 'destroyed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'kept_by_captain': 'keptByCaptain',
    'returned_to_restaurant': 'returnedToRestaurant',
    'destroyed': 'destroyed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainActiveOrderDtoOutputEndedFoodEnum,
  ];
  @override
  final String wireName = 'CaptainActiveOrderDtoOutputEndedFoodEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputEndedFoodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainActiveOrderDtoOutputEndedFoodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainActiveOrderDtoOutputEndedFoodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainActiveOrderDtoOutputEnded
    extends CaptainActiveOrderDtoOutputEnded {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final CaptainActiveOrderDtoOutputEndedOutcomeEnum outcome;
  @override
  final CaptainActiveOrderDtoOutputEndedStatusEnum status;
  @override
  final CaptainActiveOrderDtoOutputEndedFoodEnum? food;
  @override
  final CaptainActiveOrderDtoOutputEndedPay? pay;
  @override
  final CaptainActiveOrderDtoOutputEndedPay? charge;
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputEnded([
    void Function(CaptainActiveOrderDtoOutputEndedBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputEndedBuilder()..update(updates))._build();

  _$CaptainActiveOrderDtoOutputEnded._({
    required this.orderId,
    required this.number,
    required this.outcome,
    required this.status,
    this.food,
    this.pay,
    this.charge,
    required this.at,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputEnded rebuild(
    void Function(CaptainActiveOrderDtoOutputEndedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputEndedBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputEndedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputEnded &&
        orderId == other.orderId &&
        number == other.number &&
        outcome == other.outcome &&
        status == other.status &&
        food == other.food &&
        pay == other.pay &&
        charge == other.charge &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, pay.hashCode);
    _$hash = $jc(_$hash, charge.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainActiveOrderDtoOutputEnded')
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('outcome', outcome)
          ..add('status', status)
          ..add('food', food)
          ..add('pay', pay)
          ..add('charge', charge)
          ..add('at', at))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputEndedBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputEnded,
          CaptainActiveOrderDtoOutputEndedBuilder
        > {
  _$CaptainActiveOrderDtoOutputEnded? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CaptainActiveOrderDtoOutputEndedOutcomeEnum? _outcome;
  CaptainActiveOrderDtoOutputEndedOutcomeEnum? get outcome => _$this._outcome;
  set outcome(CaptainActiveOrderDtoOutputEndedOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  CaptainActiveOrderDtoOutputEndedStatusEnum? _status;
  CaptainActiveOrderDtoOutputEndedStatusEnum? get status => _$this._status;
  set status(CaptainActiveOrderDtoOutputEndedStatusEnum? status) =>
      _$this._status = status;

  CaptainActiveOrderDtoOutputEndedFoodEnum? _food;
  CaptainActiveOrderDtoOutputEndedFoodEnum? get food => _$this._food;
  set food(CaptainActiveOrderDtoOutputEndedFoodEnum? food) =>
      _$this._food = food;

  CaptainActiveOrderDtoOutputEndedPayBuilder? _pay;
  CaptainActiveOrderDtoOutputEndedPayBuilder get pay =>
      _$this._pay ??= CaptainActiveOrderDtoOutputEndedPayBuilder();
  set pay(CaptainActiveOrderDtoOutputEndedPayBuilder? pay) => _$this._pay = pay;

  CaptainActiveOrderDtoOutputEndedPayBuilder? _charge;
  CaptainActiveOrderDtoOutputEndedPayBuilder get charge =>
      _$this._charge ??= CaptainActiveOrderDtoOutputEndedPayBuilder();
  set charge(CaptainActiveOrderDtoOutputEndedPayBuilder? charge) =>
      _$this._charge = charge;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputEndedBuilder() {
    CaptainActiveOrderDtoOutputEnded._defaults(this);
  }

  CaptainActiveOrderDtoOutputEndedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _outcome = $v.outcome;
      _status = $v.status;
      _food = $v.food;
      _pay = $v.pay?.toBuilder();
      _charge = $v.charge?.toBuilder();
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputEnded other) {
    _$v = other as _$CaptainActiveOrderDtoOutputEnded;
  }

  @override
  void update(void Function(CaptainActiveOrderDtoOutputEndedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputEnded build() => _build();

  _$CaptainActiveOrderDtoOutputEnded _build() {
    _$CaptainActiveOrderDtoOutputEnded _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputEnded._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'CaptainActiveOrderDtoOutputEnded',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'CaptainActiveOrderDtoOutputEnded',
              'number',
            ),
            outcome: BuiltValueNullFieldError.checkNotNull(
              outcome,
              r'CaptainActiveOrderDtoOutputEnded',
              'outcome',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CaptainActiveOrderDtoOutputEnded',
              'status',
            ),
            food: food,
            pay: _pay?.build(),
            charge: _charge?.build(),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CaptainActiveOrderDtoOutputEnded',
              'at',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pay';
        _pay?.build();
        _$failedField = 'charge';
        _charge?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputEnded',
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
