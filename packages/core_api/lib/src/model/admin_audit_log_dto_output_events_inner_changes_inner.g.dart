// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_dto_output_events_inner_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditLogDtoOutputEventsInnerChangesInner
    extends AdminAuditLogDtoOutputEventsInnerChangesInner {
  @override
  final String field;
  @override
  final String? before;
  @override
  final String? after;

  factory _$AdminAuditLogDtoOutputEventsInnerChangesInner([
    void Function(AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder)?
    updates,
  ]) =>
      (AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder()..update(updates))
          ._build();

  _$AdminAuditLogDtoOutputEventsInnerChangesInner._({
    required this.field,
    this.before,
    this.after,
  }) : super._();
  @override
  AdminAuditLogDtoOutputEventsInnerChangesInner rebuild(
    void Function(AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder toBuilder() =>
      AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditLogDtoOutputEventsInnerChangesInner &&
        field == other.field &&
        before == other.before &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminAuditLogDtoOutputEventsInnerChangesInner',
          )
          ..add('field', field)
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder
    implements
        Builder<
          AdminAuditLogDtoOutputEventsInnerChangesInner,
          AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder
        > {
  _$AdminAuditLogDtoOutputEventsInnerChangesInner? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  String? _before;
  String? get before => _$this._before;
  set before(String? before) => _$this._before = before;

  String? _after;
  String? get after => _$this._after;
  set after(String? after) => _$this._after = after;

  AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder() {
    AdminAuditLogDtoOutputEventsInnerChangesInner._defaults(this);
  }

  AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _field = $v.field;
      _before = $v.before;
      _after = $v.after;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditLogDtoOutputEventsInnerChangesInner other) {
    _$v = other as _$AdminAuditLogDtoOutputEventsInnerChangesInner;
  }

  @override
  void update(
    void Function(AdminAuditLogDtoOutputEventsInnerChangesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditLogDtoOutputEventsInnerChangesInner build() => _build();

  _$AdminAuditLogDtoOutputEventsInnerChangesInner _build() {
    final _$result =
        _$v ??
        _$AdminAuditLogDtoOutputEventsInnerChangesInner._(
          field: BuiltValueNullFieldError.checkNotNull(
            field,
            r'AdminAuditLogDtoOutputEventsInnerChangesInner',
            'field',
          ),
          before: before,
          after: after,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
