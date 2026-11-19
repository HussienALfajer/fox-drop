// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnum_online =
    const AdminCaptainProfileDtoOutputStatusEnum._('online');
const AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnum_busy =
    const AdminCaptainProfileDtoOutputStatusEnum._('busy');
const AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnum_offline =
    const AdminCaptainProfileDtoOutputStatusEnum._('offline');
const AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnum_suspended =
    const AdminCaptainProfileDtoOutputStatusEnum._('suspended');
const AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnum_cashBlocked =
    const AdminCaptainProfileDtoOutputStatusEnum._('cashBlocked');
const AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnum_terminated =
    const AdminCaptainProfileDtoOutputStatusEnum._('terminated');

AdminCaptainProfileDtoOutputStatusEnum
_$adminCaptainProfileDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'online':
      return _$adminCaptainProfileDtoOutputStatusEnum_online;
    case 'busy':
      return _$adminCaptainProfileDtoOutputStatusEnum_busy;
    case 'offline':
      return _$adminCaptainProfileDtoOutputStatusEnum_offline;
    case 'suspended':
      return _$adminCaptainProfileDtoOutputStatusEnum_suspended;
    case 'cashBlocked':
      return _$adminCaptainProfileDtoOutputStatusEnum_cashBlocked;
    case 'terminated':
      return _$adminCaptainProfileDtoOutputStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainProfileDtoOutputStatusEnum>
_$adminCaptainProfileDtoOutputStatusEnumValues =
    BuiltSet<AdminCaptainProfileDtoOutputStatusEnum>(
      const <AdminCaptainProfileDtoOutputStatusEnum>[
        _$adminCaptainProfileDtoOutputStatusEnum_online,
        _$adminCaptainProfileDtoOutputStatusEnum_busy,
        _$adminCaptainProfileDtoOutputStatusEnum_offline,
        _$adminCaptainProfileDtoOutputStatusEnum_suspended,
        _$adminCaptainProfileDtoOutputStatusEnum_cashBlocked,
        _$adminCaptainProfileDtoOutputStatusEnum_terminated,
      ],
    );

const AdminCaptainProfileDtoOutputContractPhaseEnum
_$adminCaptainProfileDtoOutputContractPhaseEnum_probation =
    const AdminCaptainProfileDtoOutputContractPhaseEnum._('probation');
const AdminCaptainProfileDtoOutputContractPhaseEnum
_$adminCaptainProfileDtoOutputContractPhaseEnum_commitment =
    const AdminCaptainProfileDtoOutputContractPhaseEnum._('commitment');
const AdminCaptainProfileDtoOutputContractPhaseEnum
_$adminCaptainProfileDtoOutputContractPhaseEnum_open =
    const AdminCaptainProfileDtoOutputContractPhaseEnum._('open');

