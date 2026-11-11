// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_cannot_complete.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCannotComplete
    extends AdminOrderDtoOutputOrderCannotComplete {
  @override
  final String captainId;
  @override
  final String reason;
  @override
  final String label;
  @override
  final String? note;
  @override
  final DateTime at;

  factory _$AdminOrderDtoOutputOrderCannotComplete([
    void Function(AdminOrderDtoOutputOrderCannotCompleteBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCannotCompleteBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCannotComplete._({
    required this.captainId,
    required this.reason,
    required this.label,
    this.note,
    required this.at,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCannotComplete rebuild(
    void Function(AdminOrderDtoOutputOrderCannotCompleteBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCannotCompleteBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCannotCompleteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCannotComplete &&
        captainId == other.captainId &&
        reason == other.reason &&
        label == other.label &&
        note == other.note &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderCannotComplete',
          )
          ..add('captainId', captainId)
          ..add('reason', reason)
          ..add('label', label)
          ..add('note', note)
          ..add('at', at))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCannotCompleteBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCannotComplete,
          AdminOrderDtoOutputOrderCannotCompleteBuilder
        > {
  _$AdminOrderDtoOutputOrderCannotComplete? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminOrderDtoOutputOrderCannotCompleteBuilder() {
    AdminOrderDtoOutputOrderCannotComplete._defaults(this);
  }

  AdminOrderDtoOutputOrderCannotCompleteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _reason = $v.reason;
      _label = $v.label;
      _note = $v.note;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCannotComplete other) {
    _$v = other as _$AdminOrderDtoOutputOrderCannotComplete;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCannotCompleteBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCannotComplete build() => _build();

  _$AdminOrderDtoOutputOrderCannotComplete _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderCannotComplete._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminOrderDtoOutputOrderCannotComplete',
            'captainId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderDtoOutputOrderCannotComplete',
            'reason',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderCannotComplete',
            'label',
          ),
          note: note,
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderCannotComplete',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
