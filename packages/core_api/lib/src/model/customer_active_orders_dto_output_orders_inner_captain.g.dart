// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking =
    const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum._(
      'walking',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle =
    const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum._(
      'bicycle',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike =
    const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum._(
      'motorbike',
    );
const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car =
    const CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum._('car');

CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'walking':
      return _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking;
    case 'bicycle':
      return _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle;
    case 'motorbike':
      return _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike;
    case 'car':
      return _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum>
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumValues =
    BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum>(
      const <CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum>[
        _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking,
        _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle,
        _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike,
        _$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car,
      ],
    );

Serializer<CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum>
_$customerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer =
    _$CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer();

class _$CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'walking': 'walking',
    'bicycle': 'bicycle',
    'motorbike': 'motorbike',
    'car': 'car',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'walking': 'walking',
    'bicycle': 'bicycle',
    'motorbike': 'motorbike',
    'car': 'car',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum,
  ];
  @override
  final String wireName =
      'CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain
    extends CustomerActiveOrdersDtoOutputOrdersInnerCaptain {
  @override
  final String firstName;
  @override
  final CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum vehicle;
  @override
  final bool atRestaurant;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain._({
    required this.firstName,
    required this.vehicle,
    required this.atRestaurant,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCaptain rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerCaptain &&
        firstName == other.firstName &&
        vehicle == other.vehicle &&
        atRestaurant == other.atRestaurant;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, atRestaurant.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerCaptain',
          )
          ..add('firstName', firstName)
          ..add('vehicle', vehicle)
          ..add('atRestaurant', atRestaurant))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerCaptain,
          CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum? _vehicle;
  CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum? get vehicle =>
      _$this._vehicle;
  set vehicle(
    CustomerActiveOrdersDtoOutputOrdersInnerCaptainVehicleEnum? vehicle,
  ) => _$this._vehicle = vehicle;

  bool? _atRestaurant;
  bool? get atRestaurant => _$this._atRestaurant;
  set atRestaurant(bool? atRestaurant) => _$this._atRestaurant = atRestaurant;

  CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerCaptain._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _vehicle = $v.vehicle;
      _atRestaurant = $v.atRestaurant;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerCaptain other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerCaptainBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCaptain build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerCaptain._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCaptain',
            'firstName',
          ),
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCaptain',
            'vehicle',
          ),
          atRestaurant: BuiltValueNullFieldError.checkNotNull(
            atRestaurant,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCaptain',
            'atRestaurant',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
