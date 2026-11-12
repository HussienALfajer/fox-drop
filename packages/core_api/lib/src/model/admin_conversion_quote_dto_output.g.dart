// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_conversion_quote_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminConversionQuoteDtoOutput extends AdminConversionQuoteDtoOutput {
  @override
  final String from;
  @override
  final String to;
  @override
  final String amount;
  @override
  final String converted;
  @override
  final BuiltList<AdminConversionQuoteDtoOutputRatesInner> rates;
  @override
  final AdminConversionQuoteDtoOutputUnit unit;

  factory _$AdminConversionQuoteDtoOutput([
    void Function(AdminConversionQuoteDtoOutputBuilder)? updates,
  ]) => (AdminConversionQuoteDtoOutputBuilder()..update(updates))._build();

  _$AdminConversionQuoteDtoOutput._({
    required this.from,
    required this.to,
    required this.amount,
    required this.converted,
    required this.rates,
    required this.unit,
  }) : super._();
  @override
  AdminConversionQuoteDtoOutput rebuild(
    void Function(AdminConversionQuoteDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminConversionQuoteDtoOutputBuilder toBuilder() =>
      AdminConversionQuoteDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminConversionQuoteDtoOutput &&
        from == other.from &&
        to == other.to &&
        amount == other.amount &&
        converted == other.converted &&
        rates == other.rates &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, converted.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminConversionQuoteDtoOutput')
          ..add('from', from)
          ..add('to', to)
          ..add('amount', amount)
          ..add('converted', converted)
          ..add('rates', rates)
          ..add('unit', unit))
        .toString();
  }
}

class AdminConversionQuoteDtoOutputBuilder
    implements
        Builder<
          AdminConversionQuoteDtoOutput,
          AdminConversionQuoteDtoOutputBuilder
        > {
  _$AdminConversionQuoteDtoOutput? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _converted;
  String? get converted => _$this._converted;
  set converted(String? converted) => _$this._converted = converted;

  ListBuilder<AdminConversionQuoteDtoOutputRatesInner>? _rates;
  ListBuilder<AdminConversionQuoteDtoOutputRatesInner> get rates =>
      _$this._rates ??= ListBuilder<AdminConversionQuoteDtoOutputRatesInner>();
  set rates(ListBuilder<AdminConversionQuoteDtoOutputRatesInner>? rates) =>
      _$this._rates = rates;

  AdminConversionQuoteDtoOutputUnitBuilder? _unit;
  AdminConversionQuoteDtoOutputUnitBuilder get unit =>
      _$this._unit ??= AdminConversionQuoteDtoOutputUnitBuilder();
  set unit(AdminConversionQuoteDtoOutputUnitBuilder? unit) =>
      _$this._unit = unit;

  AdminConversionQuoteDtoOutputBuilder() {
    AdminConversionQuoteDtoOutput._defaults(this);
  }

  AdminConversionQuoteDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _amount = $v.amount;
      _converted = $v.converted;
      _rates = $v.rates.toBuilder();
      _unit = $v.unit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminConversionQuoteDtoOutput other) {
    _$v = other as _$AdminConversionQuoteDtoOutput;
  }

  @override
  void update(void Function(AdminConversionQuoteDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminConversionQuoteDtoOutput build() => _build();

  _$AdminConversionQuoteDtoOutput _build() {
    _$AdminConversionQuoteDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminConversionQuoteDtoOutput._(
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminConversionQuoteDtoOutput',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminConversionQuoteDtoOutput',
              'to',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminConversionQuoteDtoOutput',
              'amount',
            ),
            converted: BuiltValueNullFieldError.checkNotNull(
              converted,
              r'AdminConversionQuoteDtoOutput',
              'converted',
            ),
            rates: rates.build(),
            unit: unit.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rates';
        rates.build();
        _$failedField = 'unit';
        unit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminConversionQuoteDtoOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
