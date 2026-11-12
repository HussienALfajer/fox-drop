// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_open_drawer_session_dto_floats_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOpenDrawerSessionDtoFloatsInner
    extends AdminOpenDrawerSessionDtoFloatsInner {
  @override
  final String currency;
  @override
  final String amount;

  factory _$AdminOpenDrawerSessionDtoFloatsInner([
    void Function(AdminOpenDrawerSessionDtoFloatsInnerBuilder)? updates,
  ]) =>
      (AdminOpenDrawerSessionDtoFloatsInnerBuilder()..update(updates))._build();

  _$AdminOpenDrawerSessionDtoFloatsInner._({
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  AdminOpenDrawerSessionDtoFloatsInner rebuild(
    void Function(AdminOpenDrawerSessionDtoFloatsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOpenDrawerSessionDtoFloatsInnerBuilder toBuilder() =>
      AdminOpenDrawerSessionDtoFloatsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOpenDrawerSessionDtoFloatsInner &&
        currency == other.currency &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOpenDrawerSessionDtoFloatsInner')
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class AdminOpenDrawerSessionDtoFloatsInnerBuilder
    implements
        Builder<
          AdminOpenDrawerSessionDtoFloatsInner,
          AdminOpenDrawerSessionDtoFloatsInnerBuilder
        > {
  _$AdminOpenDrawerSessionDtoFloatsInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminOpenDrawerSessionDtoFloatsInnerBuilder() {
    AdminOpenDrawerSessionDtoFloatsInner._defaults(this);
  }

  AdminOpenDrawerSessionDtoFloatsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOpenDrawerSessionDtoFloatsInner other) {
    _$v = other as _$AdminOpenDrawerSessionDtoFloatsInner;
  }

  @override
  void update(
    void Function(AdminOpenDrawerSessionDtoFloatsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOpenDrawerSessionDtoFloatsInner build() => _build();

  _$AdminOpenDrawerSessionDtoFloatsInner _build() {
    final _$result =
        _$v ??
        _$AdminOpenDrawerSessionDtoFloatsInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminOpenDrawerSessionDtoFloatsInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminOpenDrawerSessionDtoFloatsInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
