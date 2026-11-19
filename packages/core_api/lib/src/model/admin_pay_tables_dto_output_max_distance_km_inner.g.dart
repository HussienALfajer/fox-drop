// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_tables_dto_output_max_distance_km_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_walking =
    const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum._('walking');
const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_bicycle =
    const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum._('bicycle');
const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_motorbike =
    const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum._('motorbike');
const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_car =
    const AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum._('car');

AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumValueOf(String name) {
  switch (name) {
    case 'walking':
      return _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_walking;
    case 'bicycle':
      return _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_bicycle;
    case 'motorbike':
      return _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_motorbike;
    case 'car':
      return _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum>
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumValues =
    BuiltSet<AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum>(
      const <AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum>[
        _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_walking,
        _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_bicycle,
        _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_motorbike,
        _$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum_car,
      ],
    );

Serializer<AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum>
_$adminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumSerializer =
    _$AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumSerializer();

class _$AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnumSerializer
    implements
        PrimitiveSerializer<
          AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum
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
    AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum,
  ];
  @override
  final String wireName =
      'AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminPayTablesDtoOutputMaxDistanceKmInner
    extends AdminPayTablesDtoOutputMaxDistanceKmInner {
  @override
  final AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum vehicle;
  @override
  final num km;

  factory _$AdminPayTablesDtoOutputMaxDistanceKmInner([
    void Function(AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder)? updates,
  ]) => (AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder()..update(updates))
      ._build();

  _$AdminPayTablesDtoOutputMaxDistanceKmInner._({
    required this.vehicle,
    required this.km,
  }) : super._();
  @override
  AdminPayTablesDtoOutputMaxDistanceKmInner rebuild(
    void Function(AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder toBuilder() =>
      AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablesDtoOutputMaxDistanceKmInner &&
        vehicle == other.vehicle &&
        km == other.km;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, km.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPayTablesDtoOutputMaxDistanceKmInner',
          )
          ..add('vehicle', vehicle)
          ..add('km', km))
        .toString();
  }
}

class AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder
    implements
        Builder<
          AdminPayTablesDtoOutputMaxDistanceKmInner,
          AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder
        > {
  _$AdminPayTablesDtoOutputMaxDistanceKmInner? _$v;

  AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum? _vehicle;
  AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum? get vehicle =>
      _$this._vehicle;
  set vehicle(AdminPayTablesDtoOutputMaxDistanceKmInnerVehicleEnum? vehicle) =>
      _$this._vehicle = vehicle;

  num? _km;
  num? get km => _$this._km;
  set km(num? km) => _$this._km = km;

  AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder() {
    AdminPayTablesDtoOutputMaxDistanceKmInner._defaults(this);
  }

  AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicle = $v.vehicle;
      _km = $v.km;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayTablesDtoOutputMaxDistanceKmInner other) {
    _$v = other as _$AdminPayTablesDtoOutputMaxDistanceKmInner;
  }

  @override
  void update(
    void Function(AdminPayTablesDtoOutputMaxDistanceKmInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablesDtoOutputMaxDistanceKmInner build() => _build();

  _$AdminPayTablesDtoOutputMaxDistanceKmInner _build() {
    final _$result =
        _$v ??
        _$AdminPayTablesDtoOutputMaxDistanceKmInner._(
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'AdminPayTablesDtoOutputMaxDistanceKmInner',
            'vehicle',
          ),
          km: BuiltValueNullFieldError.checkNotNull(
            km,
            r'AdminPayTablesDtoOutputMaxDistanceKmInner',
            'km',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
