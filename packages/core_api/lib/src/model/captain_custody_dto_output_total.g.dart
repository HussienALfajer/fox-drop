// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_total.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputTotal extends CaptainCustodyDtoOutputTotal {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCustodyDtoOutputTotal([
    void Function(CaptainCustodyDtoOutputTotalBuilder)? updates,
  ]) => (CaptainCustodyDtoOutputTotalBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutputTotal._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCustodyDtoOutputTotal rebuild(
    void Function(CaptainCustodyDtoOutputTotalBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputTotalBuilder toBuilder() =>
      CaptainCustodyDtoOutputTotalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputTotal &&
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
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutputTotal')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCustodyDtoOutputTotalBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputTotal,
          CaptainCustodyDtoOutputTotalBuilder
        > {
  _$CaptainCustodyDtoOutputTotal? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCustodyDtoOutputTotalBuilder() {
    CaptainCustodyDtoOutputTotal._defaults(this);
  }

  CaptainCustodyDtoOutputTotalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputTotal other) {
    _$v = other as _$CaptainCustodyDtoOutputTotal;
  }

  @override
  void update(void Function(CaptainCustodyDtoOutputTotalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputTotal build() => _build();

  _$CaptainCustodyDtoOutputTotal _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputTotal._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputTotal',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCustodyDtoOutputTotal',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
