// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputLimit extends CaptainCustodyDtoOutputLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCustodyDtoOutputLimit([
    void Function(CaptainCustodyDtoOutputLimitBuilder)? updates,
  ]) => (CaptainCustodyDtoOutputLimitBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutputLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCustodyDtoOutputLimit rebuild(
    void Function(CaptainCustodyDtoOutputLimitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputLimitBuilder toBuilder() =>
      CaptainCustodyDtoOutputLimitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputLimit &&
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
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutputLimit')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCustodyDtoOutputLimitBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputLimit,
          CaptainCustodyDtoOutputLimitBuilder
        > {
  _$CaptainCustodyDtoOutputLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCustodyDtoOutputLimitBuilder() {
    CaptainCustodyDtoOutputLimit._defaults(this);
  }

  CaptainCustodyDtoOutputLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputLimit other) {
    _$v = other as _$CaptainCustodyDtoOutputLimit;
  }

  @override
  void update(void Function(CaptainCustodyDtoOutputLimitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputLimit build() => _build();

  _$CaptainCustodyDtoOutputLimit _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCustodyDtoOutputLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
