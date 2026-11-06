// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output_restaurants_inner_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_open =
    const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum._(
      'open',
    );
const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_busy =
    const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum._(
      'busy',
    );
const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_paused =
    const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum._(
      'paused',
    );
const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_closed =
    const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum._(
      'closed',
    );
const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_holiday =
    const CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum._(
      'holiday',
    );

CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnumValueOf(
  String name,
) {
  switch (name) {
    case 'open':
      return _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_open;
    case 'busy':
      return _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_busy;
    case 'paused':
      return _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_paused;
    case 'closed':
      return _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_closed;
    case 'holiday':
      return _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_holiday;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum>
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnumValues =
    BuiltSet<CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum>(
      const <CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum>[
        _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_open,
        _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_busy,
        _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_paused,
        _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_closed,
        _$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnum_holiday,
      ],
    );

Serializer<CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum>
_$customerRestaurantListDtoOutputRestaurantsInnerStateStateEnumSerializer =
    _$CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnumSerializer();

class _$CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum
        > {
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
    CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum,
  ];
  @override
  final String wireName =
      'CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerRestaurantListDtoOutputRestaurantsInnerState
    extends CustomerRestaurantListDtoOutputRestaurantsInnerState {
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum state;
  @override
  final bool busyMode;
  @override
  final DateTime? until;
  @override
  final DateTime? opensAt;
  @override
  final String? message;

  factory _$CustomerRestaurantListDtoOutputRestaurantsInnerState([
    void Function(CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder)?
    updates,
  ]) =>
      (CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantListDtoOutputRestaurantsInnerState._({
    required this.state,
    required this.busyMode,
    this.until,
    this.opensAt,
    this.message,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerState rebuild(
    void Function(CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder toBuilder() =>
      CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantListDtoOutputRestaurantsInnerState &&
        state == other.state &&
        busyMode == other.busyMode &&
        until == other.until &&
        opensAt == other.opensAt &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantListDtoOutputRestaurantsInnerState',
          )
          ..add('state', state)
          ..add('busyMode', busyMode)
          ..add('until', until)
          ..add('opensAt', opensAt)
          ..add('message', message))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutputRestaurantsInnerState,
          CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder
        > {
  _$CustomerRestaurantListDtoOutputRestaurantsInnerState? _$v;

  CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum? _state;
  CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum? get state =>
      _$this._state;
  set state(
    CustomerRestaurantListDtoOutputRestaurantsInnerStateStateEnum? state,
  ) => _$this._state = state;

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

  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder() {
    CustomerRestaurantListDtoOutputRestaurantsInnerState._defaults(this);
  }

  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(CustomerRestaurantListDtoOutputRestaurantsInnerState other) {
    _$v = other as _$CustomerRestaurantListDtoOutputRestaurantsInnerState;
  }

  @override
  void update(
    void Function(CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerState build() => _build();

  _$CustomerRestaurantListDtoOutputRestaurantsInnerState _build() {
    final _$result =
        _$v ??
        _$CustomerRestaurantListDtoOutputRestaurantsInnerState._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'CustomerRestaurantListDtoOutputRestaurantsInnerState',
            'state',
          ),
          busyMode: BuiltValueNullFieldError.checkNotNull(
            busyMode,
            r'CustomerRestaurantListDtoOutputRestaurantsInnerState',
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
