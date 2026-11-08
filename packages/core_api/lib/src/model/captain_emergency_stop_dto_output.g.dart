// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_emergency_stop_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainEmergencyStopDtoOutput extends CaptainEmergencyStopDtoOutput {
  @override
  final bool active;
  @override
  final DateTime? startedAt;

  factory _$CaptainEmergencyStopDtoOutput([
    void Function(CaptainEmergencyStopDtoOutputBuilder)? updates,
  ]) => (CaptainEmergencyStopDtoOutputBuilder()..update(updates))._build();

  _$CaptainEmergencyStopDtoOutput._({required this.active, this.startedAt})
    : super._();
  @override
  CaptainEmergencyStopDtoOutput rebuild(
    void Function(CaptainEmergencyStopDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEmergencyStopDtoOutputBuilder toBuilder() =>
      CaptainEmergencyStopDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEmergencyStopDtoOutput &&
        active == other.active &&
        startedAt == other.startedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainEmergencyStopDtoOutput')
          ..add('active', active)
          ..add('startedAt', startedAt))
        .toString();
  }
}

class CaptainEmergencyStopDtoOutputBuilder
    implements
        Builder<
          CaptainEmergencyStopDtoOutput,
          CaptainEmergencyStopDtoOutputBuilder
        > {
  _$CaptainEmergencyStopDtoOutput? _$v;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  CaptainEmergencyStopDtoOutputBuilder() {
    CaptainEmergencyStopDtoOutput._defaults(this);
  }

  CaptainEmergencyStopDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _startedAt = $v.startedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainEmergencyStopDtoOutput other) {
    _$v = other as _$CaptainEmergencyStopDtoOutput;
  }

  @override
  void update(void Function(CaptainEmergencyStopDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEmergencyStopDtoOutput build() => _build();

  _$CaptainEmergencyStopDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainEmergencyStopDtoOutput._(
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'CaptainEmergencyStopDtoOutput',
            'active',
          ),
          startedAt: startedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
