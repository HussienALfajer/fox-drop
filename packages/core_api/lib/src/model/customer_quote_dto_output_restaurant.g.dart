// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerQuoteDtoOutputRestaurantStateEnum
_$customerQuoteDtoOutputRestaurantStateEnum_open =
    const CustomerQuoteDtoOutputRestaurantStateEnum._('open');
const CustomerQuoteDtoOutputRestaurantStateEnum
_$customerQuoteDtoOutputRestaurantStateEnum_busy =
    const CustomerQuoteDtoOutputRestaurantStateEnum._('busy');
const CustomerQuoteDtoOutputRestaurantStateEnum
_$customerQuoteDtoOutputRestaurantStateEnum_paused =
    const CustomerQuoteDtoOutputRestaurantStateEnum._('paused');
const CustomerQuoteDtoOutputRestaurantStateEnum
_$customerQuoteDtoOutputRestaurantStateEnum_closed =
    const CustomerQuoteDtoOutputRestaurantStateEnum._('closed');
const CustomerQuoteDtoOutputRestaurantStateEnum
_$customerQuoteDtoOutputRestaurantStateEnum_holiday =
    const CustomerQuoteDtoOutputRestaurantStateEnum._('holiday');

CustomerQuoteDtoOutputRestaurantStateEnum
_$customerQuoteDtoOutputRestaurantStateEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$customerQuoteDtoOutputRestaurantStateEnum_open;
    case 'busy':
      return _$customerQuoteDtoOutputRestaurantStateEnum_busy;
    case 'paused':
      return _$customerQuoteDtoOutputRestaurantStateEnum_paused;
    case 'closed':
      return _$customerQuoteDtoOutputRestaurantStateEnum_closed;
    case 'holiday':
      return _$customerQuoteDtoOutputRestaurantStateEnum_holiday;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerQuoteDtoOutputRestaurantStateEnum>
_$customerQuoteDtoOutputRestaurantStateEnumValues =
    BuiltSet<CustomerQuoteDtoOutputRestaurantStateEnum>(
      const <CustomerQuoteDtoOutputRestaurantStateEnum>[
        _$customerQuoteDtoOutputRestaurantStateEnum_open,
        _$customerQuoteDtoOutputRestaurantStateEnum_busy,
        _$customerQuoteDtoOutputRestaurantStateEnum_paused,
        _$customerQuoteDtoOutputRestaurantStateEnum_closed,
        _$customerQuoteDtoOutputRestaurantStateEnum_holiday,
      ],
    );

Serializer<CustomerQuoteDtoOutputRestaurantStateEnum>
_$customerQuoteDtoOutputRestaurantStateEnumSerializer =
    _$CustomerQuoteDtoOutputRestaurantStateEnumSerializer();

class _$CustomerQuoteDtoOutputRestaurantStateEnumSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputRestaurantStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'busy': 'busy',
    'paused': 'paused',
    'closed': 'closed',
    'holiday': 'holiday',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'busy': 'busy',
    'paused': 'paused',
    'closed': 'closed',
    'holiday': 'holiday',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerQuoteDtoOutputRestaurantStateEnum,
  ];
  @override
  final String wireName = 'CustomerQuoteDtoOutputRestaurantStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputRestaurantStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerQuoteDtoOutputRestaurantStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerQuoteDtoOutputRestaurantStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerQuoteDtoOutputRestaurant
    extends CustomerQuoteDtoOutputRestaurant {
  @override
  final String id;
  @override
  final CustomerQuoteDtoOutputRestaurantStateEnum state;
  @override
  final bool busyMode;
  @override
  final DateTime? until;
  @override
  final DateTime? opensAt;
  @override
  final String? message;

  factory _$CustomerQuoteDtoOutputRestaurant([
    void Function(CustomerQuoteDtoOutputRestaurantBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputRestaurantBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputRestaurant._({
    required this.id,
    required this.state,
    required this.busyMode,
    this.until,
    this.opensAt,
    this.message,
  }) : super._();
  @override
  CustomerQuoteDtoOutputRestaurant rebuild(
    void Function(CustomerQuoteDtoOutputRestaurantBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputRestaurantBuilder toBuilder() =>
      CustomerQuoteDtoOutputRestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputRestaurant &&
        id == other.id &&
        state == other.state &&
        busyMode == other.busyMode &&
        until == other.until &&
        opensAt == other.opensAt &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, busyMode.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputRestaurant')
          ..add('id', id)
          ..add('state', state)
          ..add('busyMode', busyMode)
          ..add('until', until)
          ..add('opensAt', opensAt)
          ..add('message', message))
        .toString();
  }
}

class CustomerQuoteDtoOutputRestaurantBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputRestaurant,
          CustomerQuoteDtoOutputRestaurantBuilder
        > {
  _$CustomerQuoteDtoOutputRestaurant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CustomerQuoteDtoOutputRestaurantStateEnum? _state;
  CustomerQuoteDtoOutputRestaurantStateEnum? get state => _$this._state;
  set state(CustomerQuoteDtoOutputRestaurantStateEnum? state) =>
      _$this._state = state;

  bool? _busyMode;
  bool? get busyMode => _$this._busyMode;
  set busyMode(bool? busyMode) => _$this._busyMode = busyMode;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  DateTime? _opensAt;
  DateTime? get opensAt => _$this._opensAt;
  set opensAt(DateTime? opensAt) => _$this._opensAt = opensAt;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  CustomerQuoteDtoOutputRestaurantBuilder() {
    CustomerQuoteDtoOutputRestaurant._defaults(this);
  }

  CustomerQuoteDtoOutputRestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _state = $v.state;
      _busyMode = $v.busyMode;
      _until = $v.until;
      _opensAt = $v.opensAt;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputRestaurant other) {
    _$v = other as _$CustomerQuoteDtoOutputRestaurant;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputRestaurantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputRestaurant build() => _build();

  _$CustomerQuoteDtoOutputRestaurant _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputRestaurant._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CustomerQuoteDtoOutputRestaurant',
            'id',
          ),
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'CustomerQuoteDtoOutputRestaurant',
            'state',
          ),
          busyMode: BuiltValueNullFieldError.checkNotNull(
            busyMode,
            r'CustomerQuoteDtoOutputRestaurant',
            'busyMode',
          ),
          until: until,
          opensAt: opensAt,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
