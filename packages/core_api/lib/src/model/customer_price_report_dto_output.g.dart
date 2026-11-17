// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_price_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPriceReportDtoOutput extends CustomerPriceReportDtoOutput {
  @override
  final String number;

  factory _$CustomerPriceReportDtoOutput([
    void Function(CustomerPriceReportDtoOutputBuilder)? updates,
  ]) => (CustomerPriceReportDtoOutputBuilder()..update(updates))._build();

  _$CustomerPriceReportDtoOutput._({required this.number}) : super._();
  @override
  CustomerPriceReportDtoOutput rebuild(
    void Function(CustomerPriceReportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPriceReportDtoOutputBuilder toBuilder() =>
      CustomerPriceReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPriceReportDtoOutput && number == other.number;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerPriceReportDtoOutput',
    )..add('number', number)).toString();
  }
}

class CustomerPriceReportDtoOutputBuilder
    implements
        Builder<
          CustomerPriceReportDtoOutput,
          CustomerPriceReportDtoOutputBuilder
        > {
  _$CustomerPriceReportDtoOutput? _$v;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CustomerPriceReportDtoOutputBuilder() {
    CustomerPriceReportDtoOutput._defaults(this);
  }

  CustomerPriceReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPriceReportDtoOutput other) {
    _$v = other as _$CustomerPriceReportDtoOutput;
  }

  @override
  void update(void Function(CustomerPriceReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPriceReportDtoOutput build() => _build();

  _$CustomerPriceReportDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerPriceReportDtoOutput._(
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CustomerPriceReportDtoOutput',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
