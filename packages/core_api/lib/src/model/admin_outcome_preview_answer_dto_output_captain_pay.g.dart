// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_preview_answer_dto_output_captain_pay.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOutcomePreviewAnswerDtoOutputCaptainPay
    extends AdminOutcomePreviewAnswerDtoOutputCaptainPay {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminOutcomePreviewAnswerDtoOutputCaptainPay([
    void Function(AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder)? updates,
  ]) => (AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder()..update(updates))
      ._build();

  _$AdminOutcomePreviewAnswerDtoOutputCaptainPay._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminOutcomePreviewAnswerDtoOutputCaptainPay rebuild(
    void Function(AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder toBuilder() =>
      AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomePreviewAnswerDtoOutputCaptainPay &&
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
            r'AdminOutcomePreviewAnswerDtoOutputCaptainPay',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder
    implements
        Builder<
          AdminOutcomePreviewAnswerDtoOutputCaptainPay,
          AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder
        > {
  _$AdminOutcomePreviewAnswerDtoOutputCaptainPay? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder() {
    AdminOutcomePreviewAnswerDtoOutputCaptainPay._defaults(this);
  }

  AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomePreviewAnswerDtoOutputCaptainPay other) {
    _$v = other as _$AdminOutcomePreviewAnswerDtoOutputCaptainPay;
  }

  @override
  void update(
    void Function(AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomePreviewAnswerDtoOutputCaptainPay build() => _build();

  _$AdminOutcomePreviewAnswerDtoOutputCaptainPay _build() {
    final _$result =
        _$v ??
        _$AdminOutcomePreviewAnswerDtoOutputCaptainPay._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOutcomePreviewAnswerDtoOutputCaptainPay',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOutcomePreviewAnswerDtoOutputCaptainPay',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
