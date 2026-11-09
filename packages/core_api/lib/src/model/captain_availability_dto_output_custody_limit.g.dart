// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_custody_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputCustodyLimit
    extends CaptainAvailabilityDtoOutputCustodyLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainAvailabilityDtoOutputCustodyLimit([
    void Function(CaptainAvailabilityDtoOutputCustodyLimitBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputCustodyLimitBuilder()..update(updates))
      ._build();

  _$CaptainAvailabilityDtoOutputCustodyLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputCustodyLimit rebuild(
    void Function(CaptainAvailabilityDtoOutputCustodyLimitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputCustodyLimitBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputCustodyLimitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputCustodyLimit &&
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
            r'CaptainAvailabilityDtoOutputCustodyLimit',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputCustodyLimitBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputCustodyLimit,
          CaptainAvailabilityDtoOutputCustodyLimitBuilder
        > {
  _$CaptainAvailabilityDtoOutputCustodyLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainAvailabilityDtoOutputCustodyLimitBuilder() {
    CaptainAvailabilityDtoOutputCustodyLimit._defaults(this);
  }

  CaptainAvailabilityDtoOutputCustodyLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputCustodyLimit other) {
    _$v = other as _$CaptainAvailabilityDtoOutputCustodyLimit;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputCustodyLimitBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputCustodyLimit build() => _build();

  _$CaptainAvailabilityDtoOutputCustodyLimit _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputCustodyLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainAvailabilityDtoOutputCustodyLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainAvailabilityDtoOutputCustodyLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
