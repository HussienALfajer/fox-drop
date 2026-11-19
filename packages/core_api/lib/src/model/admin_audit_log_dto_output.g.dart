// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditLogDtoOutput extends AdminAuditLogDtoOutput {
  @override
  final BuiltList<AdminAuditLogDtoOutputEventsInner> events;
  @override
  final String? nextCursor;

  factory _$AdminAuditLogDtoOutput([
    void Function(AdminAuditLogDtoOutputBuilder)? updates,
  ]) => (AdminAuditLogDtoOutputBuilder()..update(updates))._build();

  _$AdminAuditLogDtoOutput._({required this.events, this.nextCursor})
    : super._();
  @override
  AdminAuditLogDtoOutput rebuild(
    void Function(AdminAuditLogDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAuditLogDtoOutputBuilder toBuilder() =>
      AdminAuditLogDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditLogDtoOutput &&
        events == other.events &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAuditLogDtoOutput')
          ..add('events', events)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminAuditLogDtoOutputBuilder
    implements Builder<AdminAuditLogDtoOutput, AdminAuditLogDtoOutputBuilder> {
  _$AdminAuditLogDtoOutput? _$v;

  ListBuilder<AdminAuditLogDtoOutputEventsInner>? _events;
  ListBuilder<AdminAuditLogDtoOutputEventsInner> get events =>
      _$this._events ??= ListBuilder<AdminAuditLogDtoOutputEventsInner>();
  set events(ListBuilder<AdminAuditLogDtoOutputEventsInner>? events) =>
      _$this._events = events;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminAuditLogDtoOutputBuilder() {
    AdminAuditLogDtoOutput._defaults(this);
  }

  AdminAuditLogDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _events = $v.events.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditLogDtoOutput other) {
    _$v = other as _$AdminAuditLogDtoOutput;
  }

  @override
  void update(void Function(AdminAuditLogDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditLogDtoOutput build() => _build();

  _$AdminAuditLogDtoOutput _build() {
    _$AdminAuditLogDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminAuditLogDtoOutput._(
            events: events.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminAuditLogDtoOutput',
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
