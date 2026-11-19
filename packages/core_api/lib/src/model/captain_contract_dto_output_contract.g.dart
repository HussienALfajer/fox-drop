// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_contract_dto_output_contract.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainContractDtoOutputContractPhaseEnum
_$captainContractDtoOutputContractPhaseEnum_probation =
    const CaptainContractDtoOutputContractPhaseEnum._('probation');
const CaptainContractDtoOutputContractPhaseEnum
_$captainContractDtoOutputContractPhaseEnum_commitment =
    const CaptainContractDtoOutputContractPhaseEnum._('commitment');
const CaptainContractDtoOutputContractPhaseEnum
_$captainContractDtoOutputContractPhaseEnum_open =
    const CaptainContractDtoOutputContractPhaseEnum._('open');

CaptainContractDtoOutputContractPhaseEnum
_$captainContractDtoOutputContractPhaseEnumValueOf(String name) {
  switch (name) {
    case 'probation':
      return _$captainContractDtoOutputContractPhaseEnum_probation;
    case 'commitment':
      return _$captainContractDtoOutputContractPhaseEnum_commitment;
    case 'open':
      return _$captainContractDtoOutputContractPhaseEnum_open;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainContractDtoOutputContractPhaseEnum>
_$captainContractDtoOutputContractPhaseEnumValues =
    BuiltSet<CaptainContractDtoOutputContractPhaseEnum>(
      const <CaptainContractDtoOutputContractPhaseEnum>[
        _$captainContractDtoOutputContractPhaseEnum_probation,
        _$captainContractDtoOutputContractPhaseEnum_commitment,
        _$captainContractDtoOutputContractPhaseEnum_open,
      ],
    );

Serializer<CaptainContractDtoOutputContractPhaseEnum>
_$captainContractDtoOutputContractPhaseEnumSerializer =
    _$CaptainContractDtoOutputContractPhaseEnumSerializer();

class _$CaptainContractDtoOutputContractPhaseEnumSerializer
    implements PrimitiveSerializer<CaptainContractDtoOutputContractPhaseEnum> {
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
    CaptainContractDtoOutputContractPhaseEnum,
  ];
  @override
  final String wireName = 'CaptainContractDtoOutputContractPhaseEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainContractDtoOutputContractPhaseEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainContractDtoOutputContractPhaseEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainContractDtoOutputContractPhaseEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainContractDtoOutputContract
    extends CaptainContractDtoOutputContract {
  @override
  final Date signedOn;
  @override
  final Date startsOn;
  @override
  final Date probationEndsOn;
  @override
  final Date commitmentStartsOn;
  @override
  final Date commitmentEndsOn;
  @override
  final bool probationConfirmed;
  @override
  final CaptainContractDtoOutputContractPhaseEnum phase;

  factory _$CaptainContractDtoOutputContract([
    void Function(CaptainContractDtoOutputContractBuilder)? updates,
  ]) => (CaptainContractDtoOutputContractBuilder()..update(updates))._build();

  _$CaptainContractDtoOutputContract._({
    required this.signedOn,
    required this.startsOn,
    required this.probationEndsOn,
    required this.commitmentStartsOn,
    required this.commitmentEndsOn,
    required this.probationConfirmed,
    required this.phase,
  }) : super._();
  @override
  CaptainContractDtoOutputContract rebuild(
    void Function(CaptainContractDtoOutputContractBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainContractDtoOutputContractBuilder toBuilder() =>
      CaptainContractDtoOutputContractBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainContractDtoOutputContract &&
        signedOn == other.signedOn &&
        startsOn == other.startsOn &&
        probationEndsOn == other.probationEndsOn &&
        commitmentStartsOn == other.commitmentStartsOn &&
        commitmentEndsOn == other.commitmentEndsOn &&
        probationConfirmed == other.probationConfirmed &&
        phase == other.phase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedOn.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, probationEndsOn.hashCode);
    _$hash = $jc(_$hash, commitmentStartsOn.hashCode);
    _$hash = $jc(_$hash, commitmentEndsOn.hashCode);
    _$hash = $jc(_$hash, probationConfirmed.hashCode);
    _$hash = $jc(_$hash, phase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainContractDtoOutputContract')
          ..add('signedOn', signedOn)
          ..add('startsOn', startsOn)
          ..add('probationEndsOn', probationEndsOn)
          ..add('commitmentStartsOn', commitmentStartsOn)
          ..add('commitmentEndsOn', commitmentEndsOn)
          ..add('probationConfirmed', probationConfirmed)
          ..add('phase', phase))
        .toString();
  }
}

class CaptainContractDtoOutputContractBuilder
    implements
        Builder<
          CaptainContractDtoOutputContract,
          CaptainContractDtoOutputContractBuilder
        > {
  _$CaptainContractDtoOutputContract? _$v;

  Date? _signedOn;
  Date? get signedOn => _$this._signedOn;
  set signedOn(Date? signedOn) => _$this._signedOn = signedOn;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  Date? _probationEndsOn;
  Date? get probationEndsOn => _$this._probationEndsOn;
  set probationEndsOn(Date? probationEndsOn) =>
      _$this._probationEndsOn = probationEndsOn;

  Date? _commitmentStartsOn;
  Date? get commitmentStartsOn => _$this._commitmentStartsOn;
  set commitmentStartsOn(Date? commitmentStartsOn) =>
      _$this._commitmentStartsOn = commitmentStartsOn;

  Date? _commitmentEndsOn;
  Date? get commitmentEndsOn => _$this._commitmentEndsOn;
  set commitmentEndsOn(Date? commitmentEndsOn) =>
      _$this._commitmentEndsOn = commitmentEndsOn;

  bool? _probationConfirmed;
  bool? get probationConfirmed => _$this._probationConfirmed;
  set probationConfirmed(bool? probationConfirmed) =>
      _$this._probationConfirmed = probationConfirmed;

  CaptainContractDtoOutputContractPhaseEnum? _phase;
  CaptainContractDtoOutputContractPhaseEnum? get phase => _$this._phase;
  set phase(CaptainContractDtoOutputContractPhaseEnum? phase) =>
      _$this._phase = phase;

  CaptainContractDtoOutputContractBuilder() {
    CaptainContractDtoOutputContract._defaults(this);
  }

  CaptainContractDtoOutputContractBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedOn = $v.signedOn;
      _startsOn = $v.startsOn;
      _probationEndsOn = $v.probationEndsOn;
      _commitmentStartsOn = $v.commitmentStartsOn;
      _commitmentEndsOn = $v.commitmentEndsOn;
      _probationConfirmed = $v.probationConfirmed;
      _phase = $v.phase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainContractDtoOutputContract other) {
    _$v = other as _$CaptainContractDtoOutputContract;
  }

  @override
  void update(void Function(CaptainContractDtoOutputContractBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainContractDtoOutputContract build() => _build();

  _$CaptainContractDtoOutputContract _build() {
    final _$result =
        _$v ??
        _$CaptainContractDtoOutputContract._(
          signedOn: BuiltValueNullFieldError.checkNotNull(
            signedOn,
            r'CaptainContractDtoOutputContract',
            'signedOn',
          ),
          startsOn: BuiltValueNullFieldError.checkNotNull(
            startsOn,
            r'CaptainContractDtoOutputContract',
            'startsOn',
          ),
          probationEndsOn: BuiltValueNullFieldError.checkNotNull(
            probationEndsOn,
            r'CaptainContractDtoOutputContract',
            'probationEndsOn',
          ),
          commitmentStartsOn: BuiltValueNullFieldError.checkNotNull(
            commitmentStartsOn,
            r'CaptainContractDtoOutputContract',
            'commitmentStartsOn',
          ),
          commitmentEndsOn: BuiltValueNullFieldError.checkNotNull(
            commitmentEndsOn,
            r'CaptainContractDtoOutputContract',
            'commitmentEndsOn',
          ),
          probationConfirmed: BuiltValueNullFieldError.checkNotNull(
            probationConfirmed,
            r'CaptainContractDtoOutputContract',
            'probationConfirmed',
          ),
          phase: BuiltValueNullFieldError.checkNotNull(
            phase,
            r'CaptainContractDtoOutputContract',
            'phase',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
