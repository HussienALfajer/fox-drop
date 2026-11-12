// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_grace_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInGraceAnswerDtoOutput
    extends AdminHandInGraceAnswerDtoOutput {
  @override
  final String id;
  @override
  final DateTime until;
  @override
  final String reason;
  @override
  final bool bulk;
  @override
  final DateTime grantedAt;

  factory _$AdminHandInGraceAnswerDtoOutput([
    void Function(AdminHandInGraceAnswerDtoOutputBuilder)? updates,
  ]) => (AdminHandInGraceAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminHandInGraceAnswerDtoOutput._({
    required this.id,
    required this.until,
    required this.reason,
    required this.bulk,
    required this.grantedAt,
  }) : super._();
  @override
  AdminHandInGraceAnswerDtoOutput rebuild(
    void Function(AdminHandInGraceAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInGraceAnswerDtoOutputBuilder toBuilder() =>
      AdminHandInGraceAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInGraceAnswerDtoOutput &&
        id == other.id &&
        until == other.until &&
        reason == other.reason &&
        bulk == other.bulk &&
        grantedAt == other.grantedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, bulk.hashCode);
    _$hash = $jc(_$hash, grantedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHandInGraceAnswerDtoOutput')
          ..add('id', id)
          ..add('until', until)
          ..add('reason', reason)
          ..add('bulk', bulk)
          ..add('grantedAt', grantedAt))
        .toString();
  }
}

class AdminHandInGraceAnswerDtoOutputBuilder
    implements
        Builder<
          AdminHandInGraceAnswerDtoOutput,
          AdminHandInGraceAnswerDtoOutputBuilder
        > {
  _$AdminHandInGraceAnswerDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _bulk;
  bool? get bulk => _$this._bulk;
  set bulk(bool? bulk) => _$this._bulk = bulk;

  DateTime? _grantedAt;
  DateTime? get grantedAt => _$this._grantedAt;
  set grantedAt(DateTime? grantedAt) => _$this._grantedAt = grantedAt;

  AdminHandInGraceAnswerDtoOutputBuilder() {
    AdminHandInGraceAnswerDtoOutput._defaults(this);
  }

  AdminHandInGraceAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _until = $v.until;
      _reason = $v.reason;
      _bulk = $v.bulk;
      _grantedAt = $v.grantedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandInGraceAnswerDtoOutput other) {
    _$v = other as _$AdminHandInGraceAnswerDtoOutput;
  }

  @override
  void update(void Function(AdminHandInGraceAnswerDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInGraceAnswerDtoOutput build() => _build();

  _$AdminHandInGraceAnswerDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminHandInGraceAnswerDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminHandInGraceAnswerDtoOutput',
            'id',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminHandInGraceAnswerDtoOutput',
            'until',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminHandInGraceAnswerDtoOutput',
            'reason',
          ),
          bulk: BuiltValueNullFieldError.checkNotNull(
            bulk,
            r'AdminHandInGraceAnswerDtoOutput',
            'bulk',
          ),
          grantedAt: BuiltValueNullFieldError.checkNotNull(
            grantedAt,
            r'AdminHandInGraceAnswerDtoOutput',
            'grantedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
