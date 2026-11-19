// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_vehicle_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainApplicationVehicleDtoVehicleEnum
_$captainApplicationVehicleDtoVehicleEnum_walking =
    const CaptainApplicationVehicleDtoVehicleEnum._('walking');
const CaptainApplicationVehicleDtoVehicleEnum
_$captainApplicationVehicleDtoVehicleEnum_bicycle =
    const CaptainApplicationVehicleDtoVehicleEnum._('bicycle');
const CaptainApplicationVehicleDtoVehicleEnum
_$captainApplicationVehicleDtoVehicleEnum_motorbike =
    const CaptainApplicationVehicleDtoVehicleEnum._('motorbike');
const CaptainApplicationVehicleDtoVehicleEnum
_$captainApplicationVehicleDtoVehicleEnum_car =
    const CaptainApplicationVehicleDtoVehicleEnum._('car');

CaptainApplicationVehicleDtoVehicleEnum
_$captainApplicationVehicleDtoVehicleEnumValueOf(String name) {
  switch (name) {
    case 'walking':
      return _$captainApplicationVehicleDtoVehicleEnum_walking;
    case 'bicycle':
      return _$captainApplicationVehicleDtoVehicleEnum_bicycle;
    case 'motorbike':
      return _$captainApplicationVehicleDtoVehicleEnum_motorbike;
    case 'car':
      return _$captainApplicationVehicleDtoVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainApplicationVehicleDtoVehicleEnum>
_$captainApplicationVehicleDtoVehicleEnumValues =
    BuiltSet<CaptainApplicationVehicleDtoVehicleEnum>(
      const <CaptainApplicationVehicleDtoVehicleEnum>[
        _$captainApplicationVehicleDtoVehicleEnum_walking,
        _$captainApplicationVehicleDtoVehicleEnum_bicycle,
        _$captainApplicationVehicleDtoVehicleEnum_motorbike,
        _$captainApplicationVehicleDtoVehicleEnum_car,
      ],
    );

Serializer<CaptainApplicationVehicleDtoVehicleEnum>
_$captainApplicationVehicleDtoVehicleEnumSerializer =
    _$CaptainApplicationVehicleDtoVehicleEnumSerializer();

class _$CaptainApplicationVehicleDtoVehicleEnumSerializer
    implements PrimitiveSerializer<CaptainApplicationVehicleDtoVehicleEnum> {
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
    CaptainApplicationVehicleDtoVehicleEnum,
  ];
  @override
  final String wireName = 'CaptainApplicationVehicleDtoVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationVehicleDtoVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainApplicationVehicleDtoVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainApplicationVehicleDtoVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainApplicationVehicleDto extends CaptainApplicationVehicleDto {
  @override
  final CaptainApplicationVehicleDtoVehicleEnum vehicle;
  @override
  final String? plate;

  factory _$CaptainApplicationVehicleDto([
    void Function(CaptainApplicationVehicleDtoBuilder)? updates,
  ]) => (CaptainApplicationVehicleDtoBuilder()..update(updates))._build();

  _$CaptainApplicationVehicleDto._({required this.vehicle, this.plate})
    : super._();
  @override
  CaptainApplicationVehicleDto rebuild(
    void Function(CaptainApplicationVehicleDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationVehicleDtoBuilder toBuilder() =>
      CaptainApplicationVehicleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationVehicleDto &&
        vehicle == other.vehicle &&
        plate == other.plate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, plate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainApplicationVehicleDto')
          ..add('vehicle', vehicle)
          ..add('plate', plate))
        .toString();
  }
}

class CaptainApplicationVehicleDtoBuilder
    implements
        Builder<
          CaptainApplicationVehicleDto,
          CaptainApplicationVehicleDtoBuilder
        > {
  _$CaptainApplicationVehicleDto? _$v;

  CaptainApplicationVehicleDtoVehicleEnum? _vehicle;
  CaptainApplicationVehicleDtoVehicleEnum? get vehicle => _$this._vehicle;
  set vehicle(CaptainApplicationVehicleDtoVehicleEnum? vehicle) =>
      _$this._vehicle = vehicle;

  String? _plate;
  String? get plate => _$this._plate;
  set plate(String? plate) => _$this._plate = plate;

  CaptainApplicationVehicleDtoBuilder() {
    CaptainApplicationVehicleDto._defaults(this);
  }

  CaptainApplicationVehicleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicle = $v.vehicle;
      _plate = $v.plate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationVehicleDto other) {
    _$v = other as _$CaptainApplicationVehicleDto;
  }

  @override
  void update(void Function(CaptainApplicationVehicleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationVehicleDto build() => _build();

  _$CaptainApplicationVehicleDto _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationVehicleDto._(
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'CaptainApplicationVehicleDto',
            'vehicle',
          ),
          plate: plate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
