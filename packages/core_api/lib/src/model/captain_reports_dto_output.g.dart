// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_reports_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainReportsDtoOutput extends CaptainReportsDtoOutput {
  @override
  final BuiltList<CaptainReportTicketDtoOutputTicket> tickets;

  factory _$CaptainReportsDtoOutput([
    void Function(CaptainReportsDtoOutputBuilder)? updates,
  ]) => (CaptainReportsDtoOutputBuilder()..update(updates))._build();

  _$CaptainReportsDtoOutput._({required this.tickets}) : super._();
  @override
  CaptainReportsDtoOutput rebuild(
    void Function(CaptainReportsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainReportsDtoOutputBuilder toBuilder() =>
      CaptainReportsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainReportsDtoOutput && tickets == other.tickets;
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
      r'CaptainReportsDtoOutput',
    )..add('tickets', tickets)).toString();
  }
}

class CaptainReportsDtoOutputBuilder
    implements
        Builder<CaptainReportsDtoOutput, CaptainReportsDtoOutputBuilder> {
  _$CaptainReportsDtoOutput? _$v;

  ListBuilder<CaptainReportTicketDtoOutputTicket>? _tickets;
  ListBuilder<CaptainReportTicketDtoOutputTicket> get tickets =>
      _$this._tickets ??= ListBuilder<CaptainReportTicketDtoOutputTicket>();
  set tickets(ListBuilder<CaptainReportTicketDtoOutputTicket>? tickets) =>
      _$this._tickets = tickets;

  CaptainReportsDtoOutputBuilder() {
    CaptainReportsDtoOutput._defaults(this);
  }

  CaptainReportsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tickets = $v.tickets.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainReportsDtoOutput other) {
    _$v = other as _$CaptainReportsDtoOutput;
  }

  @override
  void update(void Function(CaptainReportsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainReportsDtoOutput build() => _build();

  _$CaptainReportsDtoOutput _build() {
    _$CaptainReportsDtoOutput _$result;
    try {
      _$result = _$v ?? _$CaptainReportsDtoOutput._(tickets: tickets.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tickets';
        tickets.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainReportsDtoOutput',
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
