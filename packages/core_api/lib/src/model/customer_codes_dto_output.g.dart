// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_codes_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCodesDtoOutput extends CustomerCodesDtoOutput {
  @override
  final String? currency;
  @override
  final BuiltList<CustomerCodesDtoOutputCodesInner> codes;

  factory _$CustomerCodesDtoOutput([
    void Function(CustomerCodesDtoOutputBuilder)? updates,
  ]) => (CustomerCodesDtoOutputBuilder()..update(updates))._build();

  _$CustomerCodesDtoOutput._({this.currency, required this.codes}) : super._();
  @override
  CustomerCodesDtoOutput rebuild(
    void Function(CustomerCodesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCodesDtoOutputBuilder toBuilder() =>
      CustomerCodesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCodesDtoOutput &&
        currency == other.currency &&
        codes == other.codes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerCodesDtoOutput')
          ..add('currency', currency)
          ..add('codes', codes))
        .toString();
  }
}

class CustomerCodesDtoOutputBuilder
    implements Builder<CustomerCodesDtoOutput, CustomerCodesDtoOutputBuilder> {
  _$CustomerCodesDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  ListBuilder<CustomerCodesDtoOutputCodesInner>? _codes;
  ListBuilder<CustomerCodesDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<CustomerCodesDtoOutputCodesInner>();
  set codes(ListBuilder<CustomerCodesDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  CustomerCodesDtoOutputBuilder() {
    CustomerCodesDtoOutput._defaults(this);
  }

  CustomerCodesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _codes = $v.codes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCodesDtoOutput other) {
    _$v = other as _$CustomerCodesDtoOutput;
  }

  @override
  void update(void Function(CustomerCodesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCodesDtoOutput build() => _build();

  _$CustomerCodesDtoOutput _build() {
    _$CustomerCodesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerCodesDtoOutput._(currency: currency, codes: codes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'codes';
        codes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerCodesDtoOutput',
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
