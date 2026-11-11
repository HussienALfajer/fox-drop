// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_cannot_complete.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderCannotComplete
    extends CaptainActiveOrderDtoOutputOrderCannotComplete {
  @override
  final String reason;
  @override
  final String? note;
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputOrderCannotComplete([
    void Function(CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder()..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderCannotComplete._({
    required this.reason,
    this.note,
    required this.at,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCannotComplete rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCannotComplete &&
        reason == other.reason &&
        note == other.note &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderCannotComplete',
          )
          ..add('reason', reason)
          ..add('note', note)
          ..add('at', at))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCannotComplete,
          CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCannotComplete? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder() {
    CaptainActiveOrderDtoOutputOrderCannotComplete._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCannotComplete other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCannotComplete;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCannotCompleteBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCannotComplete build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCannotComplete _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderCannotComplete._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainActiveOrderDtoOutputOrderCannotComplete',
            'reason',
          ),
          note: note,
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderCannotComplete',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
