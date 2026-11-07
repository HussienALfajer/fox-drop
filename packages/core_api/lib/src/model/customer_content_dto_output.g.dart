// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_content_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerContentDtoOutput extends CustomerContentDtoOutput {
  @override
  final CustomerContentDtoOutputReasons reasons;
  @override
  final BuiltList<MerchantContentDtoOutputFaqInner> faq;

  factory _$CustomerContentDtoOutput([
    void Function(CustomerContentDtoOutputBuilder)? updates,
  ]) => (CustomerContentDtoOutputBuilder()..update(updates))._build();

  _$CustomerContentDtoOutput._({required this.reasons, required this.faq})
    : super._();
  @override
  CustomerContentDtoOutput rebuild(
    void Function(CustomerContentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerContentDtoOutputBuilder toBuilder() =>
      CustomerContentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerContentDtoOutput &&
        reasons == other.reasons &&
        faq == other.faq;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, faq.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerContentDtoOutput')
          ..add('reasons', reasons)
          ..add('faq', faq))
        .toString();
  }
}

class CustomerContentDtoOutputBuilder
    implements
        Builder<CustomerContentDtoOutput, CustomerContentDtoOutputBuilder> {
  _$CustomerContentDtoOutput? _$v;

  CustomerContentDtoOutputReasonsBuilder? _reasons;
  CustomerContentDtoOutputReasonsBuilder get reasons =>
      _$this._reasons ??= CustomerContentDtoOutputReasonsBuilder();
  set reasons(CustomerContentDtoOutputReasonsBuilder? reasons) =>
      _$this._reasons = reasons;

  ListBuilder<MerchantContentDtoOutputFaqInner>? _faq;
  ListBuilder<MerchantContentDtoOutputFaqInner> get faq =>
      _$this._faq ??= ListBuilder<MerchantContentDtoOutputFaqInner>();
  set faq(ListBuilder<MerchantContentDtoOutputFaqInner>? faq) =>
      _$this._faq = faq;

  CustomerContentDtoOutputBuilder() {
    CustomerContentDtoOutput._defaults(this);
  }

  CustomerContentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasons = $v.reasons.toBuilder();
      _faq = $v.faq.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerContentDtoOutput other) {
    _$v = other as _$CustomerContentDtoOutput;
  }

  @override
  void update(void Function(CustomerContentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerContentDtoOutput build() => _build();

  _$CustomerContentDtoOutput _build() {
    _$CustomerContentDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerContentDtoOutput._(
            reasons: reasons.build(),
            faq: faq.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
        _$failedField = 'faq';
        faq.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerContentDtoOutput',
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
