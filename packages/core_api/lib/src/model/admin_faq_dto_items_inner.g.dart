// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_faq_dto_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFaqDtoItemsInner extends AdminFaqDtoItemsInner {
  @override
  final String question;
  @override
  final String answer;

  factory _$AdminFaqDtoItemsInner([
    void Function(AdminFaqDtoItemsInnerBuilder)? updates,
  ]) => (AdminFaqDtoItemsInnerBuilder()..update(updates))._build();

  _$AdminFaqDtoItemsInner._({required this.question, required this.answer})
    : super._();
  @override
  AdminFaqDtoItemsInner rebuild(
    void Function(AdminFaqDtoItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminFaqDtoItemsInnerBuilder toBuilder() =>
      AdminFaqDtoItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFaqDtoItemsInner &&
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
    return (newBuiltValueToStringHelper(r'AdminFaqDtoItemsInner')
          ..add('question', question)
          ..add('answer', answer))
        .toString();
  }
}

class AdminFaqDtoItemsInnerBuilder
    implements Builder<AdminFaqDtoItemsInner, AdminFaqDtoItemsInnerBuilder> {
  _$AdminFaqDtoItemsInner? _$v;

  String? _question;
  String? get question => _$this._question;
  set question(String? question) => _$this._question = question;

  String? _answer;
  String? get answer => _$this._answer;
  set answer(String? answer) => _$this._answer = answer;

  AdminFaqDtoItemsInnerBuilder() {
    AdminFaqDtoItemsInner._defaults(this);
  }

  AdminFaqDtoItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _question = $v.question;
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFaqDtoItemsInner other) {
    _$v = other as _$AdminFaqDtoItemsInner;
  }

  @override
  void update(void Function(AdminFaqDtoItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFaqDtoItemsInner build() => _build();

  _$AdminFaqDtoItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminFaqDtoItemsInner._(
          question: BuiltValueNullFieldError.checkNotNull(
            question,
            r'AdminFaqDtoItemsInner',
            'question',
          ),
          answer: BuiltValueNullFieldError.checkNotNull(
            answer,
            r'AdminFaqDtoItemsInner',
            'answer',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
