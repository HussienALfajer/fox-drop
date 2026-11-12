// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_custody_dto_output_currencies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeskCustodyDtoOutputCurrenciesInner
    extends AdminDeskCustodyDtoOutputCurrenciesInner {
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

  factory _$AdminDeskCustodyDtoOutputCurrenciesInner([
    void Function(AdminDeskCustodyDtoOutputCurrenciesInnerBuilder)? updates,
  ]) => (AdminDeskCustodyDtoOutputCurrenciesInnerBuilder()..update(updates))
      ._build();

  _$AdminDeskCustodyDtoOutputCurrenciesInner._({
    required this.currency,
    required this.balance,
    required this.closedDue,
    required this.today,
    required this.balanceInBase,
  }) : super._();
  @override
  AdminDeskCustodyDtoOutputCurrenciesInner rebuild(
    void Function(AdminDeskCustodyDtoOutputCurrenciesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCustodyDtoOutputCurrenciesInnerBuilder toBuilder() =>
      AdminDeskCustodyDtoOutputCurrenciesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCustodyDtoOutputCurrenciesInner &&
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
            r'AdminDeskCustodyDtoOutputCurrenciesInner',
          )
          ..add('currency', currency)
          ..add('balance', balance)
          ..add('closedDue', closedDue)
          ..add('today', today)
          ..add('balanceInBase', balanceInBase))
        .toString();
  }
}

class AdminDeskCustodyDtoOutputCurrenciesInnerBuilder
    implements
        Builder<
          AdminDeskCustodyDtoOutputCurrenciesInner,
          AdminDeskCustodyDtoOutputCurrenciesInnerBuilder
        > {
  _$AdminDeskCustodyDtoOutputCurrenciesInner? _$v;

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

  AdminDeskCustodyDtoOutputCurrenciesInnerBuilder() {
    AdminDeskCustodyDtoOutputCurrenciesInner._defaults(this);
  }

  AdminDeskCustodyDtoOutputCurrenciesInnerBuilder get _$this {
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
  void replace(AdminDeskCustodyDtoOutputCurrenciesInner other) {
    _$v = other as _$AdminDeskCustodyDtoOutputCurrenciesInner;
  }

  @override
  void update(
    void Function(AdminDeskCustodyDtoOutputCurrenciesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCustodyDtoOutputCurrenciesInner build() => _build();

  _$AdminDeskCustodyDtoOutputCurrenciesInner _build() {
    final _$result =
        _$v ??
        _$AdminDeskCustodyDtoOutputCurrenciesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDeskCustodyDtoOutputCurrenciesInner',
            'currency',
          ),
          balance: BuiltValueNullFieldError.checkNotNull(
            balance,
            r'AdminDeskCustodyDtoOutputCurrenciesInner',
            'balance',
          ),
          closedDue: BuiltValueNullFieldError.checkNotNull(
            closedDue,
            r'AdminDeskCustodyDtoOutputCurrenciesInner',
            'closedDue',
          ),
          today: BuiltValueNullFieldError.checkNotNull(
            today,
            r'AdminDeskCustodyDtoOutputCurrenciesInner',
            'today',
          ),
          balanceInBase: BuiltValueNullFieldError.checkNotNull(
            balanceInBase,
            r'AdminDeskCustodyDtoOutputCurrenciesInner',
            'balanceInBase',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
