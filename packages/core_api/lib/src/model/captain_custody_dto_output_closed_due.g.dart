// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_closed_due.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputClosedDue
    extends CaptainCustodyDtoOutputClosedDue {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainCustodyDtoOutputClosedDue([
    void Function(CaptainCustodyDtoOutputClosedDueBuilder)? updates,
  ]) => (CaptainCustodyDtoOutputClosedDueBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutputClosedDue._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainCustodyDtoOutputClosedDue rebuild(
    void Function(CaptainCustodyDtoOutputClosedDueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputClosedDueBuilder toBuilder() =>
      CaptainCustodyDtoOutputClosedDueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputClosedDue &&
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
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutputClosedDue')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainCustodyDtoOutputClosedDueBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputClosedDue,
          CaptainCustodyDtoOutputClosedDueBuilder
        > {
  _$CaptainCustodyDtoOutputClosedDue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainCustodyDtoOutputClosedDueBuilder() {
    CaptainCustodyDtoOutputClosedDue._defaults(this);
  }

  CaptainCustodyDtoOutputClosedDueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutputClosedDue other) {
    _$v = other as _$CaptainCustodyDtoOutputClosedDue;
  }

  @override
  void update(void Function(CaptainCustodyDtoOutputClosedDueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputClosedDue build() => _build();

  _$CaptainCustodyDtoOutputClosedDue _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputClosedDue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputClosedDue',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCustodyDtoOutputClosedDue',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
