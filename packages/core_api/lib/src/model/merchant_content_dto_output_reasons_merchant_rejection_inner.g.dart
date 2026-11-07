// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_content_dto_output_reasons_merchant_rejection_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantContentDtoOutputReasonsMerchantRejectionInner
    extends MerchantContentDtoOutputReasonsMerchantRejectionInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final bool needsText;

  factory _$MerchantContentDtoOutputReasonsMerchantRejectionInner([
    void Function(MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder)?
    updates,
  ]) =>
      (MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantContentDtoOutputReasonsMerchantRejectionInner._({
    required this.code,
    required this.label,
    required this.needsText,
  }) : super._();
  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInner rebuild(
    void Function(MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder toBuilder() =>
      MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantContentDtoOutputReasonsMerchantRejectionInner &&
        code == other.code &&
        label == other.label &&
        needsText == other.needsText;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, needsText.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('needsText', needsText))
        .toString();
  }
}

class MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
    implements
        Builder<
          MerchantContentDtoOutputReasonsMerchantRejectionInner,
          MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
        > {
  _$MerchantContentDtoOutputReasonsMerchantRejectionInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _needsText;
  bool? get needsText => _$this._needsText;
  set needsText(bool? needsText) => _$this._needsText = needsText;

  MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder() {
    MerchantContentDtoOutputReasonsMerchantRejectionInner._defaults(this);
  }

  MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _needsText = $v.needsText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantContentDtoOutputReasonsMerchantRejectionInner other) {
    _$v = other as _$MerchantContentDtoOutputReasonsMerchantRejectionInner;
  }

  @override
  void update(
    void Function(MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInner build() => _build();

  _$MerchantContentDtoOutputReasonsMerchantRejectionInner _build() {
    final _$result =
        _$v ??
        _$MerchantContentDtoOutputReasonsMerchantRejectionInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
            'label',
          ),
          needsText: BuiltValueNullFieldError.checkNotNull(
            needsText,
            r'MerchantContentDtoOutputReasonsMerchantRejectionInner',
            'needsText',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
