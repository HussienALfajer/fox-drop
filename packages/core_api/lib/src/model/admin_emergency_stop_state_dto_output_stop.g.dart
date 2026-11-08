// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_emergency_stop_state_dto_output_stop.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEmergencyStopStateDtoOutputStop
    extends AdminEmergencyStopStateDtoOutputStop {
  @override
  final String id;
  @override
  final DateTime startedAt;
  @override
  final String startedBy;
  @override
  final String internalReason;
  @override
  final String browseMessage;
  @override
  final String delayNotice;
  @override
  final String customerReason;
  @override
  final DateTime? resumeAt;
  @override
  final int attempts;

  factory _$AdminEmergencyStopStateDtoOutputStop([
    void Function(AdminEmergencyStopStateDtoOutputStopBuilder)? updates,
  ]) =>
      (AdminEmergencyStopStateDtoOutputStopBuilder()..update(updates))._build();

  _$AdminEmergencyStopStateDtoOutputStop._({
    required this.id,
    required this.startedAt,
    required this.startedBy,
    required this.internalReason,
    required this.browseMessage,
    required this.delayNotice,
    required this.customerReason,
    this.resumeAt,
    required this.attempts,
  }) : super._();
  @override
  AdminEmergencyStopStateDtoOutputStop rebuild(
    void Function(AdminEmergencyStopStateDtoOutputStopBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEmergencyStopStateDtoOutputStopBuilder toBuilder() =>
      AdminEmergencyStopStateDtoOutputStopBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmergencyStopStateDtoOutputStop &&
        id == other.id &&
        startedAt == other.startedAt &&
        startedBy == other.startedBy &&
        internalReason == other.internalReason &&
        browseMessage == other.browseMessage &&
        delayNotice == other.delayNotice &&
        customerReason == other.customerReason &&
        resumeAt == other.resumeAt &&
        attempts == other.attempts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, startedBy.hashCode);
    _$hash = $jc(_$hash, internalReason.hashCode);
    _$hash = $jc(_$hash, browseMessage.hashCode);
    _$hash = $jc(_$hash, delayNotice.hashCode);
    _$hash = $jc(_$hash, customerReason.hashCode);
    _$hash = $jc(_$hash, resumeAt.hashCode);
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEmergencyStopStateDtoOutputStop')
          ..add('id', id)
          ..add('startedAt', startedAt)
          ..add('startedBy', startedBy)
          ..add('internalReason', internalReason)
          ..add('browseMessage', browseMessage)
          ..add('delayNotice', delayNotice)
          ..add('customerReason', customerReason)
          ..add('resumeAt', resumeAt)
          ..add('attempts', attempts))
        .toString();
  }
}

class AdminEmergencyStopStateDtoOutputStopBuilder
    implements
        Builder<
          AdminEmergencyStopStateDtoOutputStop,
          AdminEmergencyStopStateDtoOutputStopBuilder
        > {
  _$AdminEmergencyStopStateDtoOutputStop? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  String? _startedBy;
  String? get startedBy => _$this._startedBy;
  set startedBy(String? startedBy) => _$this._startedBy = startedBy;

  String? _internalReason;
  String? get internalReason => _$this._internalReason;
  set internalReason(String? internalReason) =>
      _$this._internalReason = internalReason;

  String? _browseMessage;
  String? get browseMessage => _$this._browseMessage;
  set browseMessage(String? browseMessage) =>
      _$this._browseMessage = browseMessage;

  String? _delayNotice;
  String? get delayNotice => _$this._delayNotice;
  set delayNotice(String? delayNotice) => _$this._delayNotice = delayNotice;

  String? _customerReason;
  String? get customerReason => _$this._customerReason;
  set customerReason(String? customerReason) =>
      _$this._customerReason = customerReason;

  DateTime? _resumeAt;
  DateTime? get resumeAt => _$this._resumeAt;
  set resumeAt(DateTime? resumeAt) => _$this._resumeAt = resumeAt;

  int? _attempts;
  int? get attempts => _$this._attempts;
  set attempts(int? attempts) => _$this._attempts = attempts;

  AdminEmergencyStopStateDtoOutputStopBuilder() {
    AdminEmergencyStopStateDtoOutputStop._defaults(this);
  }

  AdminEmergencyStopStateDtoOutputStopBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _startedAt = $v.startedAt;
      _startedBy = $v.startedBy;
      _internalReason = $v.internalReason;
      _browseMessage = $v.browseMessage;
      _delayNotice = $v.delayNotice;
      _customerReason = $v.customerReason;
      _resumeAt = $v.resumeAt;
      _attempts = $v.attempts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmergencyStopStateDtoOutputStop other) {
    _$v = other as _$AdminEmergencyStopStateDtoOutputStop;
  }

  @override
  void update(
    void Function(AdminEmergencyStopStateDtoOutputStopBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmergencyStopStateDtoOutputStop build() => _build();

  _$AdminEmergencyStopStateDtoOutputStop _build() {
    final _$result =
        _$v ??
        _$AdminEmergencyStopStateDtoOutputStop._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminEmergencyStopStateDtoOutputStop',
            'id',
          ),
          startedAt: BuiltValueNullFieldError.checkNotNull(
            startedAt,
            r'AdminEmergencyStopStateDtoOutputStop',
            'startedAt',
          ),
          startedBy: BuiltValueNullFieldError.checkNotNull(
            startedBy,
            r'AdminEmergencyStopStateDtoOutputStop',
            'startedBy',
          ),
          internalReason: BuiltValueNullFieldError.checkNotNull(
            internalReason,
            r'AdminEmergencyStopStateDtoOutputStop',
            'internalReason',
          ),
          browseMessage: BuiltValueNullFieldError.checkNotNull(
            browseMessage,
            r'AdminEmergencyStopStateDtoOutputStop',
            'browseMessage',
          ),
          delayNotice: BuiltValueNullFieldError.checkNotNull(
            delayNotice,
            r'AdminEmergencyStopStateDtoOutputStop',
            'delayNotice',
          ),
          customerReason: BuiltValueNullFieldError.checkNotNull(
            customerReason,
            r'AdminEmergencyStopStateDtoOutputStop',
            'customerReason',
          ),
          resumeAt: resumeAt,
          attempts: BuiltValueNullFieldError.checkNotNull(
            attempts,
            r'AdminEmergencyStopStateDtoOutputStop',
            'attempts',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