AdminCaptainProfileDtoOutputContractPhaseEnum
_$adminCaptainProfileDtoOutputContractPhaseEnumValueOf(String name) {
  switch (name) {
    case 'probation':
      return _$adminCaptainProfileDtoOutputContractPhaseEnum_probation;
    case 'commitment':
      return _$adminCaptainProfileDtoOutputContractPhaseEnum_commitment;
    case 'open':
      return _$adminCaptainProfileDtoOutputContractPhaseEnum_open;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainProfileDtoOutputContractPhaseEnum>
_$adminCaptainProfileDtoOutputContractPhaseEnumValues =
    BuiltSet<AdminCaptainProfileDtoOutputContractPhaseEnum>(
      const <AdminCaptainProfileDtoOutputContractPhaseEnum>[
        _$adminCaptainProfileDtoOutputContractPhaseEnum_probation,
        _$adminCaptainProfileDtoOutputContractPhaseEnum_commitment,
        _$adminCaptainProfileDtoOutputContractPhaseEnum_open,
      ],
    );

Serializer<AdminCaptainProfileDtoOutputStatusEnum>
_$adminCaptainProfileDtoOutputStatusEnumSerializer =
    _$AdminCaptainProfileDtoOutputStatusEnumSerializer();
Serializer<AdminCaptainProfileDtoOutputContractPhaseEnum>
_$adminCaptainProfileDtoOutputContractPhaseEnumSerializer =
    _$AdminCaptainProfileDtoOutputContractPhaseEnumSerializer();

class _$AdminCaptainProfileDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputStatusEnum> {
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
    AdminCaptainProfileDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminCaptainProfileDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainProfileDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainProfileDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainProfileDtoOutputContractPhaseEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainProfileDtoOutputContractPhaseEnum> {
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
    AdminCaptainProfileDtoOutputContractPhaseEnum,
  ];
  @override
  final String wireName = 'AdminCaptainProfileDtoOutputContractPhaseEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputContractPhaseEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainProfileDtoOutputContractPhaseEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainProfileDtoOutputContractPhaseEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainProfileDtoOutput extends AdminCaptainProfileDtoOutput {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String vehicle;
  @override
  final String? plateNumber;
  @override
  final AdminCaptainProfileDtoOutputStatusEnum status;
  @override
  final AdminCaptainProfileDtoOutputSuspension? suspension;
  @override
  final String? applicationId;
  @override
  final AdminCaptainProfileDtoOutputContractPhaseEnum? contractPhase;
  @override
  final AdminCaptainProfileDtoOutputCustody custody;
  @override
  final AdminCaptainProfileDtoOutputEarnings earnings;
  @override
  final int ordersToday;
  @override
  final int delivered;
  @override
  final AdminCaptainProfileDtoOutputOnTime onTime;
  @override
  final int cancellations;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerAcceptance? acceptance;
  @override
  final AdminCaptainProfileDtoOutputRating? rating;
  @override
  final AdminCaptainProfileDtoOutputApp app;

  factory _$AdminCaptainProfileDtoOutput([
    void Function(AdminCaptainProfileDtoOutputBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainProfileDtoOutput._({
    required this.id,
    required this.cityId,
    required this.name,
    this.phone,
    required this.vehicle,
    this.plateNumber,
    required this.status,
    this.suspension,
    this.applicationId,
    this.contractPhase,
    required this.custody,
    required this.earnings,
    required this.ordersToday,
    required this.delivered,
    required this.onTime,
    required this.cancellations,
    this.acceptance,
    this.rating,
    required this.app,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutput rebuild(
    void Function(AdminCaptainProfileDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutput &&
        id == other.id &&
        cityId == other.cityId &&
        name == other.name &&
        phone == other.phone &&
        vehicle == other.vehicle &&
        plateNumber == other.plateNumber &&
        status == other.status &&
        suspension == other.suspension &&
        applicationId == other.applicationId &&
        contractPhase == other.contractPhase &&
        custody == other.custody &&
        earnings == other.earnings &&
        ordersToday == other.ordersToday &&
        delivered == other.delivered &&
        onTime == other.onTime &&
        cancellations == other.cancellations &&
        acceptance == other.acceptance &&
        rating == other.rating &&
        app == other.app;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jc(_$hash, plateNumber.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, suspension.hashCode);
    _$hash = $jc(_$hash, applicationId.hashCode);
    _$hash = $jc(_$hash, contractPhase.hashCode);
    _$hash = $jc(_$hash, custody.hashCode);
    _$hash = $jc(_$hash, earnings.hashCode);
    _$hash = $jc(_$hash, ordersToday.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, onTime.hashCode);
    _$hash = $jc(_$hash, cancellations.hashCode);
    _$hash = $jc(_$hash, acceptance.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, app.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainProfileDtoOutput')
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('name', name)
          ..add('phone', phone)
          ..add('vehicle', vehicle)
          ..add('plateNumber', plateNumber)
          ..add('status', status)
          ..add('suspension', suspension)
          ..add('applicationId', applicationId)
          ..add('contractPhase', contractPhase)
          ..add('custody', custody)
          ..add('earnings', earnings)
          ..add('ordersToday', ordersToday)
          ..add('delivered', delivered)
          ..add('onTime', onTime)
          ..add('cancellations', cancellations)
          ..add('acceptance', acceptance)
          ..add('rating', rating)
          ..add('app', app))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutput,
          AdminCaptainProfileDtoOutputBuilder
        > {
  _$AdminCaptainProfileDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _vehicle;
  String? get vehicle => _$this._vehicle;
  set vehicle(String? vehicle) => _$this._vehicle = vehicle;

  String? _plateNumber;
  String? get plateNumber => _$this._plateNumber;
  set plateNumber(String? plateNumber) => _$this._plateNumber = plateNumber;

  AdminCaptainProfileDtoOutputStatusEnum? _status;
  AdminCaptainProfileDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminCaptainProfileDtoOutputStatusEnum? status) =>
      _$this._status = status;

  AdminCaptainProfileDtoOutputSuspensionBuilder? _suspension;
  AdminCaptainProfileDtoOutputSuspensionBuilder get suspension =>
      _$this._suspension ??= AdminCaptainProfileDtoOutputSuspensionBuilder();
  set suspension(AdminCaptainProfileDtoOutputSuspensionBuilder? suspension) =>
      _$this._suspension = suspension;

  String? _applicationId;
  String? get applicationId => _$this._applicationId;
  set applicationId(String? applicationId) =>
      _$this._applicationId = applicationId;

  AdminCaptainProfileDtoOutputContractPhaseEnum? _contractPhase;
  AdminCaptainProfileDtoOutputContractPhaseEnum? get contractPhase =>
      _$this._contractPhase;
  set contractPhase(
    AdminCaptainProfileDtoOutputContractPhaseEnum? contractPhase,
  ) => _$this._contractPhase = contractPhase;

  AdminCaptainProfileDtoOutputCustodyBuilder? _custody;
  AdminCaptainProfileDtoOutputCustodyBuilder get custody =>
      _$this._custody ??= AdminCaptainProfileDtoOutputCustodyBuilder();
  set custody(AdminCaptainProfileDtoOutputCustodyBuilder? custody) =>
      _$this._custody = custody;

  AdminCaptainProfileDtoOutputEarningsBuilder? _earnings;
  AdminCaptainProfileDtoOutputEarningsBuilder get earnings =>
      _$this._earnings ??= AdminCaptainProfileDtoOutputEarningsBuilder();
  set earnings(AdminCaptainProfileDtoOutputEarningsBuilder? earnings) =>
      _$this._earnings = earnings;

  int? _ordersToday;
  int? get ordersToday => _$this._ordersToday;
  set ordersToday(int? ordersToday) => _$this._ordersToday = ordersToday;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  AdminCaptainProfileDtoOutputOnTimeBuilder? _onTime;
  AdminCaptainProfileDtoOutputOnTimeBuilder get onTime =>
      _$this._onTime ??= AdminCaptainProfileDtoOutputOnTimeBuilder();
  set onTime(AdminCaptainProfileDtoOutputOnTimeBuilder? onTime) =>
      _$this._onTime = onTime;

  int? _cancellations;
  int? get cancellations => _$this._cancellations;
  set cancellations(int? cancellations) =>
      _$this._cancellations = cancellations;

  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder? _acceptance;
  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder get acceptance =>
      _$this._acceptance ??=
          AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder();
  set acceptance(
    AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder? acceptance,
  ) => _$this._acceptance = acceptance;

  AdminCaptainProfileDtoOutputRatingBuilder? _rating;
  AdminCaptainProfileDtoOutputRatingBuilder get rating =>
      _$this._rating ??= AdminCaptainProfileDtoOutputRatingBuilder();
  set rating(AdminCaptainProfileDtoOutputRatingBuilder? rating) =>
      _$this._rating = rating;

  AdminCaptainProfileDtoOutputAppBuilder? _app;
  AdminCaptainProfileDtoOutputAppBuilder get app =>
      _$this._app ??= AdminCaptainProfileDtoOutputAppBuilder();
  set app(AdminCaptainProfileDtoOutputAppBuilder? app) => _$this._app = app;

  AdminCaptainProfileDtoOutputBuilder() {
    AdminCaptainProfileDtoOutput._defaults(this);
  }

  AdminCaptainProfileDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _name = $v.name;
      _phone = $v.phone;
      _vehicle = $v.vehicle;
      _plateNumber = $v.plateNumber;
      _status = $v.status;
      _suspension = $v.suspension?.toBuilder();
      _applicationId = $v.applicationId;
      _contractPhase = $v.contractPhase;
      _custody = $v.custody.toBuilder();
      _earnings = $v.earnings.toBuilder();
      _ordersToday = $v.ordersToday;
      _delivered = $v.delivered;
      _onTime = $v.onTime.toBuilder();
      _cancellations = $v.cancellations;
      _acceptance = $v.acceptance?.toBuilder();
      _rating = $v.rating?.toBuilder();
      _app = $v.app.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutput other) {
    _$v = other as _$AdminCaptainProfileDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainProfileDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutput build() => _build();

  _$AdminCaptainProfileDtoOutput _build() {
    _$AdminCaptainProfileDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainProfileDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCaptainProfileDtoOutput',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCaptainProfileDtoOutput',
              'cityId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminCaptainProfileDtoOutput',
              'name',
            ),
            phone: phone,
            vehicle: BuiltValueNullFieldError.checkNotNull(
              vehicle,
              r'AdminCaptainProfileDtoOutput',
              'vehicle',
            ),
            plateNumber: plateNumber,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminCaptainProfileDtoOutput',
              'status',
            ),
            suspension: _suspension?.build(),
            applicationId: applicationId,
            contractPhase: contractPhase,
            custody: custody.build(),
            earnings: earnings.build(),
            ordersToday: BuiltValueNullFieldError.checkNotNull(
              ordersToday,
              r'AdminCaptainProfileDtoOutput',
              'ordersToday',
            ),
            delivered: BuiltValueNullFieldError.checkNotNull(
              delivered,
              r'AdminCaptainProfileDtoOutput',
              'delivered',
            ),
            onTime: onTime.build(),
            cancellations: BuiltValueNullFieldError.checkNotNull(
              cancellations,
              r'AdminCaptainProfileDtoOutput',
              'cancellations',
            ),
            acceptance: _acceptance?.build(),
            rating: _rating?.build(),
            app: app.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'suspension';
        _suspension?.build();

        _$failedField = 'custody';
        custody.build();
        _$failedField = 'earnings';
        earnings.build();

        _$failedField = 'onTime';
        onTime.build();

        _$failedField = 'acceptance';
        _acceptance?.build();
        _$failedField = 'rating';
        _rating?.build();
        _$failedField = 'app';
        app.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainProfileDtoOutput',
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
