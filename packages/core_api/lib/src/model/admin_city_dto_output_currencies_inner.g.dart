// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_dto_output_currencies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityDtoOutputCurrenciesInner
    extends AdminCityDtoOutputCurrenciesInner {
  @override
  final String code;
  @override
  final String name;
  @override
  final String symbol;
  @override
  final int displayOrder;
  @override
  final bool enabled;
  @override
  final bool isBase;

  factory _$AdminCityDtoOutputCurrenciesInner([
    void Function(AdminCityDtoOutputCurrenciesInnerBuilder)? updates,
  ]) => (AdminCityDtoOutputCurrenciesInnerBuilder()..update(updates))._build();

  _$AdminCityDtoOutputCurrenciesInner._({
    required this.code,
    required this.name,
    required this.symbol,
    required this.displayOrder,
    required this.enabled,
    required this.isBase,
  }) : super._();
  @override
  AdminCityDtoOutputCurrenciesInner rebuild(
    void Function(AdminCityDtoOutputCurrenciesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityDtoOutputCurrenciesInnerBuilder toBuilder() =>
      AdminCityDtoOutputCurrenciesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityDtoOutputCurrenciesInner &&
        code == other.code &&
        name == other.name &&
        symbol == other.symbol &&
        displayOrder == other.displayOrder &&
        enabled == other.enabled &&
        isBase == other.isBase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, symbol.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, isBase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCityDtoOutputCurrenciesInner')
          ..add('code', code)
          ..add('name', name)
          ..add('symbol', symbol)
          ..add('displayOrder', displayOrder)
          ..add('enabled', enabled)
          ..add('isBase', isBase))
        .toString();
  }
}

class AdminCityDtoOutputCurrenciesInnerBuilder
    implements
        Builder<
          AdminCityDtoOutputCurrenciesInner,
          AdminCityDtoOutputCurrenciesInnerBuilder
        > {
  _$AdminCityDtoOutputCurrenciesInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _symbol;
  String? get symbol => _$this._symbol;
  set symbol(String? symbol) => _$this._symbol = symbol;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  bool? _isBase;
  bool? get isBase => _$this._isBase;
  set isBase(bool? isBase) => _$this._isBase = isBase;

  AdminCityDtoOutputCurrenciesInnerBuilder() {
    AdminCityDtoOutputCurrenciesInner._defaults(this);
  }

  AdminCityDtoOutputCurrenciesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _symbol = $v.symbol;
      _displayOrder = $v.displayOrder;
      _enabled = $v.enabled;
      _isBase = $v.isBase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityDtoOutputCurrenciesInner other) {
    _$v = other as _$AdminCityDtoOutputCurrenciesInner;
  }

  @override
  void update(
    void Function(AdminCityDtoOutputCurrenciesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityDtoOutputCurrenciesInner build() => _build();

  _$AdminCityDtoOutputCurrenciesInner _build() {
    final _$result =
        _$v ??
        _$AdminCityDtoOutputCurrenciesInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCityDtoOutputCurrenciesInner',
            'code',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminCityDtoOutputCurrenciesInner',
            'name',
          ),
          symbol: BuiltValueNullFieldError.checkNotNull(
            symbol,
            r'AdminCityDtoOutputCurrenciesInner',
            'symbol',
          ),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
            displayOrder,
            r'AdminCityDtoOutputCurrenciesInner',
            'displayOrder',
          ),
          enabled: BuiltValueNullFieldError.checkNotNull(
            enabled,
            r'AdminCityDtoOutputCurrenciesInner',
            'enabled',
          ),
          isBase: BuiltValueNullFieldError.checkNotNull(
            isBase,
            r'AdminCityDtoOutputCurrenciesInner',
            'isBase',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
