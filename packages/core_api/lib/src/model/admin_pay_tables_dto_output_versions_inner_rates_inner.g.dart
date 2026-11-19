// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_tables_dto_output_versions_inner_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_walking =
    const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum._(
      'walking',
    );
const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_bicycle =
    const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum._(
      'bicycle',
    );
const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_motorbike =
    const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum._(
      'motorbike',
    );
const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_car =
    const AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum._('car');

AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'walking':
      return _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_walking;
    case 'bicycle':
      return _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_bicycle;
    case 'motorbike':
      return _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_motorbike;
    case 'car':
      return _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_car;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum>
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumValues =
    BuiltSet<AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum>(
      const <AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum>[
        _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_walking,
        _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_bicycle,
        _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_motorbike,
        _$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum_car,
      ],
    );

Serializer<AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum>
_$adminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumSerializer =
    _$AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumSerializer();

class _$AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnumSerializer
    implements
        PrimitiveSerializer<
          AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum
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
    AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum,
  ];
  @override
  final String wireName =
      'AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminPayTablesDtoOutputVersionsInnerRatesInner
    extends AdminPayTablesDtoOutputVersionsInnerRatesInner {
  @override
  final AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum vehicle;
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

  factory _$AdminPayTablesDtoOutputVersionsInnerRatesInner([
    void Function(AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder)?
    updates,
  ]) =>
      (AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder()..update(updates))
          ._build();

  _$AdminPayTablesDtoOutputVersionsInnerRatesInner._({
    required this.vehicle,
    required this.basePay,
    required this.includedMetres,
    required this.perExtraKm,
    required this.waitingPerMinute,
    required this.minimumPay,
  }) : super._();
  @override
  AdminPayTablesDtoOutputVersionsInnerRatesInner rebuild(
    void Function(AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder toBuilder() =>
      AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablesDtoOutputVersionsInnerRatesInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
          )
          ..add('vehicle', vehicle)
          ..add('basePay', basePay)
          ..add('includedMetres', includedMetres)
          ..add('perExtraKm', perExtraKm)
          ..add('waitingPerMinute', waitingPerMinute)
          ..add('minimumPay', minimumPay))
        .toString();
  }
}

class AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder
    implements
        Builder<
          AdminPayTablesDtoOutputVersionsInnerRatesInner,
          AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder
        > {
  _$AdminPayTablesDtoOutputVersionsInnerRatesInner? _$v;

  AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum? _vehicle;
  AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum? get vehicle =>
      _$this._vehicle;
  set vehicle(
    AdminPayTablesDtoOutputVersionsInnerRatesInnerVehicleEnum? vehicle,
  ) => _$this._vehicle = vehicle;

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

  AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder() {
    AdminPayTablesDtoOutputVersionsInnerRatesInner._defaults(this);
  }

  AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder get _$this {
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
  void replace(AdminPayTablesDtoOutputVersionsInnerRatesInner other) {
    _$v = other as _$AdminPayTablesDtoOutputVersionsInnerRatesInner;
  }

  @override
  void update(
    void Function(AdminPayTablesDtoOutputVersionsInnerRatesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablesDtoOutputVersionsInnerRatesInner build() => _build();

  _$AdminPayTablesDtoOutputVersionsInnerRatesInner _build() {
    final _$result =
        _$v ??
        _$AdminPayTablesDtoOutputVersionsInnerRatesInner._(
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
            'vehicle',
          ),
          basePay: BuiltValueNullFieldError.checkNotNull(
            basePay,
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
            'basePay',
          ),
          includedMetres: BuiltValueNullFieldError.checkNotNull(
            includedMetres,
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
            'includedMetres',
          ),
          perExtraKm: BuiltValueNullFieldError.checkNotNull(
            perExtraKm,
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
            'perExtraKm',
          ),
          waitingPerMinute: BuiltValueNullFieldError.checkNotNull(
            waitingPerMinute,
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
            'waitingPerMinute',
          ),
          minimumPay: BuiltValueNullFieldError.checkNotNull(
            minimumPay,
            r'AdminPayTablesDtoOutputVersionsInnerRatesInner',
            'minimumPay',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
