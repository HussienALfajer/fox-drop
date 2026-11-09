// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_emergency_stop_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEmergencyStopDtoOutput extends AdminEmergencyStopDtoOutput {
  @override
  final AdminEmergencyStopDtoOutputStop stop;

  factory _$AdminEmergencyStopDtoOutput([
    void Function(AdminEmergencyStopDtoOutputBuilder)? updates,
  ]) => (AdminEmergencyStopDtoOutputBuilder()..update(updates))._build();

  _$AdminEmergencyStopDtoOutput._({required this.stop}) : super._();
  @override
  AdminEmergencyStopDtoOutput rebuild(
    void Function(AdminEmergencyStopDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEmergencyStopDtoOutputBuilder toBuilder() =>
      AdminEmergencyStopDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmergencyStopDtoOutput && stop == other.stop;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stop.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminEmergencyStopDtoOutput',
    )..add('stop', stop)).toString();
  }
}

class AdminEmergencyStopDtoOutputBuilder
    implements
        Builder<
          AdminEmergencyStopDtoOutput,
          AdminEmergencyStopDtoOutputBuilder
        > {
  _$AdminEmergencyStopDtoOutput? _$v;

  AdminEmergencyStopDtoOutputStopBuilder? _stop;
  AdminEmergencyStopDtoOutputStopBuilder get stop =>
      _$this._stop ??= AdminEmergencyStopDtoOutputStopBuilder();
  set stop(AdminEmergencyStopDtoOutputStopBuilder? stop) => _$this._stop = stop;

  AdminEmergencyStopDtoOutputBuilder() {
    AdminEmergencyStopDtoOutput._defaults(this);
  }

  AdminEmergencyStopDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stop = $v.stop.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmergencyStopDtoOutput other) {
    _$v = other as _$AdminEmergencyStopDtoOutput;
  }

  @override
  void update(void Function(AdminEmergencyStopDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmergencyStopDtoOutput build() => _build();

  _$AdminEmergencyStopDtoOutput _build() {
    _$AdminEmergencyStopDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminEmergencyStopDtoOutput._(stop: stop.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stop';
        stop.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEmergencyStopDtoOutput',
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
