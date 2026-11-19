// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pay_table_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainPayTableDtoOutputVehicleEnum
_$captainPayTableDtoOutputVehicleEnum_walking =
    const CaptainPayTableDtoOutputVehicleEnum._('walking');
const CaptainPayTableDtoOutputVehicleEnum
_$captainPayTableDtoOutputVehicleEnum_bicycle =
    const CaptainPayTableDtoOutputVehicleEnum._('bicycle');
const CaptainPayTableDtoOutputVehicleEnum
_$captainPayTableDtoOutputVehicleEnum_motorbike =
    const CaptainPayTableDtoOutputVehicleEnum._('motorbike');
const CaptainPayTableDtoOutputVehicleEnum
_$captainPayTableDtoOutputVehicleEnum_car =
    const CaptainPayTableDtoOutputVehicleEnum._('car');

CaptainPayTableDtoOutputVehicleEnum
_$captainPayTableDtoOutputVehicleEnumValueOf(String name) {
  switch (name) {
    case 'walking':
      return _$captainPayTableDtoOutputVehicleEnum_walking;
    case 'bicycle':
      return _$captainPayTableDtoOutputVehicleEnum_bicycle;
    case 'motorbike':
      return _$captainPayTableDtoOutputVehicleEnum_motorbike;
    case 'car':
      return _$captainPayTableDtoOutputVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainPayTableDtoOutputVehicleEnum>
_$captainPayTableDtoOutputVehicleEnumValues =
    BuiltSet<CaptainPayTableDtoOutputVehicleEnum>(
      const <CaptainPayTableDtoOutputVehicleEnum>[
        _$captainPayTableDtoOutputVehicleEnum_walking,
        _$captainPayTableDtoOutputVehicleEnum_bicycle,
        _$captainPayTableDtoOutputVehicleEnum_motorbike,
        _$captainPayTableDtoOutputVehicleEnum_car,
      ],
    );

Serializer<CaptainPayTableDtoOutputVehicleEnum>
_$captainPayTableDtoOutputVehicleEnumSerializer =
    _$CaptainPayTableDtoOutputVehicleEnumSerializer();

class _$CaptainPayTableDtoOutputVehicleEnumSerializer
    implements PrimitiveSerializer<CaptainPayTableDtoOutputVehicleEnum> {
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
    CaptainPayTableDtoOutputVehicleEnum,
  ];
  @override
  final String wireName = 'CaptainPayTableDtoOutputVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainPayTableDtoOutputVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainPayTableDtoOutputVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainPayTableDtoOutputVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainPayTableDtoOutput extends CaptainPayTableDtoOutput {
  @override
  final CaptainPayTableDtoOutputVehicleEnum vehicle;
  @override
  final int waitingThresholdMin;
  @override
  final CaptainPayTableDtoOutputCurrent? current;
  @override
  final BuiltList<CaptainPayTableDtoOutputAnnouncedInner> announced;

  factory _$CaptainPayTableDtoOutput([
    void Function(CaptainPayTableDtoOutputBuilder)? updates,
  ]) => (CaptainPayTableDtoOutputBuilder()..update(updates))._build();

  _$CaptainPayTableDtoOutput._({
    required this.vehicle,
    required this.waitingThresholdMin,
    this.current,
    required this.announced,
  }) : super._();
  @override
  CaptainPayTableDtoOutput rebuild(
    void Function(CaptainPayTableDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPayTableDtoOutputBuilder toBuilder() =>
      CaptainPayTableDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPayTableDtoOutput &&
        vehicle == other.vehicle &&
        waitingThresholdMin == other.waitingThresholdMin &&
        current == other.current &&
        announced == other.announced;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, waitingThresholdMin.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, announced.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPayTableDtoOutput')
          ..add('vehicle', vehicle)
          ..add('waitingThresholdMin', waitingThresholdMin)
          ..add('current', current)
          ..add('announced', announced))
        .toString();
  }
}

class CaptainPayTableDtoOutputBuilder
    implements
        Builder<CaptainPayTableDtoOutput, CaptainPayTableDtoOutputBuilder> {
  _$CaptainPayTableDtoOutput? _$v;

  CaptainPayTableDtoOutputVehicleEnum? _vehicle;
  CaptainPayTableDtoOutputVehicleEnum? get vehicle => _$this._vehicle;
  set vehicle(CaptainPayTableDtoOutputVehicleEnum? vehicle) =>
      _$this._vehicle = vehicle;

  int? _waitingThresholdMin;
  int? get waitingThresholdMin => _$this._waitingThresholdMin;
  set waitingThresholdMin(int? waitingThresholdMin) =>
      _$this._waitingThresholdMin = waitingThresholdMin;

  CaptainPayTableDtoOutputCurrentBuilder? _current;
  CaptainPayTableDtoOutputCurrentBuilder get current =>
      _$this._current ??= CaptainPayTableDtoOutputCurrentBuilder();
  set current(CaptainPayTableDtoOutputCurrentBuilder? current) =>
      _$this._current = current;

  ListBuilder<CaptainPayTableDtoOutputAnnouncedInner>? _announced;
  ListBuilder<CaptainPayTableDtoOutputAnnouncedInner> get announced =>
      _$this._announced ??=
          ListBuilder<CaptainPayTableDtoOutputAnnouncedInner>();
  set announced(
    ListBuilder<CaptainPayTableDtoOutputAnnouncedInner>? announced,
  ) => _$this._announced = announced;

  CaptainPayTableDtoOutputBuilder() {
    CaptainPayTableDtoOutput._defaults(this);
  }

  CaptainPayTableDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicle = $v.vehicle;
      _waitingThresholdMin = $v.waitingThresholdMin;
      _current = $v.current?.toBuilder();
      _announced = $v.announced.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPayTableDtoOutput other) {
    _$v = other as _$CaptainPayTableDtoOutput;
  }

  @override
  void update(void Function(CaptainPayTableDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPayTableDtoOutput build() => _build();

  _$CaptainPayTableDtoOutput _build() {
    _$CaptainPayTableDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPayTableDtoOutput._(
            vehicle: BuiltValueNullFieldError.checkNotNull(
              vehicle,
              r'CaptainPayTableDtoOutput',
              'vehicle',
            ),
            waitingThresholdMin: BuiltValueNullFieldError.checkNotNull(
              waitingThresholdMin,
              r'CaptainPayTableDtoOutput',
              'waitingThresholdMin',
            ),
            current: _current?.build(),
            announced: announced.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        _current?.build();
        _$failedField = 'announced';
        announced.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPayTableDtoOutput',
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
