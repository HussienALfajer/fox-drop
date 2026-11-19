// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_contract.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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
  final Date commitmentEndsOn;

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
    required this.commitmentEndsOn,
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
        commitmentEndsOn == other.commitmentEndsOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedOn.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, probationDays.hashCode);
    _$hash = $jc(_$hash, commitmentMonths.hashCode);
    _$hash = $jc(_$hash, probationEndsOn.hashCode);
    _$hash = $jc(_$hash, commitmentEndsOn.hashCode);
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
          ..add('commitmentEndsOn', commitmentEndsOn))
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

  Date? _commitmentEndsOn;
  Date? get commitmentEndsOn => _$this._commitmentEndsOn;
  set commitmentEndsOn(Date? commitmentEndsOn) =>
      _$this._commitmentEndsOn = commitmentEndsOn;

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
      _commitmentEndsOn = $v.commitmentEndsOn;
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
          commitmentEndsOn: BuiltValueNullFieldError.checkNotNull(
            commitmentEndsOn,
            r'AdminCaptainApplicationDtoOutputActivationContract',
            'commitmentEndsOn',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
