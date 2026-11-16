// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account_dto_output_overdue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccountDtoOutputOverdue
    extends MerchantAccountDtoOutputOverdue {
  @override
  final String amount;
  @override
  final Date statementDate;

  factory _$MerchantAccountDtoOutputOverdue([
    void Function(MerchantAccountDtoOutputOverdueBuilder)? updates,
  ]) => (MerchantAccountDtoOutputOverdueBuilder()..update(updates))._build();

  _$MerchantAccountDtoOutputOverdue._({
    required this.amount,
    required this.statementDate,
  }) : super._();
  @override
  MerchantAccountDtoOutputOverdue rebuild(
    void Function(MerchantAccountDtoOutputOverdueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAccountDtoOutputOverdueBuilder toBuilder() =>
      MerchantAccountDtoOutputOverdueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccountDtoOutputOverdue &&
        amount == other.amount &&
        statementDate == other.statementDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, statementDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantAccountDtoOutputOverdue')
          ..add('amount', amount)
          ..add('statementDate', statementDate))
        .toString();
  }
}

class MerchantAccountDtoOutputOverdueBuilder
    implements
        Builder<
          MerchantAccountDtoOutputOverdue,
          MerchantAccountDtoOutputOverdueBuilder
        > {
  _$MerchantAccountDtoOutputOverdue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  Date? _statementDate;
  Date? get statementDate => _$this._statementDate;
  set statementDate(Date? statementDate) =>
      _$this._statementDate = statementDate;

  MerchantAccountDtoOutputOverdueBuilder() {
    MerchantAccountDtoOutputOverdue._defaults(this);
  }

  MerchantAccountDtoOutputOverdueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _statementDate = $v.statementDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccountDtoOutputOverdue other) {
    _$v = other as _$MerchantAccountDtoOutputOverdue;
  }

  @override
  void update(void Function(MerchantAccountDtoOutputOverdueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccountDtoOutputOverdue build() => _build();

  _$MerchantAccountDtoOutputOverdue _build() {
    final _$result =
        _$v ??
        _$MerchantAccountDtoOutputOverdue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'MerchantAccountDtoOutputOverdue',
            'amount',
          ),
          statementDate: BuiltValueNullFieldError.checkNotNull(
            statementDate,
            r'MerchantAccountDtoOutputOverdue',
            'statementDate',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
