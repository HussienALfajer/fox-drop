// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_arrive_at_customer_dto_away.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainArriveAtCustomerDtoAway extends CaptainArriveAtCustomerDtoAway {
  @override
  final String reason;
  @override
  final String? note;

  factory _$CaptainArriveAtCustomerDtoAway([
    void Function(CaptainArriveAtCustomerDtoAwayBuilder)? updates,
  ]) => (CaptainArriveAtCustomerDtoAwayBuilder()..update(updates))._build();

  _$CaptainArriveAtCustomerDtoAway._({required this.reason, this.note})
    : super._();
  @override
  CaptainArriveAtCustomerDtoAway rebuild(
    void Function(CaptainArriveAtCustomerDtoAwayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainArriveAtCustomerDtoAwayBuilder toBuilder() =>
      CaptainArriveAtCustomerDtoAwayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainArriveAtCustomerDtoAway &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainArriveAtCustomerDtoAway')
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class CaptainArriveAtCustomerDtoAwayBuilder
    implements
        Builder<
          CaptainArriveAtCustomerDtoAway,
          CaptainArriveAtCustomerDtoAwayBuilder
        > {
  _$CaptainArriveAtCustomerDtoAway? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CaptainArriveAtCustomerDtoAwayBuilder() {
    CaptainArriveAtCustomerDtoAway._defaults(this);
  }

  CaptainArriveAtCustomerDtoAwayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainArriveAtCustomerDtoAway other) {
    _$v = other as _$CaptainArriveAtCustomerDtoAway;
  }

  @override
  void update(void Function(CaptainArriveAtCustomerDtoAwayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainArriveAtCustomerDtoAway build() => _build();

  _$CaptainArriveAtCustomerDtoAway _build() {
    final _$result =
        _$v ??
        _$CaptainArriveAtCustomerDtoAway._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainArriveAtCustomerDtoAway',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
