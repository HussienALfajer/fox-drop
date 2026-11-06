// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_went_offline_dto_output_hand_in.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainWentOfflineDtoOutputHandIn
    extends CaptainWentOfflineDtoOutputHandIn {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainWentOfflineDtoOutputHandIn([
    void Function(CaptainWentOfflineDtoOutputHandInBuilder)? updates,
  ]) => (CaptainWentOfflineDtoOutputHandInBuilder()..update(updates))._build();

  _$CaptainWentOfflineDtoOutputHandIn._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainWentOfflineDtoOutputHandIn rebuild(
    void Function(CaptainWentOfflineDtoOutputHandInBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainWentOfflineDtoOutputHandInBuilder toBuilder() =>
      CaptainWentOfflineDtoOutputHandInBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainWentOfflineDtoOutputHandIn &&
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
    return (newBuiltValueToStringHelper(r'CaptainWentOfflineDtoOutputHandIn')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainWentOfflineDtoOutputHandInBuilder
    implements
        Builder<
          CaptainWentOfflineDtoOutputHandIn,
          CaptainWentOfflineDtoOutputHandInBuilder
        > {
  _$CaptainWentOfflineDtoOutputHandIn? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainWentOfflineDtoOutputHandInBuilder() {
    CaptainWentOfflineDtoOutputHandIn._defaults(this);
  }

  CaptainWentOfflineDtoOutputHandInBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainWentOfflineDtoOutputHandIn other) {
    _$v = other as _$CaptainWentOfflineDtoOutputHandIn;
  }

  @override
  void update(
    void Function(CaptainWentOfflineDtoOutputHandInBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainWentOfflineDtoOutputHandIn build() => _build();

  _$CaptainWentOfflineDtoOutputHandIn _build() {
    final _$result =
        _$v ??
        _$CaptainWentOfflineDtoOutputHandIn._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainWentOfflineDtoOutputHandIn',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainWentOfflineDtoOutputHandIn',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
