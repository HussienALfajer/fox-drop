// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_emergency_stop_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantEmergencyStopDtoOutput extends MerchantEmergencyStopDtoOutput {
  @override
  final bool active;
  @override
  final DateTime? startedAt;

  factory _$MerchantEmergencyStopDtoOutput([
    void Function(MerchantEmergencyStopDtoOutputBuilder)? updates,
  ]) => (MerchantEmergencyStopDtoOutputBuilder()..update(updates))._build();

  _$MerchantEmergencyStopDtoOutput._({required this.active, this.startedAt})
    : super._();
  @override
  MerchantEmergencyStopDtoOutput rebuild(
    void Function(MerchantEmergencyStopDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantEmergencyStopDtoOutputBuilder toBuilder() =>
      MerchantEmergencyStopDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantEmergencyStopDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantEmergencyStopDtoOutput')
          ..add('active', active)
          ..add('startedAt', startedAt))
        .toString();
  }
}

class MerchantEmergencyStopDtoOutputBuilder
    implements
        Builder<
          MerchantEmergencyStopDtoOutput,
          MerchantEmergencyStopDtoOutputBuilder
        > {
  _$MerchantEmergencyStopDtoOutput? _$v;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  MerchantEmergencyStopDtoOutputBuilder() {
    MerchantEmergencyStopDtoOutput._defaults(this);
  }

  MerchantEmergencyStopDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _startedAt = $v.startedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantEmergencyStopDtoOutput other) {
    _$v = other as _$MerchantEmergencyStopDtoOutput;
  }

  @override
  void update(void Function(MerchantEmergencyStopDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantEmergencyStopDtoOutput build() => _build();

  _$MerchantEmergencyStopDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantEmergencyStopDtoOutput._(
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'MerchantEmergencyStopDtoOutput',
            'active',
          ),
          startedAt: startedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
