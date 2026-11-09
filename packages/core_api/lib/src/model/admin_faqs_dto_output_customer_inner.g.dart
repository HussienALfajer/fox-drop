// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_faqs_dto_output_customer_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFaqsDtoOutputCustomerInner
    extends AdminFaqsDtoOutputCustomerInner {
  @override
  final String question;
  @override
  final String answer;

  factory _$AdminFaqsDtoOutputCustomerInner([
    void Function(AdminFaqsDtoOutputCustomerInnerBuilder)? updates,
  ]) => (AdminFaqsDtoOutputCustomerInnerBuilder()..update(updates))._build();

  _$AdminFaqsDtoOutputCustomerInner._({
    required this.question,
    required this.answer,
  }) : super._();
  @override
  AdminFaqsDtoOutputCustomerInner rebuild(
    void Function(AdminFaqsDtoOutputCustomerInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminFaqsDtoOutputCustomerInnerBuilder toBuilder() =>
      AdminFaqsDtoOutputCustomerInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFaqsDtoOutputCustomerInner &&
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
    return (newBuiltValueToStringHelper(r'AdminFaqsDtoOutputCustomerInner')
          ..add('question', question)
          ..add('answer', answer))
        .toString();
  }
}

class AdminFaqsDtoOutputCustomerInnerBuilder
    implements
        Builder<
          AdminFaqsDtoOutputCustomerInner,
          AdminFaqsDtoOutputCustomerInnerBuilder
        > {
  _$AdminFaqsDtoOutputCustomerInner? _$v;

  String? _question;
  String? get question => _$this._question;
  set question(String? question) => _$this._question = question;

  String? _answer;
  String? get answer => _$this._answer;
  set answer(String? answer) => _$this._answer = answer;

  AdminFaqsDtoOutputCustomerInnerBuilder() {
    AdminFaqsDtoOutputCustomerInner._defaults(this);
  }

  AdminFaqsDtoOutputCustomerInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _question = $v.question;
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFaqsDtoOutputCustomerInner other) {
    _$v = other as _$AdminFaqsDtoOutputCustomerInner;
  }

  @override
  void update(void Function(AdminFaqsDtoOutputCustomerInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFaqsDtoOutputCustomerInner build() => _build();

  _$AdminFaqsDtoOutputCustomerInner _build() {
    final _$result =
        _$v ??
        _$AdminFaqsDtoOutputCustomerInner._(
          question: BuiltValueNullFieldError.checkNotNull(
            question,
            r'AdminFaqsDtoOutputCustomerInner',
            'question',
          ),
          answer: BuiltValueNullFieldError.checkNotNull(
            answer,
            r'AdminFaqsDtoOutputCustomerInner',
            'answer',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
