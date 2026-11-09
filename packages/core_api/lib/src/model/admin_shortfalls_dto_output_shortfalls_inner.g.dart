// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shortfalls_dto_output_shortfalls_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminShortfallsDtoOutputShortfallsInner
    extends AdminShortfallsDtoOutputShortfallsInner {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final String captainId;
  @override
  final CaptainWentOfflineDtoOutputHandIn? amountDue;
  @override
  final CaptainWentOfflineDtoOutputHandIn? netReceived;
  @override
  final CaptainWentOfflineDtoOutputHandIn? shortfall;
  @override
  final String reason;
  @override
  final String label;
  @override
  final String? note;
  @override
  final DateTime recordedAt;

  factory _$AdminShortfallsDtoOutputShortfallsInner([
    void Function(AdminShortfallsDtoOutputShortfallsInnerBuilder)? updates,
  ]) => (AdminShortfallsDtoOutputShortfallsInnerBuilder()..update(updates))
      ._build();

  _$AdminShortfallsDtoOutputShortfallsInner._({
    required this.orderId,
    required this.number,
    required this.captainId,
    this.amountDue,
    this.netReceived,
    this.shortfall,
    required this.reason,
    required this.label,
    this.note,
    required this.recordedAt,
  }) : super._();
  @override
  AdminShortfallsDtoOutputShortfallsInner rebuild(
    void Function(AdminShortfallsDtoOutputShortfallsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminShortfallsDtoOutputShortfallsInnerBuilder toBuilder() =>
      AdminShortfallsDtoOutputShortfallsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminShortfallsDtoOutputShortfallsInner &&
        orderId == other.orderId &&
        number == other.number &&
        captainId == other.captainId &&
        amountDue == other.amountDue &&
        netReceived == other.netReceived &&
        shortfall == other.shortfall &&
        reason == other.reason &&
        label == other.label &&
        note == other.note &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, amountDue.hashCode);
    _$hash = $jc(_$hash, netReceived.hashCode);
    _$hash = $jc(_$hash, shortfall.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminShortfallsDtoOutputShortfallsInner',
          )
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('captainId', captainId)
          ..add('amountDue', amountDue)
          ..add('netReceived', netReceived)
          ..add('shortfall', shortfall)
          ..add('reason', reason)
          ..add('label', label)
          ..add('note', note)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class AdminShortfallsDtoOutputShortfallsInnerBuilder
    implements
        Builder<
          AdminShortfallsDtoOutputShortfallsInner,
          AdminShortfallsDtoOutputShortfallsInnerBuilder
        > {
  _$AdminShortfallsDtoOutputShortfallsInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  CaptainWentOfflineDtoOutputHandInBuilder? _amountDue;
  CaptainWentOfflineDtoOutputHandInBuilder get amountDue =>
      _$this._amountDue ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set amountDue(CaptainWentOfflineDtoOutputHandInBuilder? amountDue) =>
      _$this._amountDue = amountDue;

  CaptainWentOfflineDtoOutputHandInBuilder? _netReceived;
  CaptainWentOfflineDtoOutputHandInBuilder get netReceived =>
      _$this._netReceived ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set netReceived(CaptainWentOfflineDtoOutputHandInBuilder? netReceived) =>
      _$this._netReceived = netReceived;

  CaptainWentOfflineDtoOutputHandInBuilder? _shortfall;
  CaptainWentOfflineDtoOutputHandInBuilder get shortfall =>
      _$this._shortfall ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set shortfall(CaptainWentOfflineDtoOutputHandInBuilder? shortfall) =>
      _$this._shortfall = shortfall;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  AdminShortfallsDtoOutputShortfallsInnerBuilder() {
    AdminShortfallsDtoOutputShortfallsInner._defaults(this);
  }

  AdminShortfallsDtoOutputShortfallsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _captainId = $v.captainId;
      _amountDue = $v.amountDue?.toBuilder();
      _netReceived = $v.netReceived?.toBuilder();
      _shortfall = $v.shortfall?.toBuilder();
      _reason = $v.reason;
      _label = $v.label;
      _note = $v.note;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminShortfallsDtoOutputShortfallsInner other) {
    _$v = other as _$AdminShortfallsDtoOutputShortfallsInner;
  }

  @override
  void update(
    void Function(AdminShortfallsDtoOutputShortfallsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminShortfallsDtoOutputShortfallsInner build() => _build();

  _$AdminShortfallsDtoOutputShortfallsInner _build() {
    _$AdminShortfallsDtoOutputShortfallsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminShortfallsDtoOutputShortfallsInner._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'AdminShortfallsDtoOutputShortfallsInner',
              'orderId',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminShortfallsDtoOutputShortfallsInner',
              'number',
            ),
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminShortfallsDtoOutputShortfallsInner',
              'captainId',
            ),
            amountDue: _amountDue?.build(),
            netReceived: _netReceived?.build(),
            shortfall: _shortfall?.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminShortfallsDtoOutputShortfallsInner',
              'reason',
            ),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'AdminShortfallsDtoOutputShortfallsInner',
              'label',
            ),
            note: note,
            recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt,
              r'AdminShortfallsDtoOutputShortfallsInner',
              'recordedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amountDue';
        _amountDue?.build();
        _$failedField = 'netReceived';
        _netReceived?.build();
        _$failedField = 'shortfall';
        _shortfall?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminShortfallsDtoOutputShortfallsInner',
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
