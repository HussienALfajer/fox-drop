// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner_custody_closed_due.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue
    extends AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue([
    void Function(
      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder,
    )?
    updates,
  ]) =>
      (AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue &&
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
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder() {
    AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue;
  }

  @override
  void update(
    void Function(
      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue _build() {
    final _$result =
        _$v ??
        _$AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
