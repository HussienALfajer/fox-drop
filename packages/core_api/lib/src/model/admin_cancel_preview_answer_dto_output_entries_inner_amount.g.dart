// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_preview_answer_dto_output_entries_inner_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount
    extends AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount([
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder)?
    updates,
  ]) =>
      (AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder()
            ..update(updates))
          ._build();

  _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount rebuild(
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder toBuilder() =>
      AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount &&
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
            r'AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder
    implements
        Builder<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount,
          AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder
        > {
  _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder() {
    AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount._defaults(this);
  }

  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount other) {
    _$v = other as _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount;
  }

  @override
  void update(
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerAmountBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount build() => _build();

  _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount _build() {
    final _$result =
        _$v ??
        _$AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCancelPreviewAnswerDtoOutputEntriesInnerAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
