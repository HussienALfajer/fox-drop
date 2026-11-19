// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_base_currency_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetBaseCurrencyDto extends AdminSetBaseCurrencyDto {
  @override
  final String currency;
  @override
  final String? reason;

  factory _$AdminSetBaseCurrencyDto([
    void Function(AdminSetBaseCurrencyDtoBuilder)? updates,
  ]) => (AdminSetBaseCurrencyDtoBuilder()..update(updates))._build();

  _$AdminSetBaseCurrencyDto._({required this.currency, this.reason})
    : super._();
  @override
  AdminSetBaseCurrencyDto rebuild(
    void Function(AdminSetBaseCurrencyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetBaseCurrencyDtoBuilder toBuilder() =>
      AdminSetBaseCurrencyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetBaseCurrencyDto &&
        currency == other.currency &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetBaseCurrencyDto')
          ..add('currency', currency)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSetBaseCurrencyDtoBuilder
    implements
        Builder<AdminSetBaseCurrencyDto, AdminSetBaseCurrencyDtoBuilder> {
  _$AdminSetBaseCurrencyDto? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSetBaseCurrencyDtoBuilder() {
    AdminSetBaseCurrencyDto._defaults(this);
  }

  AdminSetBaseCurrencyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetBaseCurrencyDto other) {
    _$v = other as _$AdminSetBaseCurrencyDto;
  }

  @override
  void update(void Function(AdminSetBaseCurrencyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetBaseCurrencyDto build() => _build();

  _$AdminSetBaseCurrencyDto _build() {
    final _$result =
        _$v ??
        _$AdminSetBaseCurrencyDto._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminSetBaseCurrencyDto',
            'currency',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
