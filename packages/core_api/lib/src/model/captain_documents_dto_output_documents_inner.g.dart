// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_documents_dto_output_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnum_nationalId =
    const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._('nationalId');
const CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnum_personalPhoto =
    const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._('personalPhoto');
const CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnum_civilRegistry =
    const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._('civilRegistry');
const CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnum_criminalRecord =
    const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._('criminalRecord');
const CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnum_vehiclePapers =
    const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._('vehiclePapers');
const CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnum_drivingLicence =
    const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._('drivingLicence');

CaptainDocumentsDtoOutputDocumentsInnerKindEnum
_$captainDocumentsDtoOutputDocumentsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'nationalId':
      return _$captainDocumentsDtoOutputDocumentsInnerKindEnum_nationalId;
    case 'personalPhoto':
      return _$captainDocumentsDtoOutputDocumentsInnerKindEnum_personalPhoto;
    case 'civilRegistry':
      return _$captainDocumentsDtoOutputDocumentsInnerKindEnum_civilRegistry;
    case 'criminalRecord':
      return _$captainDocumentsDtoOutputDocumentsInnerKindEnum_criminalRecord;
    case 'vehiclePapers':
      return _$captainDocumentsDtoOutputDocumentsInnerKindEnum_vehiclePapers;
    case 'drivingLicence':
      return _$captainDocumentsDtoOutputDocumentsInnerKindEnum_drivingLicence;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainDocumentsDtoOutputDocumentsInnerKindEnum>
_$captainDocumentsDtoOutputDocumentsInnerKindEnumValues =
    BuiltSet<CaptainDocumentsDtoOutputDocumentsInnerKindEnum>(
      const <CaptainDocumentsDtoOutputDocumentsInnerKindEnum>[
        _$captainDocumentsDtoOutputDocumentsInnerKindEnum_nationalId,
        _$captainDocumentsDtoOutputDocumentsInnerKindEnum_personalPhoto,
        _$captainDocumentsDtoOutputDocumentsInnerKindEnum_civilRegistry,
        _$captainDocumentsDtoOutputDocumentsInnerKindEnum_criminalRecord,
        _$captainDocumentsDtoOutputDocumentsInnerKindEnum_vehiclePapers,
        _$captainDocumentsDtoOutputDocumentsInnerKindEnum_drivingLicence,
      ],
    );

const CaptainDocumentsDtoOutputDocumentsInnerStateEnum
_$captainDocumentsDtoOutputDocumentsInnerStateEnum_valid =
    const CaptainDocumentsDtoOutputDocumentsInnerStateEnum._('valid');
const CaptainDocumentsDtoOutputDocumentsInnerStateEnum
_$captainDocumentsDtoOutputDocumentsInnerStateEnum_expiring =
    const CaptainDocumentsDtoOutputDocumentsInnerStateEnum._('expiring');
const CaptainDocumentsDtoOutputDocumentsInnerStateEnum
_$captainDocumentsDtoOutputDocumentsInnerStateEnum_expired =
    const CaptainDocumentsDtoOutputDocumentsInnerStateEnum._('expired');
const CaptainDocumentsDtoOutputDocumentsInnerStateEnum
_$captainDocumentsDtoOutputDocumentsInnerStateEnum_missing =
    const CaptainDocumentsDtoOutputDocumentsInnerStateEnum._('missing');

CaptainDocumentsDtoOutputDocumentsInnerStateEnum
_$captainDocumentsDtoOutputDocumentsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'valid':
      return _$captainDocumentsDtoOutputDocumentsInnerStateEnum_valid;
    case 'expiring':
      return _$captainDocumentsDtoOutputDocumentsInnerStateEnum_expiring;
    case 'expired':
      return _$captainDocumentsDtoOutputDocumentsInnerStateEnum_expired;
    case 'missing':
      return _$captainDocumentsDtoOutputDocumentsInnerStateEnum_missing;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainDocumentsDtoOutputDocumentsInnerStateEnum>
_$captainDocumentsDtoOutputDocumentsInnerStateEnumValues =
    BuiltSet<CaptainDocumentsDtoOutputDocumentsInnerStateEnum>(
      const <CaptainDocumentsDtoOutputDocumentsInnerStateEnum>[
        _$captainDocumentsDtoOutputDocumentsInnerStateEnum_valid,
        _$captainDocumentsDtoOutputDocumentsInnerStateEnum_expiring,
        _$captainDocumentsDtoOutputDocumentsInnerStateEnum_expired,
        _$captainDocumentsDtoOutputDocumentsInnerStateEnum_missing,
      ],
    );

Serializer<CaptainDocumentsDtoOutputDocumentsInnerKindEnum>
_$captainDocumentsDtoOutputDocumentsInnerKindEnumSerializer =
    _$CaptainDocumentsDtoOutputDocumentsInnerKindEnumSerializer();
Serializer<CaptainDocumentsDtoOutputDocumentsInnerStateEnum>
_$captainDocumentsDtoOutputDocumentsInnerStateEnumSerializer =
    _$CaptainDocumentsDtoOutputDocumentsInnerStateEnumSerializer();

