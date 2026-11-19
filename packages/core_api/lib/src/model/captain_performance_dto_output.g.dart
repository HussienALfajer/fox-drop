// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_performance_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPerformanceDtoOutput extends CaptainPerformanceDtoOutput {
  @override
  final CaptainPerformanceDtoOutputAcceptance acceptance;
  @override
  final AdminCaptainProfileDtoOutputOnTime onTime;
  @override
  final int cancellations;
  @override
  final int windowDays;
  @override
  final CaptainPerformanceDtoOutputOnline online;
  @override
  final BuiltList<CaptainPerformanceDtoOutputViolationsInner> violations;

  factory _$CaptainPerformanceDtoOutput([
    void Function(CaptainPerformanceDtoOutputBuilder)? updates,
  ]) => (CaptainPerformanceDtoOutputBuilder()..update(updates))._build();

  _$CaptainPerformanceDtoOutput._({
    required this.acceptance,
    required this.onTime,
    required this.cancellations,
    required this.windowDays,
    required this.online,
    required this.violations,
  }) : super._();
  @override
  CaptainPerformanceDtoOutput rebuild(
    void Function(CaptainPerformanceDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPerformanceDtoOutputBuilder toBuilder() =>
      CaptainPerformanceDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPerformanceDtoOutput &&
        acceptance == other.acceptance &&
        onTime == other.onTime &&
        cancellations == other.cancellations &&
        windowDays == other.windowDays &&
        online == other.online &&
        violations == other.violations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptance.hashCode);
    _$hash = $jc(_$hash, onTime.hashCode);
    _$hash = $jc(_$hash, cancellations.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jc(_$hash, online.hashCode);
    _$hash = $jc(_$hash, violations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPerformanceDtoOutput')
          ..add('acceptance', acceptance)
          ..add('onTime', onTime)
          ..add('cancellations', cancellations)
          ..add('windowDays', windowDays)
          ..add('online', online)
          ..add('violations', violations))
        .toString();
  }
}

class CaptainPerformanceDtoOutputBuilder
    implements
        Builder<
          CaptainPerformanceDtoOutput,
          CaptainPerformanceDtoOutputBuilder
        > {
  _$CaptainPerformanceDtoOutput? _$v;

  CaptainPerformanceDtoOutputAcceptanceBuilder? _acceptance;
  CaptainPerformanceDtoOutputAcceptanceBuilder get acceptance =>
      _$this._acceptance ??= CaptainPerformanceDtoOutputAcceptanceBuilder();
  set acceptance(CaptainPerformanceDtoOutputAcceptanceBuilder? acceptance) =>
      _$this._acceptance = acceptance;

  AdminCaptainProfileDtoOutputOnTimeBuilder? _onTime;
  AdminCaptainProfileDtoOutputOnTimeBuilder get onTime =>
      _$this._onTime ??= AdminCaptainProfileDtoOutputOnTimeBuilder();
  set onTime(AdminCaptainProfileDtoOutputOnTimeBuilder? onTime) =>
      _$this._onTime = onTime;

  int? _cancellations;
  int? get cancellations => _$this._cancellations;
  set cancellations(int? cancellations) =>
      _$this._cancellations = cancellations;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  CaptainPerformanceDtoOutputOnlineBuilder? _online;
  CaptainPerformanceDtoOutputOnlineBuilder get online =>
      _$this._online ??= CaptainPerformanceDtoOutputOnlineBuilder();
  set online(CaptainPerformanceDtoOutputOnlineBuilder? online) =>
      _$this._online = online;

  ListBuilder<CaptainPerformanceDtoOutputViolationsInner>? _violations;
  ListBuilder<CaptainPerformanceDtoOutputViolationsInner> get violations =>
      _$this._violations ??=
          ListBuilder<CaptainPerformanceDtoOutputViolationsInner>();
  set violations(
    ListBuilder<CaptainPerformanceDtoOutputViolationsInner>? violations,
  ) => _$this._violations = violations;

  CaptainPerformanceDtoOutputBuilder() {
    CaptainPerformanceDtoOutput._defaults(this);
  }

  CaptainPerformanceDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptance = $v.acceptance.toBuilder();
      _onTime = $v.onTime.toBuilder();
      _cancellations = $v.cancellations;
      _windowDays = $v.windowDays;
      _online = $v.online.toBuilder();
      _violations = $v.violations.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPerformanceDtoOutput other) {
    _$v = other as _$CaptainPerformanceDtoOutput;
  }

  @override
  void update(void Function(CaptainPerformanceDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPerformanceDtoOutput build() => _build();

  _$CaptainPerformanceDtoOutput _build() {
    _$CaptainPerformanceDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPerformanceDtoOutput._(
            acceptance: acceptance.build(),
            onTime: onTime.build(),
            cancellations: BuiltValueNullFieldError.checkNotNull(
              cancellations,
              r'CaptainPerformanceDtoOutput',
              'cancellations',
            ),
            windowDays: BuiltValueNullFieldError.checkNotNull(
              windowDays,
              r'CaptainPerformanceDtoOutput',
              'windowDays',
            ),
            online: online.build(),
            violations: violations.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceptance';
        acceptance.build();
        _$failedField = 'onTime';
        onTime.build();

        _$failedField = 'online';
        online.build();
        _$failedField = 'violations';
        violations.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPerformanceDtoOutput',
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
