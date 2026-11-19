// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_dto_output_other_currencies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityDtoOutputOtherCurrenciesInner
    extends AdminCityDtoOutputOtherCurrenciesInner {
  @override
  final String code;
  @override
  final String name;
  @override
  final String symbol;

  factory _$AdminCityDtoOutputOtherCurrenciesInner([
    void Function(AdminCityDtoOutputOtherCurrenciesInnerBuilder)? updates,
  ]) => (AdminCityDtoOutputOtherCurrenciesInnerBuilder()..update(updates))
      ._build();

  _$AdminCityDtoOutputOtherCurrenciesInner._({
    required this.code,
    required this.name,
    required this.symbol,
  }) : super._();
  @override
  AdminCityDtoOutputOtherCurrenciesInner rebuild(
    void Function(AdminCityDtoOutputOtherCurrenciesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityDtoOutputOtherCurrenciesInnerBuilder toBuilder() =>
      AdminCityDtoOutputOtherCurrenciesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityDtoOutputOtherCurrenciesInner &&
        code == other.code &&
        name == other.name &&
        symbol == other.symbol;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, symbol.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCityDtoOutputOtherCurrenciesInner',
          )
          ..add('code', code)
          ..add('name', name)
          ..add('symbol', symbol))
        .toString();
  }
}

class AdminCityDtoOutputOtherCurrenciesInnerBuilder
    implements
        Builder<
          AdminCityDtoOutputOtherCurrenciesInner,
          AdminCityDtoOutputOtherCurrenciesInnerBuilder
        > {
  _$AdminCityDtoOutputOtherCurrenciesInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _symbol;
  String? get symbol => _$this._symbol;
  set symbol(String? symbol) => _$this._symbol = symbol;

  AdminCityDtoOutputOtherCurrenciesInnerBuilder() {
    AdminCityDtoOutputOtherCurrenciesInner._defaults(this);
  }

  AdminCityDtoOutputOtherCurrenciesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _symbol = $v.symbol;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityDtoOutputOtherCurrenciesInner other) {
    _$v = other as _$AdminCityDtoOutputOtherCurrenciesInner;
  }

  @override
  void update(
    void Function(AdminCityDtoOutputOtherCurrenciesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityDtoOutputOtherCurrenciesInner build() => _build();

  _$AdminCityDtoOutputOtherCurrenciesInner _build() {
    final _$result =
        _$v ??
        _$AdminCityDtoOutputOtherCurrenciesInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCityDtoOutputOtherCurrenciesInner',
            'code',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminCityDtoOutputOtherCurrenciesInner',
            'name',
          ),
          symbol: BuiltValueNullFieldError.checkNotNull(
            symbol,
            r'AdminCityDtoOutputOtherCurrenciesInner',
            'symbol',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
