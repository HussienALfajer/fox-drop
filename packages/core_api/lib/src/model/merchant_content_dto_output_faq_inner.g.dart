// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_content_dto_output_faq_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantContentDtoOutputFaqInner
    extends MerchantContentDtoOutputFaqInner {
  @override
  final String question;
  @override
  final String answer;

  factory _$MerchantContentDtoOutputFaqInner([
    void Function(MerchantContentDtoOutputFaqInnerBuilder)? updates,
  ]) => (MerchantContentDtoOutputFaqInnerBuilder()..update(updates))._build();

  _$MerchantContentDtoOutputFaqInner._({
    required this.question,
    required this.answer,
  }) : super._();
  @override
  MerchantContentDtoOutputFaqInner rebuild(
    void Function(MerchantContentDtoOutputFaqInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantContentDtoOutputFaqInnerBuilder toBuilder() =>
      MerchantContentDtoOutputFaqInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantContentDtoOutputFaqInner &&
        question == other.question &&
        answer == other.answer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, question.hashCode);
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantContentDtoOutputFaqInner')
          ..add('question', question)
          ..add('answer', answer))
        .toString();
  }
}

class MerchantContentDtoOutputFaqInnerBuilder
    implements
        Builder<
          MerchantContentDtoOutputFaqInner,
          MerchantContentDtoOutputFaqInnerBuilder
        > {
  _$MerchantContentDtoOutputFaqInner? _$v;

  String? _question;
  String? get question => _$this._question;
  set question(String? question) => _$this._question = question;

  String? _answer;
  String? get answer => _$this._answer;
  set answer(String? answer) => _$this._answer = answer;

  MerchantContentDtoOutputFaqInnerBuilder() {
    MerchantContentDtoOutputFaqInner._defaults(this);
  }

  MerchantContentDtoOutputFaqInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _question = $v.question;
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantContentDtoOutputFaqInner other) {
    _$v = other as _$MerchantContentDtoOutputFaqInner;
  }

  @override
  void update(void Function(MerchantContentDtoOutputFaqInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantContentDtoOutputFaqInner build() => _build();

  _$MerchantContentDtoOutputFaqInner _build() {
    final _$result =
        _$v ??
        _$MerchantContentDtoOutputFaqInner._(
          question: BuiltValueNullFieldError.checkNotNull(
            question,
            r'MerchantContentDtoOutputFaqInner',
            'question',
          ),
          answer: BuiltValueNullFieldError.checkNotNull(
            answer,
            r'MerchantContentDtoOutputFaqInner',
            'answer',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
