// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_answer_dto_output_entries_inner_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount
    extends AdminEditPreviewAnswerDtoOutputEntriesInnerAmount {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount([
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder)?
    updates,
  ]) =>
      (AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder()
            ..update(updates))
          ._build();

  _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmount rebuild(
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder toBuilder() =>
      AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewAnswerDtoOutputEntriesInnerAmount &&
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
            r'AdminEditPreviewAnswerDtoOutputEntriesInnerAmount',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder
    implements
        Builder<
          AdminEditPreviewAnswerDtoOutputEntriesInnerAmount,
          AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder
        > {
  _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder() {
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmount._defaults(this);
  }

  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditPreviewAnswerDtoOutputEntriesInnerAmount other) {
    _$v = other as _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount;
  }

  @override
  void update(
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmount build() => _build();

  _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount _build() {
    final _$result =
        _$v ??
        _$AdminEditPreviewAnswerDtoOutputEntriesInnerAmount._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminEditPreviewAnswerDtoOutputEntriesInnerAmount',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminEditPreviewAnswerDtoOutputEntriesInnerAmount',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
