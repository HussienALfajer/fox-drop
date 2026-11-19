// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_cash_limit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainCashLimitDto extends AdminCaptainCashLimitDto {
  @override
  final String amount;
  @override
  final String currency;
  @override
  final String reason;

  factory _$AdminCaptainCashLimitDto([
    void Function(AdminCaptainCashLimitDtoBuilder)? updates,
  ]) => (AdminCaptainCashLimitDtoBuilder()..update(updates))._build();

  _$AdminCaptainCashLimitDto._({
    required this.amount,
    required this.currency,
    required this.reason,
  }) : super._();
  @override
  AdminCaptainCashLimitDto rebuild(
    void Function(AdminCaptainCashLimitDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainCashLimitDtoBuilder toBuilder() =>
      AdminCaptainCashLimitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainCashLimitDto &&
        amount == other.amount &&
        currency == other.currency &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainCashLimitDto')
          ..add('amount', amount)
          ..add('currency', currency)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCaptainCashLimitDtoBuilder
    implements
        Builder<AdminCaptainCashLimitDto, AdminCaptainCashLimitDtoBuilder> {
  _$AdminCaptainCashLimitDto? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainCashLimitDtoBuilder() {
    AdminCaptainCashLimitDto._defaults(this);
  }

  AdminCaptainCashLimitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainCashLimitDto other) {
    _$v = other as _$AdminCaptainCashLimitDto;
  }

  @override
  void update(void Function(AdminCaptainCashLimitDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainCashLimitDto build() => _build();

  _$AdminCaptainCashLimitDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainCashLimitDto._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminCaptainCashLimitDto',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCaptainCashLimitDto',
            'currency',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainCashLimitDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
