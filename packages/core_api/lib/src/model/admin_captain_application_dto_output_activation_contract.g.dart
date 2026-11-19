// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_contract.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
_$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_probation =
    const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum._(
      'probation',
    );
const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
_$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_commitment =
    const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum._(
      'commitment',
    );
const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
_$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_open =
    const AdminCaptainApplicationDtoOutputActivationContractPhaseEnum._('open');

AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
_$adminCaptainApplicationDtoOutputActivationContractPhaseEnumValueOf(
  String name,
) {
  switch (name) {
    case 'probation':
      return _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_probation;
    case 'commitment':
      return _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_commitment;
    case 'open':
      return _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_open;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationDtoOutputActivationContractPhaseEnum>
_$adminCaptainApplicationDtoOutputActivationContractPhaseEnumValues =
    BuiltSet<
      AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
    >(const <AdminCaptainApplicationDtoOutputActivationContractPhaseEnum>[
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_probation,
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_commitment,
      _$adminCaptainApplicationDtoOutputActivationContractPhaseEnum_open,
    ]);

const AdminCaptainApplicationDtoOutputActivationContractReviewEnum
_$adminCaptainApplicationDtoOutputActivationContractReviewEnum_none =
    const AdminCaptainApplicationDtoOutputActivationContractReviewEnum._(
      'none',
    );
const AdminCaptainApplicationDtoOutputActivationContractReviewEnum
_$adminCaptainApplicationDtoOutputActivationContractReviewEnum_due =
    const AdminCaptainApplicationDtoOutputActivationContractReviewEnum._('due');
const AdminCaptainApplicationDtoOutputActivationContractReviewEnum
_$adminCaptainApplicationDtoOutputActivationContractReviewEnum_overdue =
    const AdminCaptainApplicationDtoOutputActivationContractReviewEnum._(
      'overdue',
    );

AdminCaptainApplicationDtoOutputActivationContractReviewEnum
_$adminCaptainApplicationDtoOutputActivationContractReviewEnumValueOf(
  String name,
) {
  switch (name) {
    case 'none':
      return _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_none;
    case 'due':
      return _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_due;
    case 'overdue':
      return _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_overdue;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationDtoOutputActivationContractReviewEnum>
_$adminCaptainApplicationDtoOutputActivationContractReviewEnumValues =
    BuiltSet<AdminCaptainApplicationDtoOutputActivationContractReviewEnum>(
      const <AdminCaptainApplicationDtoOutputActivationContractReviewEnum>[
        _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_none,
        _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_due,
        _$adminCaptainApplicationDtoOutputActivationContractReviewEnum_overdue,
      ],
    );

Serializer<AdminCaptainApplicationDtoOutputActivationContractPhaseEnum>
_$adminCaptainApplicationDtoOutputActivationContractPhaseEnumSerializer =
    _$AdminCaptainApplicationDtoOutputActivationContractPhaseEnumSerializer();
Serializer<AdminCaptainApplicationDtoOutputActivationContractReviewEnum>
_$adminCaptainApplicationDtoOutputActivationContractReviewEnumSerializer =
    _$AdminCaptainApplicationDtoOutputActivationContractReviewEnumSerializer();

class _$AdminCaptainApplicationDtoOutputActivationContractPhaseEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputActivationContractPhaseEnum
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
    AdminCaptainApplicationDtoOutputActivationContractPhaseEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainApplicationDtoOutputActivationContractPhaseEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationContractPhaseEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationDtoOutputActivationContractPhaseEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationDtoOutputActivationContractPhaseEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationDtoOutputActivationContractReviewEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputActivationContractReviewEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'none': 'none',
    'due': 'due',
    'overdue': 'overdue',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'none': 'none',
    'due': 'due',
    'overdue': 'overdue',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainApplicationDtoOutputActivationContractReviewEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainApplicationDtoOutputActivationContractReviewEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationContractReviewEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationDtoOutputActivationContractReviewEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationDtoOutputActivationContractReviewEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationDtoOutputActivationContract
    extends AdminCaptainApplicationDtoOutputActivationContract {
  @override
  final Date signedOn;
  @override
  final Date startsOn;
  @override
  final int probationDays;
  @override
  final int commitmentMonths;
  @override
  final Date probationEndsOn;
  @override
  final Date commitmentStartsOn;
  @override
  final Date commitmentEndsOn;
  @override
  final Date? probationConfirmedOn;
  @override
  final AdminCaptainApplicationDtoOutputActivationContractPhaseEnum phase;
  @override
  final AdminCaptainApplicationDtoOutputActivationContractReviewEnum review;

  factory _$AdminCaptainApplicationDtoOutputActivationContract([
    void Function(AdminCaptainApplicationDtoOutputActivationContractBuilder)?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationContractBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationContract._({
    required this.signedOn,
    required this.startsOn,
    required this.probationDays,
    required this.commitmentMonths,
    required this.probationEndsOn,
    required this.commitmentStartsOn,
    required this.commitmentEndsOn,
    this.probationConfirmedOn,
    required this.phase,
    required this.review,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationContract rebuild(
    void Function(AdminCaptainApplicationDtoOutputActivationContractBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationContractBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationContractBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivationContract &&
        signedOn == other.signedOn &&
        startsOn == other.startsOn &&
        probationDays == other.probationDays &&
        commitmentMonths == other.commitmentMonths &&
        probationEndsOn == other.probationEndsOn &&
        commitmentStartsOn == other.commitmentStartsOn &&
        commitmentEndsOn == other.commitmentEndsOn &&
        probationConfirmedOn == other.probationConfirmedOn &&
        phase == other.phase &&
        review == other.review;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedOn.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, probationDays.hashCode);
    _$hash = $jc(_$hash, commitmentMonths.hashCode);
    _$hash = $jc(_$hash, probationEndsOn.hashCode);
    _$hash = $jc(_$hash, commitmentStartsOn.hashCode);
    _$hash = $jc(_$hash, commitmentEndsOn.hashCode);
    _$hash = $jc(_$hash, probationConfirmedOn.hashCode);
    _$hash = $jc(_$hash, phase.hashCode);
    _$hash = $jc(_$hash, review.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputActivationContract',
          )
          ..add('signedOn', signedOn)
          ..add('startsOn', startsOn)
          ..add('probationDays', probationDays)
          ..add('commitmentMonths', commitmentMonths)
          ..add('probationEndsOn', probationEndsOn)
          ..add('commitmentStartsOn', commitmentStartsOn)
          ..add('commitmentEndsOn', commitmentEndsOn)
          ..add('probationConfirmedOn', probationConfirmedOn)
          ..add('phase', phase)
          ..add('review', review))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationContractBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationContract,
          AdminCaptainApplicationDtoOutputActivationContractBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationContract? _$v;

  Date? _signedOn;
  Date? get signedOn => _$this._signedOn;
  set signedOn(Date? signedOn) => _$this._signedOn = signedOn;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  int? _probationDays;
  int? get probationDays => _$this._probationDays;
  set probationDays(int? probationDays) =>
      _$this._probationDays = probationDays;

  int? _commitmentMonths;
  int? get commitmentMonths => _$this._commitmentMonths;
  set commitmentMonths(int? commitmentMonths) =>
      _$this._commitmentMonths = commitmentMonths;

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

  Date? _probationConfirmedOn;
  Date? get probationConfirmedOn => _$this._probationConfirmedOn;
  set probationConfirmedOn(Date? probationConfirmedOn) =>
      _$this._probationConfirmedOn = probationConfirmedOn;

  AdminCaptainApplicationDtoOutputActivationContractPhaseEnum? _phase;
  AdminCaptainApplicationDtoOutputActivationContractPhaseEnum? get phase =>
      _$this._phase;
  set phase(
    AdminCaptainApplicationDtoOutputActivationContractPhaseEnum? phase,
  ) => _$this._phase = phase;

  AdminCaptainApplicationDtoOutputActivationContractReviewEnum? _review;
  AdminCaptainApplicationDtoOutputActivationContractReviewEnum? get review =>
      _$this._review;
  set review(
    AdminCaptainApplicationDtoOutputActivationContractReviewEnum? review,
  ) => _$this._review = review;

  AdminCaptainApplicationDtoOutputActivationContractBuilder() {
    AdminCaptainApplicationDtoOutputActivationContract._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationContractBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedOn = $v.signedOn;
      _startsOn = $v.startsOn;
      _probationDays = $v.probationDays;
      _commitmentMonths = $v.commitmentMonths;
      _probationEndsOn = $v.probationEndsOn;
      _commitmentStartsOn = $v.commitmentStartsOn;
      _commitmentEndsOn = $v.commitmentEndsOn;
      _probationConfirmedOn = $v.probationConfirmedOn;
      _phase = $v.phase;
      _review = $v.review;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputActivationContract other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivationContract;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputActivationContractBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationContract build() => _build();

  _$AdminCaptainApplicationDtoOutputActivationContract _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputActivationContract._(
          signedOn: BuiltValueNullFieldError.checkNotNull(
            signedOn,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'signedOn',
          ),
          startsOn: BuiltValueNullFieldError.checkNotNull(
            startsOn,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'startsOn',
          ),
          probationDays: BuiltValueNullFieldError.checkNotNull(
            probationDays,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'probationDays',
          ),
          commitmentMonths: BuiltValueNullFieldError.checkNotNull(
            commitmentMonths,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'commitmentMonths',
          ),
          probationEndsOn: BuiltValueNullFieldError.checkNotNull(
            probationEndsOn,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'probationEndsOn',
          ),
          commitmentStartsOn: BuiltValueNullFieldError.checkNotNull(
            commitmentStartsOn,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'commitmentStartsOn',
          ),
          commitmentEndsOn: BuiltValueNullFieldError.checkNotNull(
            commitmentEndsOn,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'commitmentEndsOn',
          ),
          probationConfirmedOn: probationConfirmedOn,
          phase: BuiltValueNullFieldError.checkNotNull(
            phase,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'phase',
          ),
          review: BuiltValueNullFieldError.checkNotNull(
            review,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'review',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
