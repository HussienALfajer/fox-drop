// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_appeal_ticket_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAppealTicketDtoOutput extends CaptainAppealTicketDtoOutput {
  @override
  final CaptainReportTicketDtoOutputTicket ticket;

  factory _$CaptainAppealTicketDtoOutput([
    void Function(CaptainAppealTicketDtoOutputBuilder)? updates,
  ]) => (CaptainAppealTicketDtoOutputBuilder()..update(updates))._build();

  _$CaptainAppealTicketDtoOutput._({required this.ticket}) : super._();
  @override
  CaptainAppealTicketDtoOutput rebuild(
    void Function(CaptainAppealTicketDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAppealTicketDtoOutputBuilder toBuilder() =>
      CaptainAppealTicketDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAppealTicketDtoOutput && ticket == other.ticket;
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
      r'CaptainAppealTicketDtoOutput',
    )..add('ticket', ticket)).toString();
  }
}

class CaptainAppealTicketDtoOutputBuilder
    implements
        Builder<
          CaptainAppealTicketDtoOutput,
          CaptainAppealTicketDtoOutputBuilder
        > {
  _$CaptainAppealTicketDtoOutput? _$v;

  CaptainReportTicketDtoOutputTicketBuilder? _ticket;
  CaptainReportTicketDtoOutputTicketBuilder get ticket =>
      _$this._ticket ??= CaptainReportTicketDtoOutputTicketBuilder();
  set ticket(CaptainReportTicketDtoOutputTicketBuilder? ticket) =>
      _$this._ticket = ticket;

  CaptainAppealTicketDtoOutputBuilder() {
    CaptainAppealTicketDtoOutput._defaults(this);
  }

  CaptainAppealTicketDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticket = $v.ticket.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAppealTicketDtoOutput other) {
    _$v = other as _$CaptainAppealTicketDtoOutput;
  }

  @override
  void update(void Function(CaptainAppealTicketDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAppealTicketDtoOutput build() => _build();

  _$CaptainAppealTicketDtoOutput _build() {
    _$CaptainAppealTicketDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainAppealTicketDtoOutput._(ticket: ticket.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticket';
        ticket.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainAppealTicketDtoOutput',
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
