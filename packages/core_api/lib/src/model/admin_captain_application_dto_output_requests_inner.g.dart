// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_requests_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_nationalId =
    const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._('nationalId');
const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_personalPhoto =
    const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._(
      'personalPhoto',
    );
const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_civilRegistry =
    const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._(
      'civilRegistry',
    );
const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_criminalRecord =
    const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._(
      'criminalRecord',
    );
const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_vehiclePapers =
    const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._(
      'vehiclePapers',
    );
const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_drivingLicence =
    const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._(
      'drivingLicence',
    );

AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'nationalId':
      return _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_nationalId;
    case 'personalPhoto':
      return _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_personalPhoto;
    case 'civilRegistry':
      return _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_civilRegistry;
    case 'criminalRecord':
      return _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_criminalRecord;
    case 'vehiclePapers':
      return _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_vehiclePapers;
    case 'drivingLicence':
      return _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_drivingLicence;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationDtoOutputRequestsInnerKindEnum>
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnumValues =
    BuiltSet<AdminCaptainApplicationDtoOutputRequestsInnerKindEnum>(
      const <AdminCaptainApplicationDtoOutputRequestsInnerKindEnum>[
        _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_nationalId,
        _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_personalPhoto,
        _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_civilRegistry,
        _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_criminalRecord,
        _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_vehiclePapers,
        _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_drivingLicence,
      ],
    );

Serializer<AdminCaptainApplicationDtoOutputRequestsInnerKindEnum>
_$adminCaptainApplicationDtoOutputRequestsInnerKindEnumSerializer =
    _$AdminCaptainApplicationDtoOutputRequestsInnerKindEnumSerializer();

class _$AdminCaptainApplicationDtoOutputRequestsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nationalId': 'national_id',
    'personalPhoto': 'personal_photo',
    'civilRegistry': 'civil_registry',
    'criminalRecord': 'criminal_record',
    'vehiclePapers': 'vehicle_papers',
    'drivingLicence': 'driving_licence',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'national_id': 'nationalId',
    'personal_photo': 'personalPhoto',
    'civil_registry': 'civilRegistry',
    'criminal_record': 'criminalRecord',
    'vehicle_papers': 'vehiclePapers',
    'driving_licence': 'drivingLicence',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainApplicationDtoOutputRequestsInnerKindEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainApplicationDtoOutputRequestsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputRequestsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationDtoOutputRequestsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationDtoOutputRequestsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationDtoOutputRequestsInner
    extends AdminCaptainApplicationDtoOutputRequestsInner {
  @override
  final AdminCaptainApplicationDtoOutputRequestsInnerKindEnum kind;
  @override
  final String reason;
  @override
  final DateTime requestedAt;
  @override
  final String? requestedBy;

  factory _$AdminCaptainApplicationDtoOutputRequestsInner([
    void Function(AdminCaptainApplicationDtoOutputRequestsInnerBuilder)?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputRequestsInnerBuilder()..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputRequestsInner._({
    required this.kind,
    required this.reason,
    required this.requestedAt,
    this.requestedBy,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputRequestsInner rebuild(
    void Function(AdminCaptainApplicationDtoOutputRequestsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputRequestsInnerBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputRequestsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputRequestsInner &&
        kind == other.kind &&
        reason == other.reason &&
        requestedAt == other.requestedAt &&
        requestedBy == other.requestedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, requestedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputRequestsInner',
          )
          ..add('kind', kind)
          ..add('reason', reason)
          ..add('requestedAt', requestedAt)
          ..add('requestedBy', requestedBy))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputRequestsInnerBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputRequestsInner,
          AdminCaptainApplicationDtoOutputRequestsInnerBuilder
        > {
  _$AdminCaptainApplicationDtoOutputRequestsInner? _$v;

  AdminCaptainApplicationDtoOutputRequestsInnerKindEnum? _kind;
  AdminCaptainApplicationDtoOutputRequestsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(AdminCaptainApplicationDtoOutputRequestsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  String? _requestedBy;
  String? get requestedBy => _$this._requestedBy;
  set requestedBy(String? requestedBy) => _$this._requestedBy = requestedBy;

  AdminCaptainApplicationDtoOutputRequestsInnerBuilder() {
    AdminCaptainApplicationDtoOutputRequestsInner._defaults(this);
  }

  AdminCaptainApplicationDtoOutputRequestsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _reason = $v.reason;
      _requestedAt = $v.requestedAt;
      _requestedBy = $v.requestedBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputRequestsInner other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputRequestsInner;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputRequestsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputRequestsInner build() => _build();

  _$AdminCaptainApplicationDtoOutputRequestsInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputRequestsInner._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCaptainApplicationDtoOutputRequestsInner',
            'kind',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainApplicationDtoOutputRequestsInner',
            'reason',
          ),
          requestedAt: BuiltValueNullFieldError.checkNotNull(
            requestedAt,
            r'AdminCaptainApplicationDtoOutputRequestsInner',
            'requestedAt',
          ),
          requestedBy: requestedBy,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
