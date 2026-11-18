// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_location_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerLocationDtoOutputStateEnum
_$customerLocationDtoOutputStateEnum_served =
    const CustomerLocationDtoOutputStateEnum._('served');
const CustomerLocationDtoOutputStateEnum
_$customerLocationDtoOutputStateEnum_noRestaurants =
    const CustomerLocationDtoOutputStateEnum._('noRestaurants');
const CustomerLocationDtoOutputStateEnum
_$customerLocationDtoOutputStateEnum_outsideZones =
    const CustomerLocationDtoOutputStateEnum._('outsideZones');

CustomerLocationDtoOutputStateEnum _$customerLocationDtoOutputStateEnumValueOf(
  String name,
) {
  switch (name) {
    case 'served':
      return _$customerLocationDtoOutputStateEnum_served;
    case 'noRestaurants':
      return _$customerLocationDtoOutputStateEnum_noRestaurants;
    case 'outsideZones':
      return _$customerLocationDtoOutputStateEnum_outsideZones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerLocationDtoOutputStateEnum>
_$customerLocationDtoOutputStateEnumValues =
    BuiltSet<CustomerLocationDtoOutputStateEnum>(
      const <CustomerLocationDtoOutputStateEnum>[
        _$customerLocationDtoOutputStateEnum_served,
        _$customerLocationDtoOutputStateEnum_noRestaurants,
        _$customerLocationDtoOutputStateEnum_outsideZones,
      ],
    );

Serializer<CustomerLocationDtoOutputStateEnum>
_$customerLocationDtoOutputStateEnumSerializer =
    _$CustomerLocationDtoOutputStateEnumSerializer();

class _$CustomerLocationDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<CustomerLocationDtoOutputStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'served': 'served',
    'noRestaurants': 'no_restaurants',
    'outsideZones': 'outside_zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'served': 'served',
    'no_restaurants': 'noRestaurants',
    'outside_zones': 'outsideZones',
  };

  @override
  final Iterable<Type> types = const <Type>[CustomerLocationDtoOutputStateEnum];
  @override
  final String wireName = 'CustomerLocationDtoOutputStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerLocationDtoOutputStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerLocationDtoOutputStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerLocationDtoOutputStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerLocationDtoOutput extends CustomerLocationDtoOutput {
  @override
  final CustomerLocationDtoOutputStateEnum state;
  @override
  final AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner? zone;

  factory _$CustomerLocationDtoOutput([
    void Function(CustomerLocationDtoOutputBuilder)? updates,
  ]) => (CustomerLocationDtoOutputBuilder()..update(updates))._build();

  _$CustomerLocationDtoOutput._({required this.state, this.zone}) : super._();
  @override
  CustomerLocationDtoOutput rebuild(
    void Function(CustomerLocationDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerLocationDtoOutputBuilder toBuilder() =>
      CustomerLocationDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerLocationDtoOutput &&
        state == other.state &&
        zone == other.zone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerLocationDtoOutput')
          ..add('state', state)
          ..add('zone', zone))
        .toString();
  }
}

class CustomerLocationDtoOutputBuilder
    implements
        Builder<CustomerLocationDtoOutput, CustomerLocationDtoOutputBuilder> {
  _$CustomerLocationDtoOutput? _$v;

  CustomerLocationDtoOutputStateEnum? _state;
  CustomerLocationDtoOutputStateEnum? get state => _$this._state;
  set state(CustomerLocationDtoOutputStateEnum? state) => _$this._state = state;

  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder? _zone;
  AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder get zone =>
      _$this._zone ??=
          AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder();
  set zone(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInnerBuilder? zone) =>
      _$this._zone = zone;

  CustomerLocationDtoOutputBuilder() {
    CustomerLocationDtoOutput._defaults(this);
  }

  CustomerLocationDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _zone = $v.zone?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerLocationDtoOutput other) {
    _$v = other as _$CustomerLocationDtoOutput;
  }

  @override
  void update(void Function(CustomerLocationDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerLocationDtoOutput build() => _build();

  _$CustomerLocationDtoOutput _build() {
    _$CustomerLocationDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerLocationDtoOutput._(
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'CustomerLocationDtoOutput',
              'state',
            ),
            zone: _zone?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zone';
        _zone?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerLocationDtoOutput',
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
