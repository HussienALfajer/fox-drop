// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_current_drawer_session_dto_output_session_currencies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner
    extends AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner {
  @override
  final String currency;
  @override
  final String openingFloat;
  @override
  final String expected;
  @override
  final String? counted;
  @override
  final String? variance;

  factory _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner([
    void Function(
      AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner._({
    required this.currency,
    required this.openingFloat,
    required this.expected,
    this.counted,
    this.variance,
  }) : super._();
  @override
  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner rebuild(
    void Function(
      AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder toBuilder() =>
      AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner &&
        currency == other.currency &&
        openingFloat == other.openingFloat &&
        expected == other.expected &&
        counted == other.counted &&
        variance == other.variance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, openingFloat.hashCode);
    _$hash = $jc(_$hash, expected.hashCode);
    _$hash = $jc(_$hash, counted.hashCode);
    _$hash = $jc(_$hash, variance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner',
          )
          ..add('currency', currency)
          ..add('openingFloat', openingFloat)
          ..add('expected', expected)
          ..add('counted', counted)
          ..add('variance', variance))
        .toString();
  }
}

class AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder
    implements
        Builder<
          AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner,
          AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder
        > {
  _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _openingFloat;
  String? get openingFloat => _$this._openingFloat;
  set openingFloat(String? openingFloat) => _$this._openingFloat = openingFloat;

  String? _expected;
  String? get expected => _$this._expected;
  set expected(String? expected) => _$this._expected = expected;

  String? _counted;
  String? get counted => _$this._counted;
  set counted(String? counted) => _$this._counted = counted;

  String? _variance;
  String? get variance => _$this._variance;
  set variance(String? variance) => _$this._variance = variance;

  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder() {
    AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner._defaults(this);
  }

  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _openingFloat = $v.openingFloat;
      _expected = $v.expected;
      _counted = $v.counted;
      _variance = $v.variance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner other) {
    _$v = other as _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner;
  }

  @override
  void update(
    void Function(
      AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner build() => _build();

  _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner _build() {
    final _$result =
        _$v ??
        _$AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner',
            'currency',
          ),
          openingFloat: BuiltValueNullFieldError.checkNotNull(
            openingFloat,
            r'AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner',
            'openingFloat',
          ),
          expected: BuiltValueNullFieldError.checkNotNull(
            expected,
            r'AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner',
            'expected',
          ),
          counted: counted,
          variance: variance,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
