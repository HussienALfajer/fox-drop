// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_route_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainOrderRouteDtoOutputLegEnum
_$captainOrderRouteDtoOutputLegEnum_toRestaurant =
    const CaptainOrderRouteDtoOutputLegEnum._('toRestaurant');
const CaptainOrderRouteDtoOutputLegEnum
_$captainOrderRouteDtoOutputLegEnum_toCustomer =
    const CaptainOrderRouteDtoOutputLegEnum._('toCustomer');

CaptainOrderRouteDtoOutputLegEnum _$captainOrderRouteDtoOutputLegEnumValueOf(
  String name,
) {
  switch (name) {
    case 'toRestaurant':
      return _$captainOrderRouteDtoOutputLegEnum_toRestaurant;
    case 'toCustomer':
      return _$captainOrderRouteDtoOutputLegEnum_toCustomer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainOrderRouteDtoOutputLegEnum>
_$captainOrderRouteDtoOutputLegEnumValues =
    BuiltSet<CaptainOrderRouteDtoOutputLegEnum>(
      const <CaptainOrderRouteDtoOutputLegEnum>[
        _$captainOrderRouteDtoOutputLegEnum_toRestaurant,
        _$captainOrderRouteDtoOutputLegEnum_toCustomer,
      ],
    );

Serializer<CaptainOrderRouteDtoOutputLegEnum>
_$captainOrderRouteDtoOutputLegEnumSerializer =
    _$CaptainOrderRouteDtoOutputLegEnumSerializer();

class _$CaptainOrderRouteDtoOutputLegEnumSerializer
    implements PrimitiveSerializer<CaptainOrderRouteDtoOutputLegEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'toRestaurant': 'to_restaurant',
    'toCustomer': 'to_customer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'to_restaurant': 'toRestaurant',
    'to_customer': 'toCustomer',
  };

  @override
  final Iterable<Type> types = const <Type>[CaptainOrderRouteDtoOutputLegEnum];
  @override
  final String wireName = 'CaptainOrderRouteDtoOutputLegEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderRouteDtoOutputLegEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainOrderRouteDtoOutputLegEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainOrderRouteDtoOutputLegEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainOrderRouteDtoOutput extends CaptainOrderRouteDtoOutput {
  @override
  final CaptainOrderRouteDtoOutputLegEnum leg;
  @override
  final AdminCustomerDtoOutputAddressesInnerLocation destination;
  @override
  final CaptainOrderRouteDtoOutputRoute? route;

  factory _$CaptainOrderRouteDtoOutput([
    void Function(CaptainOrderRouteDtoOutputBuilder)? updates,
  ]) => (CaptainOrderRouteDtoOutputBuilder()..update(updates))._build();

  _$CaptainOrderRouteDtoOutput._({
    required this.leg,
    required this.destination,
    this.route,
  }) : super._();
  @override
  CaptainOrderRouteDtoOutput rebuild(
    void Function(CaptainOrderRouteDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderRouteDtoOutputBuilder toBuilder() =>
      CaptainOrderRouteDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderRouteDtoOutput &&
        leg == other.leg &&
        destination == other.destination &&
        route == other.route;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, leg.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, route.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainOrderRouteDtoOutput')
          ..add('leg', leg)
          ..add('destination', destination)
          ..add('route', route))
        .toString();
  }
}

class CaptainOrderRouteDtoOutputBuilder
    implements
        Builder<CaptainOrderRouteDtoOutput, CaptainOrderRouteDtoOutputBuilder> {
  _$CaptainOrderRouteDtoOutput? _$v;

  CaptainOrderRouteDtoOutputLegEnum? _leg;
  CaptainOrderRouteDtoOutputLegEnum? get leg => _$this._leg;
  set leg(CaptainOrderRouteDtoOutputLegEnum? leg) => _$this._leg = leg;

  AdminCustomerDtoOutputAddressesInnerLocationBuilder? _destination;
  AdminCustomerDtoOutputAddressesInnerLocationBuilder get destination =>
      _$this._destination ??=
          AdminCustomerDtoOutputAddressesInnerLocationBuilder();
  set destination(
    AdminCustomerDtoOutputAddressesInnerLocationBuilder? destination,
  ) => _$this._destination = destination;

  CaptainOrderRouteDtoOutputRouteBuilder? _route;
  CaptainOrderRouteDtoOutputRouteBuilder get route =>
      _$this._route ??= CaptainOrderRouteDtoOutputRouteBuilder();
  set route(CaptainOrderRouteDtoOutputRouteBuilder? route) =>
      _$this._route = route;

  CaptainOrderRouteDtoOutputBuilder() {
    CaptainOrderRouteDtoOutput._defaults(this);
  }

  CaptainOrderRouteDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _leg = $v.leg;
      _destination = $v.destination.toBuilder();
      _route = $v.route?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderRouteDtoOutput other) {
    _$v = other as _$CaptainOrderRouteDtoOutput;
  }

  @override
  void update(void Function(CaptainOrderRouteDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderRouteDtoOutput build() => _build();

  _$CaptainOrderRouteDtoOutput _build() {
    _$CaptainOrderRouteDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderRouteDtoOutput._(
            leg: BuiltValueNullFieldError.checkNotNull(
              leg,
              r'CaptainOrderRouteDtoOutput',
              'leg',
            ),
            destination: destination.build(),
            route: _route?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'destination';
        destination.build();
        _$failedField = 'route';
        _route?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderRouteDtoOutput',
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
