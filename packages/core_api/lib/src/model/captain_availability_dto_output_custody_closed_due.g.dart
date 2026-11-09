// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_custody_closed_due.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputCustodyClosedDue
    extends CaptainAvailabilityDtoOutputCustodyClosedDue {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainAvailabilityDtoOutputCustodyClosedDue([
    void Function(CaptainAvailabilityDtoOutputCustodyClosedDueBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputCustodyClosedDueBuilder()..update(updates))
      ._build();

  _$CaptainAvailabilityDtoOutputCustodyClosedDue._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputCustodyClosedDue rebuild(
    void Function(CaptainAvailabilityDtoOutputCustodyClosedDueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputCustodyClosedDueBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputCustodyClosedDueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputCustodyClosedDue &&
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
            r'CaptainAvailabilityDtoOutputCustodyClosedDue',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputCustodyClosedDueBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputCustodyClosedDue,
          CaptainAvailabilityDtoOutputCustodyClosedDueBuilder
        > {
  _$CaptainAvailabilityDtoOutputCustodyClosedDue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainAvailabilityDtoOutputCustodyClosedDueBuilder() {
    CaptainAvailabilityDtoOutputCustodyClosedDue._defaults(this);
  }

  CaptainAvailabilityDtoOutputCustodyClosedDueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutputCustodyClosedDue other) {
    _$v = other as _$CaptainAvailabilityDtoOutputCustodyClosedDue;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputCustodyClosedDueBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputCustodyClosedDue build() => _build();

  _$CaptainAvailabilityDtoOutputCustodyClosedDue _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputCustodyClosedDue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainAvailabilityDtoOutputCustodyClosedDue',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainAvailabilityDtoOutputCustodyClosedDue',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
