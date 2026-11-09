// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_emergency_stop_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerEmergencyStopDtoOutput extends CustomerEmergencyStopDtoOutput {
  @override
  final bool active;
  @override
  final DateTime? startedAt;
  @override
  final String? browseMessage;
  @override
  final String? delayNotice;

  factory _$CustomerEmergencyStopDtoOutput([
    void Function(CustomerEmergencyStopDtoOutputBuilder)? updates,
  ]) => (CustomerEmergencyStopDtoOutputBuilder()..update(updates))._build();

  _$CustomerEmergencyStopDtoOutput._({
    required this.active,
    this.startedAt,
    this.browseMessage,
    this.delayNotice,
  }) : super._();
  @override
  CustomerEmergencyStopDtoOutput rebuild(
    void Function(CustomerEmergencyStopDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerEmergencyStopDtoOutputBuilder toBuilder() =>
      CustomerEmergencyStopDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerEmergencyStopDtoOutput &&
        active == other.active &&
        startedAt == other.startedAt &&
        browseMessage == other.browseMessage &&
        delayNotice == other.delayNotice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, browseMessage.hashCode);
    _$hash = $jc(_$hash, delayNotice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerEmergencyStopDtoOutput')
          ..add('active', active)
          ..add('startedAt', startedAt)
          ..add('browseMessage', browseMessage)
          ..add('delayNotice', delayNotice))
        .toString();
  }
}

class CustomerEmergencyStopDtoOutputBuilder
    implements
        Builder<
          CustomerEmergencyStopDtoOutput,
          CustomerEmergencyStopDtoOutputBuilder
        > {
  _$CustomerEmergencyStopDtoOutput? _$v;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  String? _browseMessage;
  String? get browseMessage => _$this._browseMessage;
  set browseMessage(String? browseMessage) =>
      _$this._browseMessage = browseMessage;

  String? _delayNotice;
  String? get delayNotice => _$this._delayNotice;
  set delayNotice(String? delayNotice) => _$this._delayNotice = delayNotice;

  CustomerEmergencyStopDtoOutputBuilder() {
    CustomerEmergencyStopDtoOutput._defaults(this);
  }

  CustomerEmergencyStopDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _startedAt = $v.startedAt;
      _browseMessage = $v.browseMessage;
      _delayNotice = $v.delayNotice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerEmergencyStopDtoOutput other) {
    _$v = other as _$CustomerEmergencyStopDtoOutput;
  }

  @override
  void update(void Function(CustomerEmergencyStopDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerEmergencyStopDtoOutput build() => _build();

  _$CustomerEmergencyStopDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerEmergencyStopDtoOutput._(
          active: BuiltValueNullFieldError.checkNotNull(
            active,
            r'CustomerEmergencyStopDtoOutput',
            'active',
          ),
          startedAt: startedAt,
          browseMessage: browseMessage,
          delayNotice: delayNotice,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