class _$CaptainDocumentsDtoOutputDocumentsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<CaptainDocumentsDtoOutputDocumentsInnerKindEnum> {
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
    CaptainDocumentsDtoOutputDocumentsInnerKindEnum,
  ];
  @override
  final String wireName = 'CaptainDocumentsDtoOutputDocumentsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainDocumentsDtoOutputDocumentsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainDocumentsDtoOutputDocumentsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainDocumentsDtoOutputDocumentsInnerStateEnumSerializer
    implements
        PrimitiveSerializer<CaptainDocumentsDtoOutputDocumentsInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'valid': 'valid',
    'expiring': 'expiring',
    'expired': 'expired',
    'missing': 'missing',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'valid': 'valid',
    'expiring': 'expiring',
    'expired': 'expired',
    'missing': 'missing',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainDocumentsDtoOutputDocumentsInnerStateEnum,
  ];
  @override
  final String wireName = 'CaptainDocumentsDtoOutputDocumentsInnerStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInnerStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainDocumentsDtoOutputDocumentsInnerStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainDocumentsDtoOutputDocumentsInnerStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainDocumentsDtoOutputDocumentsInner
    extends CaptainDocumentsDtoOutputDocumentsInner {
  @override
  final CaptainDocumentsDtoOutputDocumentsInnerKindEnum kind;
  @override
  final bool required_;
  @override
  final CaptainDocumentsDtoOutputDocumentsInnerStateEnum state;
  @override
  final CaptainDocumentsDtoOutputDocumentsInnerValid? valid;
  @override
  final CaptainDocumentsDtoOutputDocumentsInnerPending? pending;
  @override
  final CaptainDocumentsDtoOutputDocumentsInnerRejection? rejection;

  factory _$CaptainDocumentsDtoOutputDocumentsInner([
    void Function(CaptainDocumentsDtoOutputDocumentsInnerBuilder)? updates,
  ]) => (CaptainDocumentsDtoOutputDocumentsInnerBuilder()..update(updates))
      ._build();

  _$CaptainDocumentsDtoOutputDocumentsInner._({
    required this.kind,
    required this.required_,
    required this.state,
    this.valid,
    this.pending,
    this.rejection,
  }) : super._();
  @override
  CaptainDocumentsDtoOutputDocumentsInner rebuild(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDocumentsDtoOutputDocumentsInnerBuilder toBuilder() =>
      CaptainDocumentsDtoOutputDocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDocumentsDtoOutputDocumentsInner &&
        kind == other.kind &&
        required_ == other.required_ &&
        state == other.state &&
        valid == other.valid &&
        pending == other.pending &&
        rejection == other.rejection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, valid.hashCode);
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jc(_$hash, rejection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainDocumentsDtoOutputDocumentsInner',
          )
          ..add('kind', kind)
          ..add('required_', required_)
          ..add('state', state)
          ..add('valid', valid)
          ..add('pending', pending)
          ..add('rejection', rejection))
        .toString();
  }
}

class CaptainDocumentsDtoOutputDocumentsInnerBuilder
    implements
        Builder<
          CaptainDocumentsDtoOutputDocumentsInner,
          CaptainDocumentsDtoOutputDocumentsInnerBuilder
        > {
  _$CaptainDocumentsDtoOutputDocumentsInner? _$v;

  CaptainDocumentsDtoOutputDocumentsInnerKindEnum? _kind;
  CaptainDocumentsDtoOutputDocumentsInnerKindEnum? get kind => _$this._kind;
  set kind(CaptainDocumentsDtoOutputDocumentsInnerKindEnum? kind) =>
      _$this._kind = kind;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  CaptainDocumentsDtoOutputDocumentsInnerStateEnum? _state;
  CaptainDocumentsDtoOutputDocumentsInnerStateEnum? get state => _$this._state;
  set state(CaptainDocumentsDtoOutputDocumentsInnerStateEnum? state) =>
      _$this._state = state;

  CaptainDocumentsDtoOutputDocumentsInnerValidBuilder? _valid;
  CaptainDocumentsDtoOutputDocumentsInnerValidBuilder get valid =>
      _$this._valid ??= CaptainDocumentsDtoOutputDocumentsInnerValidBuilder();
  set valid(CaptainDocumentsDtoOutputDocumentsInnerValidBuilder? valid) =>
      _$this._valid = valid;

  CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder? _pending;
  CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder get pending =>
      _$this._pending ??=
          CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder();
  set pending(CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder? pending) =>
      _$this._pending = pending;

  CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder? _rejection;
  CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder get rejection =>
      _$this._rejection ??=
          CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder();
  set rejection(
    CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder? rejection,
  ) => _$this._rejection = rejection;

  CaptainDocumentsDtoOutputDocumentsInnerBuilder() {
    CaptainDocumentsDtoOutputDocumentsInner._defaults(this);
  }

  CaptainDocumentsDtoOutputDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _required_ = $v.required_;
      _state = $v.state;
      _valid = $v.valid?.toBuilder();
      _pending = $v.pending?.toBuilder();
      _rejection = $v.rejection?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDocumentsDtoOutputDocumentsInner other) {
    _$v = other as _$CaptainDocumentsDtoOutputDocumentsInner;
  }

  @override
  void update(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInner build() => _build();

  _$CaptainDocumentsDtoOutputDocumentsInner _build() {
    _$CaptainDocumentsDtoOutputDocumentsInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainDocumentsDtoOutputDocumentsInner._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'CaptainDocumentsDtoOutputDocumentsInner',
              'kind',
            ),
            required_: BuiltValueNullFieldError.checkNotNull(
              required_,
              r'CaptainDocumentsDtoOutputDocumentsInner',
              'required_',
            ),
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'CaptainDocumentsDtoOutputDocumentsInner',
              'state',
            ),
            valid: _valid?.build(),
            pending: _pending?.build(),
            rejection: _rejection?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'valid';
        _valid?.build();
        _$failedField = 'pending';
        _pending?.build();
        _$failedField = 'rejection';
        _rejection?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDocumentsDtoOutputDocumentsInner',
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
