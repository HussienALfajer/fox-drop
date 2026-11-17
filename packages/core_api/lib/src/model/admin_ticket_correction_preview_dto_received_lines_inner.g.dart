// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_correction_preview_dto_received_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCorrectionPreviewDtoReceivedLinesInner
    extends AdminTicketCorrectionPreviewDtoReceivedLinesInner {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminTicketCorrectionPreviewDtoReceivedLinesInner([
    void Function(AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder)?
    updates,
  ]) =>
      (AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminTicketCorrectionPreviewDtoReceivedLinesInner._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminTicketCorrectionPreviewDtoReceivedLinesInner rebuild(
    void Function(AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder toBuilder() =>
      AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCorrectionPreviewDtoReceivedLinesInner &&
        amount == other.amount &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketCorrectionPreviewDtoReceivedLinesInner',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder
    implements
        Builder<
          AdminTicketCorrectionPreviewDtoReceivedLinesInner,
          AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder
        > {
  _$AdminTicketCorrectionPreviewDtoReceivedLinesInner? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder() {
    AdminTicketCorrectionPreviewDtoReceivedLinesInner._defaults(this);
  }

  AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCorrectionPreviewDtoReceivedLinesInner other) {
    _$v = other as _$AdminTicketCorrectionPreviewDtoReceivedLinesInner;
  }

  @override
  void update(
    void Function(AdminTicketCorrectionPreviewDtoReceivedLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCorrectionPreviewDtoReceivedLinesInner build() => _build();

  _$AdminTicketCorrectionPreviewDtoReceivedLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminTicketCorrectionPreviewDtoReceivedLinesInner._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminTicketCorrectionPreviewDtoReceivedLinesInner',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminTicketCorrectionPreviewDtoReceivedLinesInner',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
