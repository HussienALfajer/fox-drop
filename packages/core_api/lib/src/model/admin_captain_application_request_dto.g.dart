// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnum_nationalId =
    const AdminCaptainApplicationRequestDtoKindEnum._('nationalId');
const AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnum_personalPhoto =
    const AdminCaptainApplicationRequestDtoKindEnum._('personalPhoto');
const AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnum_civilRegistry =
    const AdminCaptainApplicationRequestDtoKindEnum._('civilRegistry');
const AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnum_criminalRecord =
    const AdminCaptainApplicationRequestDtoKindEnum._('criminalRecord');
const AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnum_vehiclePapers =
    const AdminCaptainApplicationRequestDtoKindEnum._('vehiclePapers');
const AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnum_drivingLicence =
    const AdminCaptainApplicationRequestDtoKindEnum._('drivingLicence');

AdminCaptainApplicationRequestDtoKindEnum
_$adminCaptainApplicationRequestDtoKindEnumValueOf(String name) {
  switch (name) {
    case 'nationalId':
      return _$adminCaptainApplicationRequestDtoKindEnum_nationalId;
    case 'personalPhoto':
      return _$adminCaptainApplicationRequestDtoKindEnum_personalPhoto;
    case 'civilRegistry':
      return _$adminCaptainApplicationRequestDtoKindEnum_civilRegistry;
    case 'criminalRecord':
      return _$adminCaptainApplicationRequestDtoKindEnum_criminalRecord;
    case 'vehiclePapers':
      return _$adminCaptainApplicationRequestDtoKindEnum_vehiclePapers;
    case 'drivingLicence':
      return _$adminCaptainApplicationRequestDtoKindEnum_drivingLicence;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationRequestDtoKindEnum>
_$adminCaptainApplicationRequestDtoKindEnumValues =
    BuiltSet<AdminCaptainApplicationRequestDtoKindEnum>(
      const <AdminCaptainApplicationRequestDtoKindEnum>[
        _$adminCaptainApplicationRequestDtoKindEnum_nationalId,
        _$adminCaptainApplicationRequestDtoKindEnum_personalPhoto,
        _$adminCaptainApplicationRequestDtoKindEnum_civilRegistry,
        _$adminCaptainApplicationRequestDtoKindEnum_criminalRecord,
        _$adminCaptainApplicationRequestDtoKindEnum_vehiclePapers,
        _$adminCaptainApplicationRequestDtoKindEnum_drivingLicence,
      ],
    );

Serializer<AdminCaptainApplicationRequestDtoKindEnum>
_$adminCaptainApplicationRequestDtoKindEnumSerializer =
    _$AdminCaptainApplicationRequestDtoKindEnumSerializer();

class _$AdminCaptainApplicationRequestDtoKindEnumSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationRequestDtoKindEnum> {
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
    AdminCaptainApplicationRequestDtoKindEnum,
  ];
  @override
  final String wireName = 'AdminCaptainApplicationRequestDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationRequestDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationRequestDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationRequestDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationRequestDto
    extends AdminCaptainApplicationRequestDto {
  @override
  final AdminCaptainApplicationRequestDtoKindEnum kind;
  @override
  final String reason;

  factory _$AdminCaptainApplicationRequestDto([
    void Function(AdminCaptainApplicationRequestDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationRequestDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationRequestDto._({
    required this.kind,
    required this.reason,
  }) : super._();
  @override
  AdminCaptainApplicationRequestDto rebuild(
    void Function(AdminCaptainApplicationRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationRequestDtoBuilder toBuilder() =>
      AdminCaptainApplicationRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationRequestDto &&
        kind == other.kind &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainApplicationRequestDto')
          ..add('kind', kind)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCaptainApplicationRequestDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationRequestDto,
          AdminCaptainApplicationRequestDtoBuilder
        > {
  _$AdminCaptainApplicationRequestDto? _$v;

  AdminCaptainApplicationRequestDtoKindEnum? _kind;
  AdminCaptainApplicationRequestDtoKindEnum? get kind => _$this._kind;
  set kind(AdminCaptainApplicationRequestDtoKindEnum? kind) =>
      _$this._kind = kind;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainApplicationRequestDtoBuilder() {
    AdminCaptainApplicationRequestDto._defaults(this);
  }

  AdminCaptainApplicationRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationRequestDto other) {
    _$v = other as _$AdminCaptainApplicationRequestDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationRequestDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationRequestDto build() => _build();

  _$AdminCaptainApplicationRequestDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationRequestDto._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCaptainApplicationRequestDto',
            'kind',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainApplicationRequestDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
