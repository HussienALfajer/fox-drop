// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_usage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputUsage extends CaptainCustodyDtoOutputUsage {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCustodyDtoOutputUsage([
    void Function(CaptainCustodyDtoOutputUsageBuilder)? updates,
  ]) => (CaptainCustodyDtoOutputUsageBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutputUsage._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCustodyDtoOutputUsage rebuild(
    void Function(CaptainCustodyDtoOutputUsageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputUsageBuilder toBuilder() =>
      CaptainCustodyDtoOutputUsageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputUsage &&
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
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutputUsage')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCustodyDtoOutputUsageBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputUsage,
          CaptainCustodyDtoOutputUsageBuilder
        > {
  _$CaptainCustodyDtoOutputUsage? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCustodyDtoOutputUsageBuilder() {
    CaptainCustodyDtoOutputUsage._defaults(this);
  }

  CaptainCustodyDtoOutputUsageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputUsage other) {
    _$v = other as _$CaptainCustodyDtoOutputUsage;
  }

  @override
  void update(void Function(CaptainCustodyDtoOutputUsageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputUsage build() => _build();

  _$CaptainCustodyDtoOutputUsage _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputUsage._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputUsage',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCustodyDtoOutputUsage',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
