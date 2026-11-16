// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_suggested_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputSuggestedCode
    extends CustomerQuoteDtoOutputSuggestedCode {
  @override
  final String code;
  @override
  final String discount;

  factory _$CustomerQuoteDtoOutputSuggestedCode([
    void Function(CustomerQuoteDtoOutputSuggestedCodeBuilder)? updates,
  ]) =>
      (CustomerQuoteDtoOutputSuggestedCodeBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputSuggestedCode._({
    required this.code,
    required this.discount,
  }) : super._();
  @override
  CustomerQuoteDtoOutputSuggestedCode rebuild(
    void Function(CustomerQuoteDtoOutputSuggestedCodeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputSuggestedCodeBuilder toBuilder() =>
      CustomerQuoteDtoOutputSuggestedCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputSuggestedCode &&
        code == other.code &&
        discount == other.discount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputSuggestedCode')
          ..add('code', code)
          ..add('discount', discount))
        .toString();
  }
}

class CustomerQuoteDtoOutputSuggestedCodeBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputSuggestedCode,
          CustomerQuoteDtoOutputSuggestedCodeBuilder
        > {
  _$CustomerQuoteDtoOutputSuggestedCode? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  CustomerQuoteDtoOutputSuggestedCodeBuilder() {
    CustomerQuoteDtoOutputSuggestedCode._defaults(this);
  }

  CustomerQuoteDtoOutputSuggestedCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _discount = $v.discount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteDtoOutputSuggestedCode other) {
    _$v = other as _$CustomerQuoteDtoOutputSuggestedCode;
  }

  @override
  void update(
    void Function(CustomerQuoteDtoOutputSuggestedCodeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputSuggestedCode build() => _build();

  _$CustomerQuoteDtoOutputSuggestedCode _build() {
    final _$result =
        _$v ??
        _$CustomerQuoteDtoOutputSuggestedCode._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'CustomerQuoteDtoOutputSuggestedCode',
            'code',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'CustomerQuoteDtoOutputSuggestedCode',
            'discount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
