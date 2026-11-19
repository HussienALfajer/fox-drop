// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnum_online =
    const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._('online');
const AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnum_busy =
    const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._('busy');
const AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnum_offline =
    const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._('offline');
const AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnum_suspended =
    const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._('suspended');
const AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnum_cashBlocked =
    const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._('cashBlocked');
const AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnum_terminated =
    const AdminCaptainListDtoOutputCaptainsInnerStatusEnum._('terminated');

AdminCaptainListDtoOutputCaptainsInnerStatusEnum
_$adminCaptainListDtoOutputCaptainsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'online':
      return _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_online;
    case 'busy':
      return _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_busy;
    case 'offline':
      return _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_offline;
    case 'suspended':
      return _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_suspended;
    case 'cashBlocked':
      return _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_cashBlocked;
    case 'terminated':
      return _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainListDtoOutputCaptainsInnerStatusEnum>
_$adminCaptainListDtoOutputCaptainsInnerStatusEnumValues =
    BuiltSet<AdminCaptainListDtoOutputCaptainsInnerStatusEnum>(
      const <AdminCaptainListDtoOutputCaptainsInnerStatusEnum>[
        _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_online,
        _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_busy,
        _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_offline,
        _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_suspended,
        _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_cashBlocked,
        _$adminCaptainListDtoOutputCaptainsInnerStatusEnum_terminated,
      ],
    );

const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
_$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_probation =
    const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum._(
      'probation',
    );
const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
_$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_commitment =
    const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum._(
      'commitment',
    );
const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
_$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_open =
    const AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum._('open');

AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
_$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnumValueOf(String name) {
  switch (name) {
    case 'probation':
      return _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_probation;
    case 'commitment':
      return _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_commitment;
    case 'open':
      return _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_open;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum>
_$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnumValues =
    BuiltSet<AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum>(
      const <AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum>[
        _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_probation,
        _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_commitment,
        _$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnum_open,
      ],
    );

Serializer<AdminCaptainListDtoOutputCaptainsInnerStatusEnum>
_$adminCaptainListDtoOutputCaptainsInnerStatusEnumSerializer =
    _$AdminCaptainListDtoOutputCaptainsInnerStatusEnumSerializer();
Serializer<AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum>
_$adminCaptainListDtoOutputCaptainsInnerContractPhaseEnumSerializer =
    _$AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnumSerializer();

class _$AdminCaptainListDtoOutputCaptainsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainListDtoOutputCaptainsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'online': 'online',
    'busy': 'busy',
    'offline': 'offline',
    'suspended': 'suspended',
    'cashBlocked': 'cash_blocked',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'online': 'online',
    'busy': 'busy',
    'offline': 'offline',
    'suspended': 'suspended',
    'cash_blocked': 'cashBlocked',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainListDtoOutputCaptainsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminCaptainListDtoOutputCaptainsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainListDtoOutputCaptainsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainListDtoOutputCaptainsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'probation': 'probation',
    'commitment': 'commitment',
    'open': 'open',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'probation': 'probation',
    'commitment': 'commitment',
    'open': 'open',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainListDtoOutputCaptainsInner
    extends AdminCaptainListDtoOutputCaptainsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? maskedPhone;
  @override
  final String vehicle;
  @override
  final String? plateNumber;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerStatusEnum status;
  @override
  final String? applicationId;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum? contractPhase;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustody custody;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerEarnings earnings;
  @override
  final int ordersToday;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerAcceptance? acceptance;
  @override
  final num? ratingAverage;
  @override
  final int ratingCount;

  factory _$AdminCaptainListDtoOutputCaptainsInner([
    void Function(AdminCaptainListDtoOutputCaptainsInnerBuilder)? updates,
  ]) => (AdminCaptainListDtoOutputCaptainsInnerBuilder()..update(updates))
      ._build();

  _$AdminCaptainListDtoOutputCaptainsInner._({
    required this.id,
    required this.name,
    this.maskedPhone,
    required this.vehicle,
    this.plateNumber,
    required this.status,
    this.applicationId,
    this.contractPhase,
    required this.custody,
    required this.earnings,
    required this.ordersToday,
    this.acceptance,
    this.ratingAverage,
    required this.ratingCount,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInner rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInner &&
        id == other.id &&
        name == other.name &&
        maskedPhone == other.maskedPhone &&
        vehicle == other.vehicle &&
        plateNumber == other.plateNumber &&
        status == other.status &&
        applicationId == other.applicationId &&
        contractPhase == other.contractPhase &&
        custody == other.custody &&
        earnings == other.earnings &&
        ordersToday == other.ordersToday &&
        acceptance == other.acceptance &&
        ratingAverage == other.ratingAverage &&
        ratingCount == other.ratingCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, maskedPhone.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, plateNumber.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, contractPhase.hashCode);
    _$hash = $jc(_$hash, custody.hashCode);
    _$hash = $jc(_$hash, earnings.hashCode);
    _$hash = $jc(_$hash, ordersToday.hashCode);
    _$hash = $jc(_$hash, acceptance.hashCode);
    _$hash = $jc(_$hash, ratingAverage.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainListDtoOutputCaptainsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('maskedPhone', maskedPhone)
          ..add('vehicle', vehicle)
          ..add('plateNumber', plateNumber)
          ..add('status', status)
          ..add('applicationId', applicationId)
          ..add('contractPhase', contractPhase)
          ..add('custody', custody)
          ..add('earnings', earnings)
          ..add('ordersToday', ordersToday)
          ..add('acceptance', acceptance)
          ..add('ratingAverage', ratingAverage)
          ..add('ratingCount', ratingCount))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInner,
          AdminCaptainListDtoOutputCaptainsInnerBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _maskedPhone;
  String? get maskedPhone => _$this._maskedPhone;
  set maskedPhone(String? maskedPhone) => _$this._maskedPhone = maskedPhone;

  String? _vehicle;
  String? get vehicle => _$this._vehicle;
  set vehicle(String? vehicle) => _$this._vehicle = vehicle;

  String? _plateNumber;
  String? get plateNumber => _$this._plateNumber;
  set plateNumber(String? plateNumber) => _$this._plateNumber = plateNumber;

  AdminCaptainListDtoOutputCaptainsInnerStatusEnum? _status;
  AdminCaptainListDtoOutputCaptainsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminCaptainListDtoOutputCaptainsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum? _contractPhase;
  AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum? get contractPhase =>
      _$this._contractPhase;
  set contractPhase(
    AdminCaptainListDtoOutputCaptainsInnerContractPhaseEnum? contractPhase,
  ) => _$this._contractPhase = contractPhase;

  AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder? _custody;
  AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder get custody =>
      _$this._custody ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder();
  set custody(AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder? custody) =>
      _$this._custody = custody;

  AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder? _earnings;
  AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder get earnings =>
      _$this._earnings ??=
          AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder();
  set earnings(
    AdminCaptainListDtoOutputCaptainsInnerEarningsBuilder? earnings,
  ) => _$this._earnings = earnings;

  int? _ordersToday;
  int? get ordersToday => _$this._ordersToday;
  set ordersToday(int? ordersToday) => _$this._ordersToday = ordersToday;

  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder? _acceptance;
  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder get acceptance =>
      _$this._acceptance ??=
          AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder();
  set acceptance(
    AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder? acceptance,
  ) => _$this._acceptance = acceptance;

  num? _ratingAverage;
  num? get ratingAverage => _$this._ratingAverage;
  set ratingAverage(num? ratingAverage) =>
      _$this._ratingAverage = ratingAverage;

  int? _ratingCount;
  int? get ratingCount => _$this._ratingCount;
  set ratingCount(int? ratingCount) => _$this._ratingCount = ratingCount;

  AdminCaptainListDtoOutputCaptainsInnerBuilder() {
    AdminCaptainListDtoOutputCaptainsInner._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _maskedPhone = $v.maskedPhone;
      _vehicle = $v.vehicle;
      _plateNumber = $v.plateNumber;
      _status = $v.status;
      _applicationId = $v.applicationId;
      _contractPhase = $v.contractPhase;
      _custody = $v.custody.toBuilder();
      _earnings = $v.earnings.toBuilder();
      _ordersToday = $v.ordersToday;
      _acceptance = $v.acceptance?.toBuilder();
      _ratingAverage = $v.ratingAverage;
      _ratingCount = $v.ratingCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInner other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInner;
  }

  @override
  void update(
    void Function(AdminCaptainListDtoOutputCaptainsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInner build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInner _build() {
    _$AdminCaptainListDtoOutputCaptainsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainListDtoOutputCaptainsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCaptainListDtoOutputCaptainsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminCaptainListDtoOutputCaptainsInner',
              'name',
            ),
            maskedPhone: maskedPhone,
            vehicle: BuiltValueNullFieldError.checkNotNull(
              vehicle,
              r'AdminCaptainListDtoOutputCaptainsInner',
              'vehicle',
            ),
            plateNumber: plateNumber,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminCaptainListDtoOutputCaptainsInner',
              'status',
            ),
            applicationId: applicationId,
            contractPhase: contractPhase,
            custody: custody.build(),
            earnings: earnings.build(),
            ordersToday: BuiltValueNullFieldError.checkNotNull(
              ordersToday,
              r'AdminCaptainListDtoOutputCaptainsInner',
              'ordersToday',
            ),
            acceptance: _acceptance?.build(),
            ratingAverage: ratingAverage,
            ratingCount: BuiltValueNullFieldError.checkNotNull(
              ratingCount,
              r'AdminCaptainListDtoOutputCaptainsInner',
              'ratingCount',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custody';
        custody.build();
        _$failedField = 'earnings';
        earnings.build();

        _$failedField = 'acceptance';
        _acceptance?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainListDtoOutputCaptainsInner',
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
