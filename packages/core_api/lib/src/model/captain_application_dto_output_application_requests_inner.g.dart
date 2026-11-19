// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_dto_output_application_requests_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_nationalId =
    const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
      'nationalId',
    );
const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_personalPhoto =
    const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
      'personalPhoto',
    );
const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_civilRegistry =
    const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
      'civilRegistry',
    );
const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_criminalRecord =
    const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
      'criminalRecord',
    );
const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_vehiclePapers =
    const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
      'vehiclePapers',
    );
const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_drivingLicence =
    const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
      'drivingLicence',
    );

CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'nationalId':
      return _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_nationalId;
    case 'personalPhoto':
      return _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_personalPhoto;
    case 'civilRegistry':
      return _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_civilRegistry;
    case 'criminalRecord':
      return _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_criminalRecord;
    case 'vehiclePapers':
      return _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_vehiclePapers;
    case 'drivingLicence':
      return _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_drivingLicence;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum>
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnumValues =
    BuiltSet<
      CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
    >(const <CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum>[
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_nationalId,
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_personalPhoto,
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_civilRegistry,
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_criminalRecord,
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_vehiclePapers,
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_drivingLicence,
    ]);

Serializer<CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum>
_$captainApplicationDtoOutputApplicationRequestsInnerKindEnumSerializer =
    _$CaptainApplicationDtoOutputApplicationRequestsInnerKindEnumSerializer();

class _$CaptainApplicationDtoOutputApplicationRequestsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
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
    CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum,
  ];
  @override
  final String wireName =
      'CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainApplicationDtoOutputApplicationRequestsInner
    extends CaptainApplicationDtoOutputApplicationRequestsInner {
  @override
  final CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum kind;
  @override
  final String reason;
  @override
  final DateTime requestedAt;

  factory _$CaptainApplicationDtoOutputApplicationRequestsInner([
    void Function(CaptainApplicationDtoOutputApplicationRequestsInnerBuilder)?
    updates,
  ]) =>
      (CaptainApplicationDtoOutputApplicationRequestsInnerBuilder()
            ..update(updates))
          ._build();

  _$CaptainApplicationDtoOutputApplicationRequestsInner._({
    required this.kind,
    required this.reason,
    required this.requestedAt,
  }) : super._();
  @override
  CaptainApplicationDtoOutputApplicationRequestsInner rebuild(
    void Function(CaptainApplicationDtoOutputApplicationRequestsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationDtoOutputApplicationRequestsInnerBuilder toBuilder() =>
      CaptainApplicationDtoOutputApplicationRequestsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationDtoOutputApplicationRequestsInner &&
        kind == other.kind &&
        reason == other.reason &&
        requestedAt == other.requestedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainApplicationDtoOutputApplicationRequestsInner',
          )
          ..add('kind', kind)
          ..add('reason', reason)
          ..add('requestedAt', requestedAt))
        .toString();
  }
}

class CaptainApplicationDtoOutputApplicationRequestsInnerBuilder
    implements
        Builder<
          CaptainApplicationDtoOutputApplicationRequestsInner,
          CaptainApplicationDtoOutputApplicationRequestsInnerBuilder
        > {
  _$CaptainApplicationDtoOutputApplicationRequestsInner? _$v;

  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum? _kind;
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  CaptainApplicationDtoOutputApplicationRequestsInnerBuilder() {
    CaptainApplicationDtoOutputApplicationRequestsInner._defaults(this);
  }

  CaptainApplicationDtoOutputApplicationRequestsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _reason = $v.reason;
      _requestedAt = $v.requestedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationDtoOutputApplicationRequestsInner other) {
    _$v = other as _$CaptainApplicationDtoOutputApplicationRequestsInner;
  }

  @override
  void update(
    void Function(CaptainApplicationDtoOutputApplicationRequestsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationDtoOutputApplicationRequestsInner build() => _build();

  _$CaptainApplicationDtoOutputApplicationRequestsInner _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationDtoOutputApplicationRequestsInner._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'CaptainApplicationDtoOutputApplicationRequestsInner',
            'kind',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainApplicationDtoOutputApplicationRequestsInner',
            'reason',
          ),
          requestedAt: BuiltValueNullFieldError.checkNotNull(
            requestedAt,
            r'CaptainApplicationDtoOutputApplicationRequestsInner',
            'requestedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
