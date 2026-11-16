// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_overdue_dto_output_overdue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOverdueDtoOutputOverdue
    extends MerchantOverdueDtoOutputOverdue {
  @override
  final String amount;
  @override
  final Date statementDate;
  @override
  final String currency;

  factory _$MerchantOverdueDtoOutputOverdue([
    void Function(MerchantOverdueDtoOutputOverdueBuilder)? updates,
  ]) => (MerchantOverdueDtoOutputOverdueBuilder()..update(updates))._build();

  _$MerchantOverdueDtoOutputOverdue._({
    required this.amount,
    required this.statementDate,
    required this.currency,
  }) : super._();
  @override
  MerchantOverdueDtoOutputOverdue rebuild(
    void Function(MerchantOverdueDtoOutputOverdueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOverdueDtoOutputOverdueBuilder toBuilder() =>
      MerchantOverdueDtoOutputOverdueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOverdueDtoOutputOverdue &&
        amount == other.amount &&
        statementDate == other.statementDate &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, statementDate.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOverdueDtoOutputOverdue')
          ..add('amount', amount)
          ..add('statementDate', statementDate)
          ..add('currency', currency))
        .toString();
  }
}

class MerchantOverdueDtoOutputOverdueBuilder
    implements
        Builder<
          MerchantOverdueDtoOutputOverdue,
          MerchantOverdueDtoOutputOverdueBuilder
        > {
  _$MerchantOverdueDtoOutputOverdue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  Date? _statementDate;
  Date? get statementDate => _$this._statementDate;
  set statementDate(Date? statementDate) =>
      _$this._statementDate = statementDate;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantOverdueDtoOutputOverdueBuilder() {
    MerchantOverdueDtoOutputOverdue._defaults(this);
  }

  MerchantOverdueDtoOutputOverdueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _statementDate = $v.statementDate;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOverdueDtoOutputOverdue other) {
    _$v = other as _$MerchantOverdueDtoOutputOverdue;
  }

  @override
  void update(void Function(MerchantOverdueDtoOutputOverdueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOverdueDtoOutputOverdue build() => _build();

  _$MerchantOverdueDtoOutputOverdue _build() {
    final _$result =
        _$v ??
        _$MerchantOverdueDtoOutputOverdue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantOverdueDtoOutputOverdue',
            'amount',
          ),
          statementDate: BuiltValueNullFieldError.checkNotNull(
            statementDate,
            r'MerchantOverdueDtoOutputOverdue',
            'statementDate',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'MerchantOverdueDtoOutputOverdue',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
