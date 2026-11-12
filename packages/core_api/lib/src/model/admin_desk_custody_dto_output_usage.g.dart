// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_custody_dto_output_usage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeskCustodyDtoOutputUsage extends AdminDeskCustodyDtoOutputUsage {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminDeskCustodyDtoOutputUsage([
    void Function(AdminDeskCustodyDtoOutputUsageBuilder)? updates,
  ]) => (AdminDeskCustodyDtoOutputUsageBuilder()..update(updates))._build();

  _$AdminDeskCustodyDtoOutputUsage._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminDeskCustodyDtoOutputUsage rebuild(
    void Function(AdminDeskCustodyDtoOutputUsageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCustodyDtoOutputUsageBuilder toBuilder() =>
      AdminDeskCustodyDtoOutputUsageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCustodyDtoOutputUsage &&
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
    return (newBuiltValueToStringHelper(r'AdminDeskCustodyDtoOutputUsage')
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminDeskCustodyDtoOutputUsageBuilder
    implements
        Builder<
          AdminDeskCustodyDtoOutputUsage,
          AdminDeskCustodyDtoOutputUsageBuilder
        > {
  _$AdminDeskCustodyDtoOutputUsage? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminDeskCustodyDtoOutputUsageBuilder() {
    AdminDeskCustodyDtoOutputUsage._defaults(this);
  }

  AdminDeskCustodyDtoOutputUsageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeskCustodyDtoOutputUsage other) {
    _$v = other as _$AdminDeskCustodyDtoOutputUsage;
  }

  @override
  void update(void Function(AdminDeskCustodyDtoOutputUsageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCustodyDtoOutputUsage build() => _build();

  _$AdminDeskCustodyDtoOutputUsage _build() {
    final _$result =
        _$v ??
        _$AdminDeskCustodyDtoOutputUsage._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminDeskCustodyDtoOutputUsage',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDeskCustodyDtoOutputUsage',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
