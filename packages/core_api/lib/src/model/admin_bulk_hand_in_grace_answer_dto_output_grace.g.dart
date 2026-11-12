// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_bulk_hand_in_grace_answer_dto_output_grace.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBulkHandInGraceAnswerDtoOutputGrace
    extends AdminBulkHandInGraceAnswerDtoOutputGrace {
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

  factory _$AdminBulkHandInGraceAnswerDtoOutputGrace([
    void Function(AdminBulkHandInGraceAnswerDtoOutputGraceBuilder)? updates,
  ]) => (AdminBulkHandInGraceAnswerDtoOutputGraceBuilder()..update(updates))
      ._build();

  _$AdminBulkHandInGraceAnswerDtoOutputGrace._({
    required this.id,
    required this.until,
    required this.reason,
    required this.bulk,
    required this.grantedAt,
  }) : super._();
  @override
  AdminBulkHandInGraceAnswerDtoOutputGrace rebuild(
    void Function(AdminBulkHandInGraceAnswerDtoOutputGraceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBulkHandInGraceAnswerDtoOutputGraceBuilder toBuilder() =>
      AdminBulkHandInGraceAnswerDtoOutputGraceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBulkHandInGraceAnswerDtoOutputGrace &&
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
    return (newBuiltValueToStringHelper(
            r'AdminBulkHandInGraceAnswerDtoOutputGrace',
          )
          ..add('id', id)
          ..add('until', until)
          ..add('reason', reason)
          ..add('bulk', bulk)
          ..add('grantedAt', grantedAt))
        .toString();
  }
}

class AdminBulkHandInGraceAnswerDtoOutputGraceBuilder
    implements
        Builder<
          AdminBulkHandInGraceAnswerDtoOutputGrace,
          AdminBulkHandInGraceAnswerDtoOutputGraceBuilder
        > {
  _$AdminBulkHandInGraceAnswerDtoOutputGrace? _$v;

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

  AdminBulkHandInGraceAnswerDtoOutputGraceBuilder() {
    AdminBulkHandInGraceAnswerDtoOutputGrace._defaults(this);
  }

  AdminBulkHandInGraceAnswerDtoOutputGraceBuilder get _$this {
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
  void replace(AdminBulkHandInGraceAnswerDtoOutputGrace other) {
    _$v = other as _$AdminBulkHandInGraceAnswerDtoOutputGrace;
  }

  @override
  void update(
    void Function(AdminBulkHandInGraceAnswerDtoOutputGraceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBulkHandInGraceAnswerDtoOutputGrace build() => _build();

  _$AdminBulkHandInGraceAnswerDtoOutputGrace _build() {
    final _$result =
        _$v ??
        _$AdminBulkHandInGraceAnswerDtoOutputGrace._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminBulkHandInGraceAnswerDtoOutputGrace',
            'id',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminBulkHandInGraceAnswerDtoOutputGrace',
            'until',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminBulkHandInGraceAnswerDtoOutputGrace',
            'reason',
          ),
          bulk: BuiltValueNullFieldError.checkNotNull(
            bulk,
            r'AdminBulkHandInGraceAnswerDtoOutputGrace',
            'bulk',
          ),
          grantedAt: BuiltValueNullFieldError.checkNotNull(
            grantedAt,
            r'AdminBulkHandInGraceAnswerDtoOutputGrace',
            'grantedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
