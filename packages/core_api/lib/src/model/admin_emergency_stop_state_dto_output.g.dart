// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_emergency_stop_state_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEmergencyStopStateDtoOutput
    extends AdminEmergencyStopStateDtoOutput {
  @override
  final AdminEmergencyStopStateDtoOutputStop? stop;
  @override
  final AdminEmergencyStopStateDtoOutputDefaults defaults;

  factory _$AdminEmergencyStopStateDtoOutput([
    void Function(AdminEmergencyStopStateDtoOutputBuilder)? updates,
  ]) => (AdminEmergencyStopStateDtoOutputBuilder()..update(updates))._build();

  _$AdminEmergencyStopStateDtoOutput._({this.stop, required this.defaults})
    : super._();
  @override
  AdminEmergencyStopStateDtoOutput rebuild(
    void Function(AdminEmergencyStopStateDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEmergencyStopStateDtoOutputBuilder toBuilder() =>
      AdminEmergencyStopStateDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmergencyStopStateDtoOutput &&
        stop == other.stop &&
        defaults == other.defaults;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stop.hashCode);
    _$hash = $jc(_$hash, defaults.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEmergencyStopStateDtoOutput')
          ..add('stop', stop)
          ..add('defaults', defaults))
        .toString();
  }
}

class AdminEmergencyStopStateDtoOutputBuilder
    implements
        Builder<
          AdminEmergencyStopStateDtoOutput,
          AdminEmergencyStopStateDtoOutputBuilder
        > {
  _$AdminEmergencyStopStateDtoOutput? _$v;

  AdminEmergencyStopStateDtoOutputStopBuilder? _stop;
  AdminEmergencyStopStateDtoOutputStopBuilder get stop =>
      _$this._stop ??= AdminEmergencyStopStateDtoOutputStopBuilder();
  set stop(AdminEmergencyStopStateDtoOutputStopBuilder? stop) =>
      _$this._stop = stop;

  AdminEmergencyStopStateDtoOutputDefaultsBuilder? _defaults;
  AdminEmergencyStopStateDtoOutputDefaultsBuilder get defaults =>
      _$this._defaults ??= AdminEmergencyStopStateDtoOutputDefaultsBuilder();
  set defaults(AdminEmergencyStopStateDtoOutputDefaultsBuilder? defaults) =>
      _$this._defaults = defaults;

  AdminEmergencyStopStateDtoOutputBuilder() {
    AdminEmergencyStopStateDtoOutput._defaults(this);
  }

  AdminEmergencyStopStateDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stop = $v.stop?.toBuilder();
      _defaults = $v.defaults.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmergencyStopStateDtoOutput other) {
    _$v = other as _$AdminEmergencyStopStateDtoOutput;
  }

  @override
  void update(void Function(AdminEmergencyStopStateDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmergencyStopStateDtoOutput build() => _build();

  _$AdminEmergencyStopStateDtoOutput _build() {
    _$AdminEmergencyStopStateDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminEmergencyStopStateDtoOutput._(
            stop: _stop?.build(),
            defaults: defaults.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stop';
        _stop?.build();
        _$failedField = 'defaults';
        defaults.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEmergencyStopStateDtoOutput',
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
