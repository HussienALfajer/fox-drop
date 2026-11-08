// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_emergency_stop_state_dto_output_defaults.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEmergencyStopStateDtoOutputDefaults
    extends AdminEmergencyStopStateDtoOutputDefaults {
  @override
  final String browseMessage;
  @override
  final String delayNotice;

  factory _$AdminEmergencyStopStateDtoOutputDefaults([
    void Function(AdminEmergencyStopStateDtoOutputDefaultsBuilder)? updates,
  ]) => (AdminEmergencyStopStateDtoOutputDefaultsBuilder()..update(updates))
      ._build();

  _$AdminEmergencyStopStateDtoOutputDefaults._({
    required this.browseMessage,
    required this.delayNotice,
  }) : super._();
  @override
  AdminEmergencyStopStateDtoOutputDefaults rebuild(
    void Function(AdminEmergencyStopStateDtoOutputDefaultsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEmergencyStopStateDtoOutputDefaultsBuilder toBuilder() =>
      AdminEmergencyStopStateDtoOutputDefaultsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmergencyStopStateDtoOutputDefaults &&
        browseMessage == other.browseMessage &&
        delayNotice == other.delayNotice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, browseMessage.hashCode);
    _$hash = $jc(_$hash, delayNotice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminEmergencyStopStateDtoOutputDefaults',
          )
          ..add('browseMessage', browseMessage)
          ..add('delayNotice', delayNotice))
        .toString();
  }
}

class AdminEmergencyStopStateDtoOutputDefaultsBuilder
    implements
        Builder<
          AdminEmergencyStopStateDtoOutputDefaults,
          AdminEmergencyStopStateDtoOutputDefaultsBuilder
        > {
  _$AdminEmergencyStopStateDtoOutputDefaults? _$v;

  String? _browseMessage;
  String? get browseMessage => _$this._browseMessage;
  set browseMessage(String? browseMessage) =>
      _$this._browseMessage = browseMessage;

  String? _delayNotice;
  String? get delayNotice => _$this._delayNotice;
  set delayNotice(String? delayNotice) => _$this._delayNotice = delayNotice;

  AdminEmergencyStopStateDtoOutputDefaultsBuilder() {
    AdminEmergencyStopStateDtoOutputDefaults._defaults(this);
  }

  AdminEmergencyStopStateDtoOutputDefaultsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _browseMessage = $v.browseMessage;
      _delayNotice = $v.delayNotice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmergencyStopStateDtoOutputDefaults other) {
    _$v = other as _$AdminEmergencyStopStateDtoOutputDefaults;
  }

  @override
  void update(
    void Function(AdminEmergencyStopStateDtoOutputDefaultsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmergencyStopStateDtoOutputDefaults build() => _build();

  _$AdminEmergencyStopStateDtoOutputDefaults _build() {
    final _$result =
        _$v ??
        _$AdminEmergencyStopStateDtoOutputDefaults._(
          browseMessage: BuiltValueNullFieldError.checkNotNull(
            browseMessage,
            r'AdminEmergencyStopStateDtoOutputDefaults',
            'browseMessage',
          ),
          delayNotice: BuiltValueNullFieldError.checkNotNull(
            delayNotice,
            r'AdminEmergencyStopStateDtoOutputDefaults',
            'delayNotice',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
