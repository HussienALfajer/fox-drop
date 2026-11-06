// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking =
    const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum._('walking');
const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle =
    const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum._('bicycle');
const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike =
    const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum._('motorbike');
const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car =
    const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum._('car');

MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumValueOf(String name) {
  switch (name) {
    case 'walking':
      return _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking;
    case 'bicycle':
      return _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle;
    case 'motorbike':
      return _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike;
    case 'car':
      return _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum>
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumValues =
    BuiltSet<MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum>(
      const <MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum>[
        _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking,
        _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle,
        _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike,
        _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car,
      ],
    );

Serializer<MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum>
_$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer =
    _$MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer();

class _$MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum
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
    MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum,
  ];
  @override
  final String wireName =
      'MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantOrdersDtoOutputOrdersInnerCaptain
    extends MerchantOrdersDtoOutputOrdersInnerCaptain {
  @override
  final String firstName;
  @override
  final MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum vehicle;

  factory _$MerchantOrdersDtoOutputOrdersInnerCaptain([
    void Function(MerchantOrdersDtoOutputOrdersInnerCaptainBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerCaptainBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerCaptain._({
    required this.firstName,
    required this.vehicle,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerCaptain rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerCaptainBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptainBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerCaptain &&
        firstName == other.firstName &&
        vehicle == other.vehicle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerCaptain',
          )
          ..add('firstName', firstName)
          ..add('vehicle', vehicle))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerCaptainBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerCaptain,
          MerchantOrdersDtoOutputOrdersInnerCaptainBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerCaptain? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum? _vehicle;
  MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum? get vehicle =>
      _$this._vehicle;
  set vehicle(MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum? vehicle) =>
      _$this._vehicle = vehicle;

  MerchantOrdersDtoOutputOrdersInnerCaptainBuilder() {
    MerchantOrdersDtoOutputOrdersInnerCaptain._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerCaptainBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _vehicle = $v.vehicle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerCaptain other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerCaptain;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerCaptainBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptain build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerCaptain _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerCaptain._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'MerchantOrdersDtoOutputOrdersInnerCaptain',
            'firstName',
          ),
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'MerchantOrdersDtoOutputOrdersInnerCaptain',
            'vehicle',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
