// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
    extends
        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner([
    void Function(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner rebuild(
    void Function(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
  toBuilder() =>
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner &&
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
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
    implements
        Builder<
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
          AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
        > {
  _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder() {
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner._defaults(
      this,
    );
  }

  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner other,
  ) {
    _$v =
        other
            as _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner;
  }

  @override
  void update(
    void Function(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner build() =>
      _build();

  _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  _build() {
    final _$result =
        _$v ??
        _$AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
