// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_publish_pay_table_dto_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPublishPayTableDtoRatesInnerVehicleEnum
_$adminPublishPayTableDtoRatesInnerVehicleEnum_walking =
    const AdminPublishPayTableDtoRatesInnerVehicleEnum._('walking');
const AdminPublishPayTableDtoRatesInnerVehicleEnum
_$adminPublishPayTableDtoRatesInnerVehicleEnum_bicycle =
    const AdminPublishPayTableDtoRatesInnerVehicleEnum._('bicycle');
const AdminPublishPayTableDtoRatesInnerVehicleEnum
_$adminPublishPayTableDtoRatesInnerVehicleEnum_motorbike =
    const AdminPublishPayTableDtoRatesInnerVehicleEnum._('motorbike');
const AdminPublishPayTableDtoRatesInnerVehicleEnum
_$adminPublishPayTableDtoRatesInnerVehicleEnum_car =
    const AdminPublishPayTableDtoRatesInnerVehicleEnum._('car');

AdminPublishPayTableDtoRatesInnerVehicleEnum
_$adminPublishPayTableDtoRatesInnerVehicleEnumValueOf(String name) {
  switch (name) {
    case 'walking':
      return _$adminPublishPayTableDtoRatesInnerVehicleEnum_walking;
    case 'bicycle':
      return _$adminPublishPayTableDtoRatesInnerVehicleEnum_bicycle;
    case 'motorbike':
      return _$adminPublishPayTableDtoRatesInnerVehicleEnum_motorbike;
    case 'car':
      return _$adminPublishPayTableDtoRatesInnerVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPublishPayTableDtoRatesInnerVehicleEnum>
_$adminPublishPayTableDtoRatesInnerVehicleEnumValues =
    BuiltSet<AdminPublishPayTableDtoRatesInnerVehicleEnum>(
      const <AdminPublishPayTableDtoRatesInnerVehicleEnum>[
        _$adminPublishPayTableDtoRatesInnerVehicleEnum_walking,
        _$adminPublishPayTableDtoRatesInnerVehicleEnum_bicycle,
        _$adminPublishPayTableDtoRatesInnerVehicleEnum_motorbike,
        _$adminPublishPayTableDtoRatesInnerVehicleEnum_car,
      ],
    );

Serializer<AdminPublishPayTableDtoRatesInnerVehicleEnum>
_$adminPublishPayTableDtoRatesInnerVehicleEnumSerializer =
    _$AdminPublishPayTableDtoRatesInnerVehicleEnumSerializer();

class _$AdminPublishPayTableDtoRatesInnerVehicleEnumSerializer
    implements
        PrimitiveSerializer<AdminPublishPayTableDtoRatesInnerVehicleEnum> {
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
    AdminPublishPayTableDtoRatesInnerVehicleEnum,
  ];
  @override
  final String wireName = 'AdminPublishPayTableDtoRatesInnerVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminPublishPayTableDtoRatesInnerVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminPublishPayTableDtoRatesInnerVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminPublishPayTableDtoRatesInnerVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminPublishPayTableDtoRatesInner
    extends AdminPublishPayTableDtoRatesInner {
  @override
  final AdminPublishPayTableDtoRatesInnerVehicleEnum vehicle;
  @override
  final String basePay;
  @override
  final int includedMetres;
  @override
  final String perExtraKm;
  @override
  final String waitingPerMinute;
  @override
  final String minimumPay;

  factory _$AdminPublishPayTableDtoRatesInner([
    void Function(AdminPublishPayTableDtoRatesInnerBuilder)? updates,
  ]) => (AdminPublishPayTableDtoRatesInnerBuilder()..update(updates))._build();

  _$AdminPublishPayTableDtoRatesInner._({
    required this.vehicle,
    required this.basePay,
    required this.includedMetres,
    required this.perExtraKm,
    required this.waitingPerMinute,
    required this.minimumPay,
  }) : super._();
  @override
  AdminPublishPayTableDtoRatesInner rebuild(
    void Function(AdminPublishPayTableDtoRatesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPublishPayTableDtoRatesInnerBuilder toBuilder() =>
      AdminPublishPayTableDtoRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPublishPayTableDtoRatesInner &&
        vehicle == other.vehicle &&
        basePay == other.basePay &&
        includedMetres == other.includedMetres &&
        perExtraKm == other.perExtraKm &&
        waitingPerMinute == other.waitingPerMinute &&
        minimumPay == other.minimumPay;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, basePay.hashCode);
    _$hash = $jc(_$hash, includedMetres.hashCode);
    _$hash = $jc(_$hash, perExtraKm.hashCode);
    _$hash = $jc(_$hash, waitingPerMinute.hashCode);
    _$hash = $jc(_$hash, minimumPay.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPublishPayTableDtoRatesInner')
          ..add('vehicle', vehicle)
          ..add('basePay', basePay)
          ..add('includedMetres', includedMetres)
          ..add('perExtraKm', perExtraKm)
          ..add('waitingPerMinute', waitingPerMinute)
          ..add('minimumPay', minimumPay))
        .toString();
  }
}

class AdminPublishPayTableDtoRatesInnerBuilder
    implements
        Builder<
          AdminPublishPayTableDtoRatesInner,
          AdminPublishPayTableDtoRatesInnerBuilder
        > {
  _$AdminPublishPayTableDtoRatesInner? _$v;

  AdminPublishPayTableDtoRatesInnerVehicleEnum? _vehicle;
  AdminPublishPayTableDtoRatesInnerVehicleEnum? get vehicle => _$this._vehicle;
  set vehicle(AdminPublishPayTableDtoRatesInnerVehicleEnum? vehicle) =>
      _$this._vehicle = vehicle;

  String? _basePay;
  String? get basePay => _$this._basePay;
  set basePay(String? basePay) => _$this._basePay = basePay;

  int? _includedMetres;
  int? get includedMetres => _$this._includedMetres;
  set includedMetres(int? includedMetres) =>
      _$this._includedMetres = includedMetres;

  String? _perExtraKm;
  String? get perExtraKm => _$this._perExtraKm;
  set perExtraKm(String? perExtraKm) => _$this._perExtraKm = perExtraKm;

  String? _waitingPerMinute;
  String? get waitingPerMinute => _$this._waitingPerMinute;
  set waitingPerMinute(String? waitingPerMinute) =>
      _$this._waitingPerMinute = waitingPerMinute;

  String? _minimumPay;
  String? get minimumPay => _$this._minimumPay;
  set minimumPay(String? minimumPay) => _$this._minimumPay = minimumPay;

  AdminPublishPayTableDtoRatesInnerBuilder() {
    AdminPublishPayTableDtoRatesInner._defaults(this);
  }

  AdminPublishPayTableDtoRatesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicle = $v.vehicle;
      _basePay = $v.basePay;
      _includedMetres = $v.includedMetres;
      _perExtraKm = $v.perExtraKm;
      _waitingPerMinute = $v.waitingPerMinute;
      _minimumPay = $v.minimumPay;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPublishPayTableDtoRatesInner other) {
    _$v = other as _$AdminPublishPayTableDtoRatesInner;
  }

  @override
  void update(
    void Function(AdminPublishPayTableDtoRatesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPublishPayTableDtoRatesInner build() => _build();

  _$AdminPublishPayTableDtoRatesInner _build() {
    final _$result =
        _$v ??
        _$AdminPublishPayTableDtoRatesInner._(
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'AdminPublishPayTableDtoRatesInner',
            'vehicle',
          ),
          basePay: BuiltValueNullFieldError.checkNotNull(
            basePay,
            r'AdminPublishPayTableDtoRatesInner',
            'basePay',
          ),
          includedMetres: BuiltValueNullFieldError.checkNotNull(
            includedMetres,
            r'AdminPublishPayTableDtoRatesInner',
            'includedMetres',
          ),
          perExtraKm: BuiltValueNullFieldError.checkNotNull(
            perExtraKm,
            r'AdminPublishPayTableDtoRatesInner',
            'perExtraKm',
          ),
          waitingPerMinute: BuiltValueNullFieldError.checkNotNull(
            waitingPerMinute,
            r'AdminPublishPayTableDtoRatesInner',
            'waitingPerMinute',
          ),
          minimumPay: BuiltValueNullFieldError.checkNotNull(
            minimumPay,
            r'AdminPublishPayTableDtoRatesInner',
            'minimumPay',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
