// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_custody_dto_output_hand_in_grace.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeskCustodyDtoOutputHandInGrace
    extends AdminDeskCustodyDtoOutputHandInGrace {
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

  factory _$AdminDeskCustodyDtoOutputHandInGrace([
    void Function(AdminDeskCustodyDtoOutputHandInGraceBuilder)? updates,
  ]) =>
      (AdminDeskCustodyDtoOutputHandInGraceBuilder()..update(updates))._build();

  _$AdminDeskCustodyDtoOutputHandInGrace._({
    required this.id,
    required this.until,
    required this.reason,
    required this.bulk,
    required this.grantedAt,
  }) : super._();
  @override
  AdminDeskCustodyDtoOutputHandInGrace rebuild(
    void Function(AdminDeskCustodyDtoOutputHandInGraceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCustodyDtoOutputHandInGraceBuilder toBuilder() =>
      AdminDeskCustodyDtoOutputHandInGraceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCustodyDtoOutputHandInGrace &&
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
    return (newBuiltValueToStringHelper(r'AdminDeskCustodyDtoOutputHandInGrace')
          ..add('id', id)
          ..add('until', until)
          ..add('reason', reason)
          ..add('bulk', bulk)
          ..add('grantedAt', grantedAt))
        .toString();
  }
}

class AdminDeskCustodyDtoOutputHandInGraceBuilder
    implements
        Builder<
          AdminDeskCustodyDtoOutputHandInGrace,
          AdminDeskCustodyDtoOutputHandInGraceBuilder
        > {
  _$AdminDeskCustodyDtoOutputHandInGrace? _$v;

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

  AdminDeskCustodyDtoOutputHandInGraceBuilder() {
    AdminDeskCustodyDtoOutputHandInGrace._defaults(this);
  }

  AdminDeskCustodyDtoOutputHandInGraceBuilder get _$this {
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
  void replace(AdminDeskCustodyDtoOutputHandInGrace other) {
    _$v = other as _$AdminDeskCustodyDtoOutputHandInGrace;
  }

  @override
  void update(
    void Function(AdminDeskCustodyDtoOutputHandInGraceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCustodyDtoOutputHandInGrace build() => _build();

  _$AdminDeskCustodyDtoOutputHandInGrace _build() {
    final _$result =
        _$v ??
        _$AdminDeskCustodyDtoOutputHandInGrace._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminDeskCustodyDtoOutputHandInGrace',
            'id',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminDeskCustodyDtoOutputHandInGrace',
            'until',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminDeskCustodyDtoOutputHandInGrace',
            'reason',
          ),
          bulk: BuiltValueNullFieldError.checkNotNull(
            bulk,
            r'AdminDeskCustodyDtoOutputHandInGrace',
            'bulk',
          ),
          grantedAt: BuiltValueNullFieldError.checkNotNull(
            grantedAt,
            r'AdminDeskCustodyDtoOutputHandInGrace',
            'grantedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
