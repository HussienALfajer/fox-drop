// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_custody_remit_tolerance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputCustodyRemitTolerance
    extends CaptainAvailabilityDtoOutputCustodyRemitTolerance {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainAvailabilityDtoOutputCustodyRemitTolerance([
    void Function(CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder)?
    updates,
  ]) =>
      (CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder()
            ..update(updates))
          ._build();

  _$CaptainAvailabilityDtoOutputCustodyRemitTolerance._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputCustodyRemitTolerance rebuild(
    void Function(CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputCustodyRemitTolerance &&
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
            r'CaptainAvailabilityDtoOutputCustodyRemitTolerance',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputCustodyRemitTolerance,
          CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder
        > {
  _$CaptainAvailabilityDtoOutputCustodyRemitTolerance? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder() {
    CaptainAvailabilityDtoOutputCustodyRemitTolerance._defaults(this);
  }

  CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputCustodyRemitTolerance other) {
    _$v = other as _$CaptainAvailabilityDtoOutputCustodyRemitTolerance;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputCustodyRemitToleranceBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputCustodyRemitTolerance build() => _build();

  _$CaptainAvailabilityDtoOutputCustodyRemitTolerance _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputCustodyRemitTolerance._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainAvailabilityDtoOutputCustodyRemitTolerance',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainAvailabilityDtoOutputCustodyRemitTolerance',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
