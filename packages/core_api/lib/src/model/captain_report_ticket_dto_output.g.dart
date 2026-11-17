// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_report_ticket_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainReportTicketDtoOutput extends CaptainReportTicketDtoOutput {
  @override
  final CaptainReportTicketDtoOutputTicket ticket;

  factory _$CaptainReportTicketDtoOutput([
    void Function(CaptainReportTicketDtoOutputBuilder)? updates,
  ]) => (CaptainReportTicketDtoOutputBuilder()..update(updates))._build();

  _$CaptainReportTicketDtoOutput._({required this.ticket}) : super._();
  @override
  CaptainReportTicketDtoOutput rebuild(
    void Function(CaptainReportTicketDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainReportTicketDtoOutputBuilder toBuilder() =>
      CaptainReportTicketDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainReportTicketDtoOutput && ticket == other.ticket;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticket.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainReportTicketDtoOutput',
    )..add('ticket', ticket)).toString();
  }
}

class CaptainReportTicketDtoOutputBuilder
    implements
        Builder<
          CaptainReportTicketDtoOutput,
          CaptainReportTicketDtoOutputBuilder
        > {
  _$CaptainReportTicketDtoOutput? _$v;

  CaptainReportTicketDtoOutputTicketBuilder? _ticket;
  CaptainReportTicketDtoOutputTicketBuilder get ticket =>
      _$this._ticket ??= CaptainReportTicketDtoOutputTicketBuilder();
  set ticket(CaptainReportTicketDtoOutputTicketBuilder? ticket) =>
      _$this._ticket = ticket;

  CaptainReportTicketDtoOutputBuilder() {
    CaptainReportTicketDtoOutput._defaults(this);
  }

  CaptainReportTicketDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticket = $v.ticket.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainReportTicketDtoOutput other) {
    _$v = other as _$CaptainReportTicketDtoOutput;
  }

  @override
  void update(void Function(CaptainReportTicketDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainReportTicketDtoOutput build() => _build();

  _$CaptainReportTicketDtoOutput _build() {
    _$CaptainReportTicketDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainReportTicketDtoOutput._(ticket: ticket.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticket';
        ticket.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainReportTicketDtoOutput',
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
