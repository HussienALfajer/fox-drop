// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_tickets_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderTicketsDtoOutput extends AdminOrderTicketsDtoOutput {
  @override
  final BuiltList<AdminOrderTicketsDtoOutputTicketsInner> tickets;

  factory _$AdminOrderTicketsDtoOutput([
    void Function(AdminOrderTicketsDtoOutputBuilder)? updates,
  ]) => (AdminOrderTicketsDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderTicketsDtoOutput._({required this.tickets}) : super._();
  @override
  AdminOrderTicketsDtoOutput rebuild(
    void Function(AdminOrderTicketsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketsDtoOutputBuilder toBuilder() =>
      AdminOrderTicketsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderTicketsDtoOutput && tickets == other.tickets;
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
      r'AdminOrderTicketsDtoOutput',
    )..add('tickets', tickets)).toString();
  }
}

class AdminOrderTicketsDtoOutputBuilder
    implements
        Builder<AdminOrderTicketsDtoOutput, AdminOrderTicketsDtoOutputBuilder> {
  _$AdminOrderTicketsDtoOutput? _$v;

  ListBuilder<AdminOrderTicketsDtoOutputTicketsInner>? _tickets;
  ListBuilder<AdminOrderTicketsDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??= ListBuilder<AdminOrderTicketsDtoOutputTicketsInner>();
  set tickets(ListBuilder<AdminOrderTicketsDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  AdminOrderTicketsDtoOutputBuilder() {
    AdminOrderTicketsDtoOutput._defaults(this);
  }

  AdminOrderTicketsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tickets = $v.tickets.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderTicketsDtoOutput other) {
    _$v = other as _$AdminOrderTicketsDtoOutput;
  }

  @override
  void update(void Function(AdminOrderTicketsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketsDtoOutput build() => _build();

  _$AdminOrderTicketsDtoOutput _build() {
    _$AdminOrderTicketsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminOrderTicketsDtoOutput._(tickets: tickets.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tickets';
        tickets.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderTicketsDtoOutput',
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
