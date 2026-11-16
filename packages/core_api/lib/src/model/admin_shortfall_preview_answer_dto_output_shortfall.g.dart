// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shortfall_preview_answer_dto_output_shortfall.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminShortfallPreviewAnswerDtoOutputShortfall
    extends AdminShortfallPreviewAnswerDtoOutputShortfall {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminShortfallPreviewAnswerDtoOutputShortfall([
    void Function(AdminShortfallPreviewAnswerDtoOutputShortfallBuilder)?
    updates,
  ]) =>
      (AdminShortfallPreviewAnswerDtoOutputShortfallBuilder()..update(updates))
          ._build();

  _$AdminShortfallPreviewAnswerDtoOutputShortfall._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminShortfallPreviewAnswerDtoOutputShortfall rebuild(
    void Function(AdminShortfallPreviewAnswerDtoOutputShortfallBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminShortfallPreviewAnswerDtoOutputShortfallBuilder toBuilder() =>
      AdminShortfallPreviewAnswerDtoOutputShortfallBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminShortfallPreviewAnswerDtoOutputShortfall &&
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
            r'AdminShortfallPreviewAnswerDtoOutputShortfall',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminShortfallPreviewAnswerDtoOutputShortfallBuilder
    implements
        Builder<
          AdminShortfallPreviewAnswerDtoOutputShortfall,
          AdminShortfallPreviewAnswerDtoOutputShortfallBuilder
        > {
  _$AdminShortfallPreviewAnswerDtoOutputShortfall? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminShortfallPreviewAnswerDtoOutputShortfallBuilder() {
    AdminShortfallPreviewAnswerDtoOutputShortfall._defaults(this);
  }

  AdminShortfallPreviewAnswerDtoOutputShortfallBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminShortfallPreviewAnswerDtoOutputShortfall other) {
    _$v = other as _$AdminShortfallPreviewAnswerDtoOutputShortfall;
  }

  @override
  void update(
    void Function(AdminShortfallPreviewAnswerDtoOutputShortfallBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminShortfallPreviewAnswerDtoOutputShortfall build() => _build();

  _$AdminShortfallPreviewAnswerDtoOutputShortfall _build() {
    final _$result =
        _$v ??
        _$AdminShortfallPreviewAnswerDtoOutputShortfall._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminShortfallPreviewAnswerDtoOutputShortfall',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminShortfallPreviewAnswerDtoOutputShortfall',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
