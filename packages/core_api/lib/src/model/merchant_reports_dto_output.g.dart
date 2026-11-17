// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_reports_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantReportsDtoOutput extends MerchantReportsDtoOutput {
  @override
  final BuiltList<MerchantReportTicketDtoOutputTicket> tickets;

  factory _$MerchantReportsDtoOutput([
    void Function(MerchantReportsDtoOutputBuilder)? updates,
  ]) => (MerchantReportsDtoOutputBuilder()..update(updates))._build();

  _$MerchantReportsDtoOutput._({required this.tickets}) : super._();
  @override
  MerchantReportsDtoOutput rebuild(
    void Function(MerchantReportsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReportsDtoOutputBuilder toBuilder() =>
      MerchantReportsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReportsDtoOutput && tickets == other.tickets;
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
      r'MerchantReportsDtoOutput',
    )..add('tickets', tickets)).toString();
  }
}

class MerchantReportsDtoOutputBuilder
    implements
        Builder<MerchantReportsDtoOutput, MerchantReportsDtoOutputBuilder> {
  _$MerchantReportsDtoOutput? _$v;

  ListBuilder<MerchantReportTicketDtoOutputTicket>? _tickets;
  ListBuilder<MerchantReportTicketDtoOutputTicket> get tickets =>
      _$this._tickets ??= ListBuilder<MerchantReportTicketDtoOutputTicket>();
  set tickets(ListBuilder<MerchantReportTicketDtoOutputTicket>? tickets) =>
      _$this._tickets = tickets;

  MerchantReportsDtoOutputBuilder() {
    MerchantReportsDtoOutput._defaults(this);
  }

  MerchantReportsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tickets = $v.tickets.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReportsDtoOutput other) {
    _$v = other as _$MerchantReportsDtoOutput;
  }

  @override
  void update(void Function(MerchantReportsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReportsDtoOutput build() => _build();

  _$MerchantReportsDtoOutput _build() {
    _$MerchantReportsDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantReportsDtoOutput._(tickets: tickets.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tickets';
        tickets.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantReportsDtoOutput',
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
