// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_tickets_dto_output_tickets_inner_closure.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderTicketsDtoOutputTicketsInnerClosure
    extends AdminOrderTicketsDtoOutputTicketsInnerClosure {
  @override
  final String reason;
  @override
  final DateTime closedAt;
  @override
  final String? closedByName;

  factory _$AdminOrderTicketsDtoOutputTicketsInnerClosure([
    void Function(AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder)?
    updates,
  ]) =>
      (AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder()..update(updates))
          ._build();

  _$AdminOrderTicketsDtoOutputTicketsInnerClosure._({
    required this.reason,
    required this.closedAt,
    this.closedByName,
  }) : super._();
  @override
  AdminOrderTicketsDtoOutputTicketsInnerClosure rebuild(
    void Function(AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder toBuilder() =>
      AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderTicketsDtoOutputTicketsInnerClosure &&
        reason == other.reason &&
        closedAt == other.closedAt &&
        closedByName == other.closedByName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closedByName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderTicketsDtoOutputTicketsInnerClosure',
          )
          ..add('reason', reason)
          ..add('closedAt', closedAt)
          ..add('closedByName', closedByName))
        .toString();
  }
}

class AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder
    implements
        Builder<
          AdminOrderTicketsDtoOutputTicketsInnerClosure,
          AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder
        > {
  _$AdminOrderTicketsDtoOutputTicketsInnerClosure? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _closedByName;
  String? get closedByName => _$this._closedByName;
  set closedByName(String? closedByName) => _$this._closedByName = closedByName;

  AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder() {
    AdminOrderTicketsDtoOutputTicketsInnerClosure._defaults(this);
  }

  AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _closedAt = $v.closedAt;
      _closedByName = $v.closedByName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderTicketsDtoOutputTicketsInnerClosure other) {
    _$v = other as _$AdminOrderTicketsDtoOutputTicketsInnerClosure;
  }

  @override
  void update(
    void Function(AdminOrderTicketsDtoOutputTicketsInnerClosureBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerClosure build() => _build();

  _$AdminOrderTicketsDtoOutputTicketsInnerClosure _build() {
    final _$result =
        _$v ??
        _$AdminOrderTicketsDtoOutputTicketsInnerClosure._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderTicketsDtoOutputTicketsInnerClosure',
            'reason',
          ),
          closedAt: BuiltValueNullFieldError.checkNotNull(
            closedAt,
            r'AdminOrderTicketsDtoOutputTicketsInnerClosure',
            'closedAt',
          ),
          closedByName: closedByName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
