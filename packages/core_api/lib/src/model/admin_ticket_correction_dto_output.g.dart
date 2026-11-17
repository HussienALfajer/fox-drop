// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_correction_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCorrectionDtoOutput extends AdminTicketCorrectionDtoOutput {
  @override
  final BuiltList<AdminTicketPageDtoOutputPickupDisputePickupPayment?>
  captainChanges;
  @override
  final AdminTicketCorrectionDtoOutputMerchant merchant;
  @override
  final BuiltList<AdminTicketCorrectionDtoOutputEntriesInner> entries;

  factory _$AdminTicketCorrectionDtoOutput([
    void Function(AdminTicketCorrectionDtoOutputBuilder)? updates,
  ]) => (AdminTicketCorrectionDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketCorrectionDtoOutput._({
    required this.captainChanges,
    required this.merchant,
    required this.entries,
  }) : super._();
  @override
  AdminTicketCorrectionDtoOutput rebuild(
    void Function(AdminTicketCorrectionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCorrectionDtoOutputBuilder toBuilder() =>
      AdminTicketCorrectionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCorrectionDtoOutput &&
        captainChanges == other.captainChanges &&
        merchant == other.merchant &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainChanges.hashCode);
    _$hash = $jc(_$hash, merchant.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketCorrectionDtoOutput')
          ..add('captainChanges', captainChanges)
          ..add('merchant', merchant)
          ..add('entries', entries))
        .toString();
  }
}

class AdminTicketCorrectionDtoOutputBuilder
    implements
        Builder<
          AdminTicketCorrectionDtoOutput,
          AdminTicketCorrectionDtoOutputBuilder
        > {
  _$AdminTicketCorrectionDtoOutput? _$v;

  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>?
  _captainChanges;
  ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>
  get captainChanges => _$this._captainChanges ??=
      ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>();
  set captainChanges(
    ListBuilder<AdminTicketPageDtoOutputPickupDisputePickupPayment?>?
    captainChanges,
  ) => _$this._captainChanges = captainChanges;

  AdminTicketCorrectionDtoOutputMerchantBuilder? _merchant;
  AdminTicketCorrectionDtoOutputMerchantBuilder get merchant =>
      _$this._merchant ??= AdminTicketCorrectionDtoOutputMerchantBuilder();
  set merchant(AdminTicketCorrectionDtoOutputMerchantBuilder? merchant) =>
      _$this._merchant = merchant;

  ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminTicketCorrectionDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminTicketCorrectionDtoOutputBuilder() {
    AdminTicketCorrectionDtoOutput._defaults(this);
  }

  AdminTicketCorrectionDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainChanges = $v.captainChanges.toBuilder();
      _merchant = $v.merchant.toBuilder();
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCorrectionDtoOutput other) {
    _$v = other as _$AdminTicketCorrectionDtoOutput;
  }

  @override
  void update(void Function(AdminTicketCorrectionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCorrectionDtoOutput build() => _build();

  _$AdminTicketCorrectionDtoOutput _build() {
    _$AdminTicketCorrectionDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketCorrectionDtoOutput._(
            captainChanges: captainChanges.build(),
            merchant: merchant.build(),
            entries: entries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captainChanges';
        captainChanges.build();
        _$failedField = 'merchant';
        merchant.build();
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketCorrectionDtoOutput',
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
