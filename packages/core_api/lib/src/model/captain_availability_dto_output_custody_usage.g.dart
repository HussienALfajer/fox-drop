// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_custody_usage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputCustodyUsage
    extends CaptainAvailabilityDtoOutputCustodyUsage {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainAvailabilityDtoOutputCustodyUsage([
    void Function(CaptainAvailabilityDtoOutputCustodyUsageBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputCustodyUsageBuilder()..update(updates))
      ._build();

  _$CaptainAvailabilityDtoOutputCustodyUsage._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputCustodyUsage rebuild(
    void Function(CaptainAvailabilityDtoOutputCustodyUsageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputCustodyUsageBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputCustodyUsageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputCustodyUsage &&
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
            r'CaptainAvailabilityDtoOutputCustodyUsage',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputCustodyUsageBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputCustodyUsage,
          CaptainAvailabilityDtoOutputCustodyUsageBuilder
        > {
  _$CaptainAvailabilityDtoOutputCustodyUsage? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainAvailabilityDtoOutputCustodyUsageBuilder() {
    CaptainAvailabilityDtoOutputCustodyUsage._defaults(this);
  }

  CaptainAvailabilityDtoOutputCustodyUsageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputCustodyUsage other) {
    _$v = other as _$CaptainAvailabilityDtoOutputCustodyUsage;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputCustodyUsageBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputCustodyUsage build() => _build();

  _$CaptainAvailabilityDtoOutputCustodyUsage _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputCustodyUsage._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainAvailabilityDtoOutputCustodyUsage',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainAvailabilityDtoOutputCustodyUsage',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
