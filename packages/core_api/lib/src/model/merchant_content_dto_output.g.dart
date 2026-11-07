// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_content_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantContentDtoOutput extends MerchantContentDtoOutput {
  @override
  final MerchantContentDtoOutputReasons reasons;
  @override
  final BuiltList<MerchantContentDtoOutputFaqInner> faq;

  factory _$MerchantContentDtoOutput([
    void Function(MerchantContentDtoOutputBuilder)? updates,
  ]) => (MerchantContentDtoOutputBuilder()..update(updates))._build();

  _$MerchantContentDtoOutput._({required this.reasons, required this.faq})
    : super._();
  @override
  MerchantContentDtoOutput rebuild(
    void Function(MerchantContentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantContentDtoOutputBuilder toBuilder() =>
      MerchantContentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantContentDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantContentDtoOutput')
          ..add('reasons', reasons)
          ..add('faq', faq))
        .toString();
  }
}

class MerchantContentDtoOutputBuilder
    implements
        Builder<MerchantContentDtoOutput, MerchantContentDtoOutputBuilder> {
  _$MerchantContentDtoOutput? _$v;

  MerchantContentDtoOutputReasonsBuilder? _reasons;
  MerchantContentDtoOutputReasonsBuilder get reasons =>
      _$this._reasons ??= MerchantContentDtoOutputReasonsBuilder();
  set reasons(MerchantContentDtoOutputReasonsBuilder? reasons) =>
      _$this._reasons = reasons;

  ListBuilder<MerchantContentDtoOutputFaqInner>? _faq;
  ListBuilder<MerchantContentDtoOutputFaqInner> get faq =>
      _$this._faq ??= ListBuilder<MerchantContentDtoOutputFaqInner>();
  set faq(ListBuilder<MerchantContentDtoOutputFaqInner>? faq) =>
      _$this._faq = faq;

  MerchantContentDtoOutputBuilder() {
    MerchantContentDtoOutput._defaults(this);
  }

  MerchantContentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasons = $v.reasons.toBuilder();
      _faq = $v.faq.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantContentDtoOutput other) {
    _$v = other as _$MerchantContentDtoOutput;
  }

  @override
  void update(void Function(MerchantContentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantContentDtoOutput build() => _build();

  _$MerchantContentDtoOutput _build() {
    _$MerchantContentDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantContentDtoOutput._(
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
          r'MerchantContentDtoOutput',
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
