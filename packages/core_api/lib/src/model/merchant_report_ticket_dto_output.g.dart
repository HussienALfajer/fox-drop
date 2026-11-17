// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_report_ticket_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantReportTicketDtoOutput extends MerchantReportTicketDtoOutput {
  @override
  final MerchantReportTicketDtoOutputTicket ticket;

  factory _$MerchantReportTicketDtoOutput([
    void Function(MerchantReportTicketDtoOutputBuilder)? updates,
  ]) => (MerchantReportTicketDtoOutputBuilder()..update(updates))._build();

  _$MerchantReportTicketDtoOutput._({required this.ticket}) : super._();
  @override
  MerchantReportTicketDtoOutput rebuild(
    void Function(MerchantReportTicketDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReportTicketDtoOutputBuilder toBuilder() =>
      MerchantReportTicketDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReportTicketDtoOutput && ticket == other.ticket;
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
      r'MerchantReportTicketDtoOutput',
    )..add('ticket', ticket)).toString();
  }
}

class MerchantReportTicketDtoOutputBuilder
    implements
        Builder<
          MerchantReportTicketDtoOutput,
          MerchantReportTicketDtoOutputBuilder
        > {
  _$MerchantReportTicketDtoOutput? _$v;

  MerchantReportTicketDtoOutputTicketBuilder? _ticket;
  MerchantReportTicketDtoOutputTicketBuilder get ticket =>
      _$this._ticket ??= MerchantReportTicketDtoOutputTicketBuilder();
  set ticket(MerchantReportTicketDtoOutputTicketBuilder? ticket) =>
      _$this._ticket = ticket;

  MerchantReportTicketDtoOutputBuilder() {
    MerchantReportTicketDtoOutput._defaults(this);
  }

  MerchantReportTicketDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticket = $v.ticket.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReportTicketDtoOutput other) {
    _$v = other as _$MerchantReportTicketDtoOutput;
  }

  @override
  void update(void Function(MerchantReportTicketDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReportTicketDtoOutput build() => _build();

  _$MerchantReportTicketDtoOutput _build() {
    _$MerchantReportTicketDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$MerchantReportTicketDtoOutput._(ticket: ticket.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ticket';
        ticket.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantReportTicketDtoOutput',
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
