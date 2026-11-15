// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_preview_dto_output_custody_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementPreviewDtoOutputCustodyInner
    extends AdminSettlementPreviewDtoOutputCustodyInner {
  @override
  final String currency;
  @override
  final String balance;
  @override
  final String balanceInBase;

  factory _$AdminSettlementPreviewDtoOutputCustodyInner([
    void Function(AdminSettlementPreviewDtoOutputCustodyInnerBuilder)? updates,
  ]) => (AdminSettlementPreviewDtoOutputCustodyInnerBuilder()..update(updates))
      ._build();

  _$AdminSettlementPreviewDtoOutputCustodyInner._({
    required this.currency,
    required this.balance,
    required this.balanceInBase,
  }) : super._();
  @override
  AdminSettlementPreviewDtoOutputCustodyInner rebuild(
    void Function(AdminSettlementPreviewDtoOutputCustodyInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementPreviewDtoOutputCustodyInnerBuilder toBuilder() =>
      AdminSettlementPreviewDtoOutputCustodyInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementPreviewDtoOutputCustodyInner &&
        currency == other.currency &&
        balance == other.balance &&
        balanceInBase == other.balanceInBase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, balanceInBase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSettlementPreviewDtoOutputCustodyInner',
          )
          ..add('currency', currency)
          ..add('balance', balance)
          ..add('balanceInBase', balanceInBase))
        .toString();
  }
}

class AdminSettlementPreviewDtoOutputCustodyInnerBuilder
    implements
        Builder<
          AdminSettlementPreviewDtoOutputCustodyInner,
          AdminSettlementPreviewDtoOutputCustodyInnerBuilder
        > {
  _$AdminSettlementPreviewDtoOutputCustodyInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  String? _balanceInBase;
  String? get balanceInBase => _$this._balanceInBase;
  set balanceInBase(String? balanceInBase) =>
      _$this._balanceInBase = balanceInBase;

  AdminSettlementPreviewDtoOutputCustodyInnerBuilder() {
    AdminSettlementPreviewDtoOutputCustodyInner._defaults(this);
  }

  AdminSettlementPreviewDtoOutputCustodyInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _balance = $v.balance;
      _balanceInBase = $v.balanceInBase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSettlementPreviewDtoOutputCustodyInner other) {
    _$v = other as _$AdminSettlementPreviewDtoOutputCustodyInner;
  }

  @override
  void update(
    void Function(AdminSettlementPreviewDtoOutputCustodyInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementPreviewDtoOutputCustodyInner build() => _build();

  _$AdminSettlementPreviewDtoOutputCustodyInner _build() {
    final _$result =
        _$v ??
        _$AdminSettlementPreviewDtoOutputCustodyInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSettlementPreviewDtoOutputCustodyInner',
            'currency',
          ),
          balance: BuiltValueNullFieldError.checkNotNull(
            balance,
            r'AdminSettlementPreviewDtoOutputCustodyInner',
            'balance',
          ),
          balanceInBase: BuiltValueNullFieldError.checkNotNull(
            balanceInBase,
            r'AdminSettlementPreviewDtoOutputCustodyInner',
            'balanceInBase',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
