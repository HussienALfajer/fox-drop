// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_custody_currencies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner
    extends AdminCaptainProfileDtoOutputCustodyCurrenciesInner {
  @override
  final String currency;
  @override
  final String balance;
  @override
  final String closedDue;
  @override
  final String today;
  @override
  final String balanceInBase;

  factory _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner([
    void Function(AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder)?
    updates,
  ]) =>
      (AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner._({
    required this.currency,
    required this.balance,
    required this.closedDue,
    required this.today,
    required this.balanceInBase,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputCustodyCurrenciesInner rebuild(
    void Function(AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputCustodyCurrenciesInner &&
        currency == other.currency &&
        balance == other.balance &&
        closedDue == other.closedDue &&
        today == other.today &&
        balanceInBase == other.balanceInBase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, balanceInBase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainProfileDtoOutputCustodyCurrenciesInner',
          )
          ..add('currency', currency)
          ..add('balance', balance)
          ..add('closedDue', closedDue)
          ..add('today', today)
          ..add('balanceInBase', balanceInBase))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputCustodyCurrenciesInner,
          AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder
        > {
  _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  String? _closedDue;
  String? get closedDue => _$this._closedDue;
  set closedDue(String? closedDue) => _$this._closedDue = closedDue;

  String? _today;
  String? get today => _$this._today;
  set today(String? today) => _$this._today = today;

  String? _balanceInBase;
  String? get balanceInBase => _$this._balanceInBase;
  set balanceInBase(String? balanceInBase) =>
      _$this._balanceInBase = balanceInBase;

  AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder() {
    AdminCaptainProfileDtoOutputCustodyCurrenciesInner._defaults(this);
  }

  AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _balance = $v.balance;
      _closedDue = $v.closedDue;
      _today = $v.today;
      _balanceInBase = $v.balanceInBase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputCustodyCurrenciesInner other) {
    _$v = other as _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputCustodyCurrenciesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputCustodyCurrenciesInner build() => _build();

  _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainProfileDtoOutputCustodyCurrenciesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainProfileDtoOutputCustodyCurrenciesInner',
            'currency',
          ),
          balance: BuiltValueNullFieldError.checkNotNull(
            balance,
            r'AdminCaptainProfileDtoOutputCustodyCurrenciesInner',
            'balance',
          ),
          closedDue: BuiltValueNullFieldError.checkNotNull(
            closedDue,
            r'AdminCaptainProfileDtoOutputCustodyCurrenciesInner',
            'closedDue',
          ),
          today: BuiltValueNullFieldError.checkNotNull(
            today,
            r'AdminCaptainProfileDtoOutputCustodyCurrenciesInner',
            'today',
          ),
          balanceInBase: BuiltValueNullFieldError.checkNotNull(
            balanceInBase,
            r'AdminCaptainProfileDtoOutputCustodyCurrenciesInner',
            'balanceInBase',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
