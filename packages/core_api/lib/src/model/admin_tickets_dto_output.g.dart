// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_tickets_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketsDtoOutput extends AdminTicketsDtoOutput {
  @override
  final BuiltList<AdminOrderTicketsDtoOutputTicketsInner> tickets;

  factory _$AdminTicketsDtoOutput([
    void Function(AdminTicketsDtoOutputBuilder)? updates,
  ]) => (AdminTicketsDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketsDtoOutput._({required this.tickets}) : super._();
  @override
  AdminTicketsDtoOutput rebuild(
    void Function(AdminTicketsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketsDtoOutputBuilder toBuilder() =>
      AdminTicketsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketsDtoOutput && tickets == other.tickets;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminTicketsDtoOutput',
    )..add('tickets', tickets)).toString();
  }
}

class AdminTicketsDtoOutputBuilder
    implements Builder<AdminTicketsDtoOutput, AdminTicketsDtoOutputBuilder> {
  _$AdminTicketsDtoOutput? _$v;

  ListBuilder<AdminOrderTicketsDtoOutputTicketsInner>? _tickets;
  ListBuilder<AdminOrderTicketsDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??= ListBuilder<AdminOrderTicketsDtoOutputTicketsInner>();
  set tickets(ListBuilder<AdminOrderTicketsDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  AdminTicketsDtoOutputBuilder() {
    AdminTicketsDtoOutput._defaults(this);
  }

  AdminTicketsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tickets = $v.tickets.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketsDtoOutput other) {
    _$v = other as _$AdminTicketsDtoOutput;
  }

  @override
  void update(void Function(AdminTicketsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketsDtoOutput build() => _build();

  _$AdminTicketsDtoOutput _build() {
    _$AdminTicketsDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminTicketsDtoOutput._(tickets: tickets.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tickets';
        tickets.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketsDtoOutput',
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
