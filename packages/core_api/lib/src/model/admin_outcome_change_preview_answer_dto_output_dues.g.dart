// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_change_preview_answer_dto_output_dues.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOutcomeChangePreviewAnswerDtoOutputDues
    extends AdminOutcomeChangePreviewAnswerDtoOutputDues {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminOutcomeChangePreviewAnswerDtoOutputDues([
    void Function(AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder)? updates,
  ]) => (AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder()..update(updates))
      ._build();

  _$AdminOutcomeChangePreviewAnswerDtoOutputDues._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminOutcomeChangePreviewAnswerDtoOutputDues rebuild(
    void Function(AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder toBuilder() =>
      AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomeChangePreviewAnswerDtoOutputDues &&
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
            r'AdminOutcomeChangePreviewAnswerDtoOutputDues',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder
    implements
        Builder<
          AdminOutcomeChangePreviewAnswerDtoOutputDues,
          AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder
        > {
  _$AdminOutcomeChangePreviewAnswerDtoOutputDues? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder() {
    AdminOutcomeChangePreviewAnswerDtoOutputDues._defaults(this);
  }

  AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomeChangePreviewAnswerDtoOutputDues other) {
    _$v = other as _$AdminOutcomeChangePreviewAnswerDtoOutputDues;
  }

  @override
  void update(
    void Function(AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomeChangePreviewAnswerDtoOutputDues build() => _build();

  _$AdminOutcomeChangePreviewAnswerDtoOutputDues _build() {
    final _$result =
        _$v ??
        _$AdminOutcomeChangePreviewAnswerDtoOutputDues._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOutcomeChangePreviewAnswerDtoOutputDues',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOutcomeChangePreviewAnswerDtoOutputDues',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
