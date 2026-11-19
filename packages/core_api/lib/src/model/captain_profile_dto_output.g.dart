// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_profile_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainProfileDtoOutputVehicleEnum
_$captainProfileDtoOutputVehicleEnum_walking =
    const CaptainProfileDtoOutputVehicleEnum._('walking');
const CaptainProfileDtoOutputVehicleEnum
_$captainProfileDtoOutputVehicleEnum_bicycle =
    const CaptainProfileDtoOutputVehicleEnum._('bicycle');
const CaptainProfileDtoOutputVehicleEnum
_$captainProfileDtoOutputVehicleEnum_motorbike =
    const CaptainProfileDtoOutputVehicleEnum._('motorbike');
const CaptainProfileDtoOutputVehicleEnum
_$captainProfileDtoOutputVehicleEnum_car =
    const CaptainProfileDtoOutputVehicleEnum._('car');

CaptainProfileDtoOutputVehicleEnum _$captainProfileDtoOutputVehicleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'walking':
      return _$captainProfileDtoOutputVehicleEnum_walking;
    case 'bicycle':
      return _$captainProfileDtoOutputVehicleEnum_bicycle;
    case 'motorbike':
      return _$captainProfileDtoOutputVehicleEnum_motorbike;
    case 'car':
      return _$captainProfileDtoOutputVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainProfileDtoOutputVehicleEnum>
_$captainProfileDtoOutputVehicleEnumValues =
    BuiltSet<CaptainProfileDtoOutputVehicleEnum>(
      const <CaptainProfileDtoOutputVehicleEnum>[
        _$captainProfileDtoOutputVehicleEnum_walking,
        _$captainProfileDtoOutputVehicleEnum_bicycle,
        _$captainProfileDtoOutputVehicleEnum_motorbike,
        _$captainProfileDtoOutputVehicleEnum_car,
      ],
    );

Serializer<CaptainProfileDtoOutputVehicleEnum>
_$captainProfileDtoOutputVehicleEnumSerializer =
    _$CaptainProfileDtoOutputVehicleEnumSerializer();

class _$CaptainProfileDtoOutputVehicleEnumSerializer
    implements PrimitiveSerializer<CaptainProfileDtoOutputVehicleEnum> {
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
  final Iterable<Type> types = const <Type>[CaptainProfileDtoOutputVehicleEnum];
  @override
  final String wireName = 'CaptainProfileDtoOutputVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainProfileDtoOutputVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainProfileDtoOutputVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainProfileDtoOutputVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainProfileDtoOutput extends CaptainProfileDtoOutput {
  @override
  final String foxDropId;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? neighbourhood;
  @override
  final CaptainProfileDtoOutputVehicleEnum vehicle;
  @override
  final String? plateNumber;

  factory _$CaptainProfileDtoOutput([
    void Function(CaptainProfileDtoOutputBuilder)? updates,
  ]) => (CaptainProfileDtoOutputBuilder()..update(updates))._build();

  _$CaptainProfileDtoOutput._({
    required this.foxDropId,
    required this.name,
    this.phone,
    this.neighbourhood,
    required this.vehicle,
    this.plateNumber,
  }) : super._();
  @override
  CaptainProfileDtoOutput rebuild(
    void Function(CaptainProfileDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainProfileDtoOutputBuilder toBuilder() =>
      CaptainProfileDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainProfileDtoOutput &&
        foxDropId == other.foxDropId &&
        name == other.name &&
        phone == other.phone &&
        neighbourhood == other.neighbourhood &&
        vehicle == other.vehicle &&
        plateNumber == other.plateNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, foxDropId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, plateNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainProfileDtoOutput')
          ..add('foxDropId', foxDropId)
          ..add('name', name)
          ..add('phone', phone)
          ..add('neighbourhood', neighbourhood)
          ..add('vehicle', vehicle)
          ..add('plateNumber', plateNumber))
        .toString();
  }
}

class CaptainProfileDtoOutputBuilder
    implements
        Builder<CaptainProfileDtoOutput, CaptainProfileDtoOutputBuilder> {
  _$CaptainProfileDtoOutput? _$v;

  String? _foxDropId;
  String? get foxDropId => _$this._foxDropId;
  set foxDropId(String? foxDropId) => _$this._foxDropId = foxDropId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  CaptainProfileDtoOutputVehicleEnum? _vehicle;
  CaptainProfileDtoOutputVehicleEnum? get vehicle => _$this._vehicle;
  set vehicle(CaptainProfileDtoOutputVehicleEnum? vehicle) =>
      _$this._vehicle = vehicle;

  String? _plateNumber;
  String? get plateNumber => _$this._plateNumber;
  set plateNumber(String? plateNumber) => _$this._plateNumber = plateNumber;

  CaptainProfileDtoOutputBuilder() {
    CaptainProfileDtoOutput._defaults(this);
  }

  CaptainProfileDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _foxDropId = $v.foxDropId;
      _name = $v.name;
      _phone = $v.phone;
      _neighbourhood = $v.neighbourhood;
      _vehicle = $v.vehicle;
      _plateNumber = $v.plateNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainProfileDtoOutput other) {
    _$v = other as _$CaptainProfileDtoOutput;
  }

  @override
  void update(void Function(CaptainProfileDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainProfileDtoOutput build() => _build();

  _$CaptainProfileDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainProfileDtoOutput._(
          foxDropId: BuiltValueNullFieldError.checkNotNull(
            foxDropId,
            r'CaptainProfileDtoOutput',
            'foxDropId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CaptainProfileDtoOutput',
            'name',
          ),
          phone: phone,
          neighbourhood: neighbourhood,
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'CaptainProfileDtoOutput',
            'vehicle',
          ),
          plateNumber: plateNumber,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
