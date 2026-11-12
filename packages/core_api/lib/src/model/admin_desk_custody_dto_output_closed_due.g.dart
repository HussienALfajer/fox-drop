// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_custody_dto_output_closed_due.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeskCustodyDtoOutputClosedDue
    extends AdminDeskCustodyDtoOutputClosedDue {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDeskCustodyDtoOutputClosedDue([
    void Function(AdminDeskCustodyDtoOutputClosedDueBuilder)? updates,
  ]) => (AdminDeskCustodyDtoOutputClosedDueBuilder()..update(updates))._build();

  _$AdminDeskCustodyDtoOutputClosedDue._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminDeskCustodyDtoOutputClosedDue rebuild(
    void Function(AdminDeskCustodyDtoOutputClosedDueBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCustodyDtoOutputClosedDueBuilder toBuilder() =>
      AdminDeskCustodyDtoOutputClosedDueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCustodyDtoOutputClosedDue &&
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
    return (newBuiltValueToStringHelper(r'AdminDeskCustodyDtoOutputClosedDue')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDeskCustodyDtoOutputClosedDueBuilder
    implements
        Builder<
          AdminDeskCustodyDtoOutputClosedDue,
          AdminDeskCustodyDtoOutputClosedDueBuilder
        > {
  _$AdminDeskCustodyDtoOutputClosedDue? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDeskCustodyDtoOutputClosedDueBuilder() {
    AdminDeskCustodyDtoOutputClosedDue._defaults(this);
  }

  AdminDeskCustodyDtoOutputClosedDueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeskCustodyDtoOutputClosedDue other) {
    _$v = other as _$AdminDeskCustodyDtoOutputClosedDue;
  }

  @override
  void update(
    void Function(AdminDeskCustodyDtoOutputClosedDueBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCustodyDtoOutputClosedDue build() => _build();

  _$AdminDeskCustodyDtoOutputClosedDue _build() {
    final _$result =
        _$v ??
        _$AdminDeskCustodyDtoOutputClosedDue._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDeskCustodyDtoOutputClosedDue',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDeskCustodyDtoOutputClosedDue',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
