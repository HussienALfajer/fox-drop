// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_custody.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputCustody
    extends CaptainAvailabilityDtoOutputCustody {
  @override
  final CaptainAvailabilityDtoOutputCustodyUsage usage;
  @override
  final CaptainAvailabilityDtoOutputCustodyLimit limit;
  @override
  final bool warn;
  @override
  final CaptainAvailabilityDtoOutputCustodyClosedDue closedDue;
  @override
  final DateTime lastCutoff;
  @override
  final CaptainAvailabilityDtoOutputCustodyRemitTolerance remitTolerance;
  @override
  final DateTime? handInGraceUntil;
  @override
  final DateTime? remitBy;

  factory _$CaptainAvailabilityDtoOutputCustody([
    void Function(CaptainAvailabilityDtoOutputCustodyBuilder)? updates,
  ]) =>
      (CaptainAvailabilityDtoOutputCustodyBuilder()..update(updates))._build();

  _$CaptainAvailabilityDtoOutputCustody._({
    required this.usage,
    required this.limit,
    required this.warn,
    required this.closedDue,
    required this.lastCutoff,
    required this.remitTolerance,
    this.handInGraceUntil,
    this.remitBy,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputCustody rebuild(
    void Function(CaptainAvailabilityDtoOutputCustodyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputCustodyBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputCustodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputCustody &&
        usage == other.usage &&
        limit == other.limit &&
        warn == other.warn &&
        closedDue == other.closedDue &&
        lastCutoff == other.lastCutoff &&
        remitTolerance == other.remitTolerance &&
        handInGraceUntil == other.handInGraceUntil &&
        remitBy == other.remitBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, warn.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jc(_$hash, lastCutoff.hashCode);
    _$hash = $jc(_$hash, remitTolerance.hashCode);
    _$hash = $jc(_$hash, handInGraceUntil.hashCode);
    _$hash = $jc(_$hash, remitBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainAvailabilityDtoOutputCustody')
          ..add('usage', usage)
          ..add('limit', limit)
          ..add('warn', warn)
          ..add('closedDue', closedDue)
          ..add('lastCutoff', lastCutoff)
          ..add('remitTolerance', remitTolerance)
          ..add('handInGraceUntil', handInGraceUntil)
          ..add('remitBy', remitBy))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputCustodyBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputCustody,
          CaptainAvailabilityDtoOutputCustodyBuilder
        > {
  _$CaptainAvailabilityDtoOutputCustody? _$v;

  CaptainAvailabilityDtoOutputCustodyUsageBuilder? _usage;
  CaptainAvailabilityDtoOutputCustodyUsageBuilder get usage =>
      _$this._usage ??= CaptainAvailabilityDtoOutputCustodyUsageBuilder();
  set usage(CaptainAvailabilityDtoOutputCustodyUsageBuilder? usage) =>
      _$this._usage = usage;

  CaptainAvailabilityDtoOutputCustodyLimitBuilder? _limit;
  CaptainAvailabilityDtoOutputCustodyLimitBuilder get limit =>
      _$this._limit ??= CaptainAvailabilityDtoOutputCustodyLimitBuilder();
  set limit(CaptainAvailabilityDtoOutputCustodyLimitBuilder? limit) =>
      _$this._limit = limit;

  bool? _warn;
  bool? get warn => _$this._warn;
  set warn(bool? warn) => _$this._warn = warn;

  CaptainAvailabilityDtoOutputCustodyClosedDueBuilder? _closedDue;
  CaptainAvailabilityDtoOutputCustodyClosedDueBuilder get closedDue =>
      _$this._closedDue ??=
          CaptainAvailabilityDtoOutputCustodyClosedDueBuilder();
  set closedDue(
    CaptainAvailabilityDtoOutputCustodyClosedDueBuilder? closedDue,
  ) => _$this._closedDue = closedDue;

  DateTime? _lastCutoff;
  DateTime? get lastCutoff => _$this._lastCutoff;
  set lastCutoff(DateTime? lastCutoff) => _$this._lastCutoff = lastCutoff;

  CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder? _remitTolerance;
  CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder get remitTolerance =>
      _$this._remitTolerance ??=
          CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder();
  set remitTolerance(
    CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder? remitTolerance,
  ) => _$this._remitTolerance = remitTolerance;

  DateTime? _handInGraceUntil;
  DateTime? get handInGraceUntil => _$this._handInGraceUntil;
  set handInGraceUntil(DateTime? handInGraceUntil) =>
      _$this._handInGraceUntil = handInGraceUntil;

  DateTime? _remitBy;
  DateTime? get remitBy => _$this._remitBy;
  set remitBy(DateTime? remitBy) => _$this._remitBy = remitBy;

  CaptainAvailabilityDtoOutputCustodyBuilder() {
    CaptainAvailabilityDtoOutputCustody._defaults(this);
  }

  CaptainAvailabilityDtoOutputCustodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usage = $v.usage.toBuilder();
      _limit = $v.limit.toBuilder();
      _warn = $v.warn;
      _closedDue = $v.closedDue.toBuilder();
      _lastCutoff = $v.lastCutoff;
      _remitTolerance = $v.remitTolerance.toBuilder();
      _handInGraceUntil = $v.handInGraceUntil;
      _remitBy = $v.remitBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputCustody other) {
    _$v = other as _$CaptainAvailabilityDtoOutputCustody;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputCustodyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputCustody build() => _build();

  _$CaptainAvailabilityDtoOutputCustody _build() {
    _$CaptainAvailabilityDtoOutputCustody _$result;
    try {
      _$result =
          _$v ??
          _$CaptainAvailabilityDtoOutputCustody._(
            usage: usage.build(),
            limit: limit.build(),
            warn: BuiltValueNullFieldError.checkNotNull(
              warn,
              r'CaptainAvailabilityDtoOutputCustody',
              'warn',
            ),
            closedDue: closedDue.build(),
            lastCutoff: BuiltValueNullFieldError.checkNotNull(
              lastCutoff,
              r'CaptainAvailabilityDtoOutputCustody',
              'lastCutoff',
            ),
            remitTolerance: remitTolerance.build(),
            handInGraceUntil: handInGraceUntil,
            remitBy: remitBy,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        usage.build();
        _$failedField = 'limit';
        limit.build();

        _$failedField = 'closedDue';
        closedDue.build();

        _$failedField = 'remitTolerance';
        remitTolerance.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainAvailabilityDtoOutputCustody',
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
