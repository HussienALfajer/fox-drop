// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_content_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainContentDtoOutput extends CaptainContentDtoOutput {
  @override
  final CaptainContentDtoOutputReasons reasons;
  @override
  final BuiltList<MerchantContentDtoOutputFaqInner> faq;
  @override
  final String workRules;

  factory _$CaptainContentDtoOutput([
    void Function(CaptainContentDtoOutputBuilder)? updates,
  ]) => (CaptainContentDtoOutputBuilder()..update(updates))._build();

  _$CaptainContentDtoOutput._({
    required this.reasons,
    required this.faq,
    required this.workRules,
  }) : super._();
  @override
  CaptainContentDtoOutput rebuild(
    void Function(CaptainContentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainContentDtoOutputBuilder toBuilder() =>
      CaptainContentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainContentDtoOutput &&
        reasons == other.reasons &&
        faq == other.faq &&
        workRules == other.workRules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, faq.hashCode);
    _$hash = $jc(_$hash, workRules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainContentDtoOutput')
          ..add('reasons', reasons)
          ..add('faq', faq)
          ..add('workRules', workRules))
        .toString();
  }
}

class CaptainContentDtoOutputBuilder
    implements
        Builder<CaptainContentDtoOutput, CaptainContentDtoOutputBuilder> {
  _$CaptainContentDtoOutput? _$v;

  CaptainContentDtoOutputReasonsBuilder? _reasons;
  CaptainContentDtoOutputReasonsBuilder get reasons =>
      _$this._reasons ??= CaptainContentDtoOutputReasonsBuilder();
  set reasons(CaptainContentDtoOutputReasonsBuilder? reasons) =>
      _$this._reasons = reasons;

  ListBuilder<MerchantContentDtoOutputFaqInner>? _faq;
  ListBuilder<MerchantContentDtoOutputFaqInner> get faq =>
      _$this._faq ??= ListBuilder<MerchantContentDtoOutputFaqInner>();
  set faq(ListBuilder<MerchantContentDtoOutputFaqInner>? faq) =>
      _$this._faq = faq;

  String? _workRules;
  String? get workRules => _$this._workRules;
  set workRules(String? workRules) => _$this._workRules = workRules;

  CaptainContentDtoOutputBuilder() {
    CaptainContentDtoOutput._defaults(this);
  }

  CaptainContentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasons = $v.reasons.toBuilder();
      _faq = $v.faq.toBuilder();
      _workRules = $v.workRules;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainContentDtoOutput other) {
    _$v = other as _$CaptainContentDtoOutput;
  }

  @override
  void update(void Function(CaptainContentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainContentDtoOutput build() => _build();

  _$CaptainContentDtoOutput _build() {
    _$CaptainContentDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainContentDtoOutput._(
            reasons: reasons.build(),
            faq: faq.build(),
            workRules: BuiltValueNullFieldError.checkNotNull(
              workRules,
              r'CaptainContentDtoOutput',
              'workRules',
            ),
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
          r'CaptainContentDtoOutput',
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
