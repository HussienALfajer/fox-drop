// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_money_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketMoneyPreviewDtoOutput
    extends AdminTicketMoneyPreviewDtoOutput {
  @override
  final String? currency;
  @override
  final String affectedValue;
  @override
  final String merchantDebit;
  @override
  final String captainCharge;
  @override
  final BuiltList<AdminTicketCorrectionDtoOutputEntriesInner> entries;
  @override
  final AdminTicketMoneyPreviewDtoOutputRedelivery? redelivery;

  factory _$AdminTicketMoneyPreviewDtoOutput([
    void Function(AdminTicketMoneyPreviewDtoOutputBuilder)? updates,
  ]) => (AdminTicketMoneyPreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketMoneyPreviewDtoOutput._({
    this.currency,
    required this.affectedValue,
    required this.merchantDebit,
    required this.captainCharge,
    required this.entries,
    this.redelivery,
  }) : super._();
  @override
  AdminTicketMoneyPreviewDtoOutput rebuild(
    void Function(AdminTicketMoneyPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketMoneyPreviewDtoOutputBuilder toBuilder() =>
      AdminTicketMoneyPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketMoneyPreviewDtoOutput &&
        currency == other.currency &&
        affectedValue == other.affectedValue &&
        merchantDebit == other.merchantDebit &&
        captainCharge == other.captainCharge &&
        entries == other.entries &&
        redelivery == other.redelivery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, affectedValue.hashCode);
    _$hash = $jc(_$hash, merchantDebit.hashCode);
    _$hash = $jc(_$hash, captainCharge.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jc(_$hash, redelivery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketMoneyPreviewDtoOutput')
          ..add('currency', currency)
          ..add('affectedValue', affectedValue)
          ..add('merchantDebit', merchantDebit)
          ..add('captainCharge', captainCharge)
          ..add('entries', entries)
          ..add('redelivery', redelivery))
        .toString();
  }
}

class AdminTicketMoneyPreviewDtoOutputBuilder
    implements
        Builder<
          AdminTicketMoneyPreviewDtoOutput,
          AdminTicketMoneyPreviewDtoOutputBuilder
        > {
  _$AdminTicketMoneyPreviewDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _affectedValue;
  String? get affectedValue => _$this._affectedValue;
  set affectedValue(String? affectedValue) =>
      _$this._affectedValue = affectedValue;

  String? _merchantDebit;
  String? get merchantDebit => _$this._merchantDebit;
  set merchantDebit(String? merchantDebit) =>
      _$this._merchantDebit = merchantDebit;

  String? _captainCharge;
  String? get captainCharge => _$this._captainCharge;
  set captainCharge(String? captainCharge) =>
      _$this._captainCharge = captainCharge;

  ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder? _redelivery;
  AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder get redelivery =>
      _$this._redelivery ??=
          AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder();
  set redelivery(
    AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder? redelivery,
  ) => _$this._redelivery = redelivery;

  AdminTicketMoneyPreviewDtoOutputBuilder() {
    AdminTicketMoneyPreviewDtoOutput._defaults(this);
  }

  AdminTicketMoneyPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _affectedValue = $v.affectedValue;
      _merchantDebit = $v.merchantDebit;
      _captainCharge = $v.captainCharge;
      _entries = $v.entries.toBuilder();
      _redelivery = $v.redelivery?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketMoneyPreviewDtoOutput other) {
    _$v = other as _$AdminTicketMoneyPreviewDtoOutput;
  }

  @override
  void update(void Function(AdminTicketMoneyPreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketMoneyPreviewDtoOutput build() => _build();

  _$AdminTicketMoneyPreviewDtoOutput _build() {
    _$AdminTicketMoneyPreviewDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketMoneyPreviewDtoOutput._(
            currency: currency,
            affectedValue: BuiltValueNullFieldError.checkNotNull(
              affectedValue,
              r'AdminTicketMoneyPreviewDtoOutput',
              'affectedValue',
            ),
            merchantDebit: BuiltValueNullFieldError.checkNotNull(
              merchantDebit,
              r'AdminTicketMoneyPreviewDtoOutput',
              'merchantDebit',
            ),
            captainCharge: BuiltValueNullFieldError.checkNotNull(
              captainCharge,
              r'AdminTicketMoneyPreviewDtoOutput',
              'captainCharge',
            ),
            entries: entries.build(),
            redelivery: _redelivery?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
        _$failedField = 'redelivery';
        _redelivery?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketMoneyPreviewDtoOutput',
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
