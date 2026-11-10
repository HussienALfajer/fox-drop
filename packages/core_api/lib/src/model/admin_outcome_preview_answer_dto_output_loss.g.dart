// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_preview_answer_dto_output_loss.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOutcomePreviewAnswerDtoOutputLoss
    extends AdminOutcomePreviewAnswerDtoOutputLoss {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminOutcomePreviewAnswerDtoOutputLoss([
    void Function(AdminOutcomePreviewAnswerDtoOutputLossBuilder)? updates,
  ]) => (AdminOutcomePreviewAnswerDtoOutputLossBuilder()..update(updates))
      ._build();

  _$AdminOutcomePreviewAnswerDtoOutputLoss._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminOutcomePreviewAnswerDtoOutputLoss rebuild(
    void Function(AdminOutcomePreviewAnswerDtoOutputLossBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomePreviewAnswerDtoOutputLossBuilder toBuilder() =>
      AdminOutcomePreviewAnswerDtoOutputLossBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomePreviewAnswerDtoOutputLoss &&
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
            r'AdminOutcomePreviewAnswerDtoOutputLoss',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminOutcomePreviewAnswerDtoOutputLossBuilder
    implements
        Builder<
          AdminOutcomePreviewAnswerDtoOutputLoss,
          AdminOutcomePreviewAnswerDtoOutputLossBuilder
        > {
  _$AdminOutcomePreviewAnswerDtoOutputLoss? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOutcomePreviewAnswerDtoOutputLossBuilder() {
    AdminOutcomePreviewAnswerDtoOutputLoss._defaults(this);
  }

  AdminOutcomePreviewAnswerDtoOutputLossBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomePreviewAnswerDtoOutputLoss other) {
    _$v = other as _$AdminOutcomePreviewAnswerDtoOutputLoss;
  }

  @override
  void update(
    void Function(AdminOutcomePreviewAnswerDtoOutputLossBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomePreviewAnswerDtoOutputLoss build() => _build();

  _$AdminOutcomePreviewAnswerDtoOutputLoss _build() {
    final _$result =
        _$v ??
        _$AdminOutcomePreviewAnswerDtoOutputLoss._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOutcomePreviewAnswerDtoOutputLoss',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOutcomePreviewAnswerDtoOutputLoss',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
