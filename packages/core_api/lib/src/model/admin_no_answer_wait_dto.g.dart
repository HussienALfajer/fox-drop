// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_no_answer_wait_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminNoAnswerWaitDto extends AdminNoAnswerWaitDto {
  @override
  final String message;

  factory _$AdminNoAnswerWaitDto([
    void Function(AdminNoAnswerWaitDtoBuilder)? updates,
  ]) => (AdminNoAnswerWaitDtoBuilder()..update(updates))._build();

  _$AdminNoAnswerWaitDto._({required this.message}) : super._();
  @override
  AdminNoAnswerWaitDto rebuild(
    void Function(AdminNoAnswerWaitDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNoAnswerWaitDtoBuilder toBuilder() =>
      AdminNoAnswerWaitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNoAnswerWaitDto && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminNoAnswerWaitDto',
    )..add('message', message)).toString();
  }
}

class AdminNoAnswerWaitDtoBuilder
    implements Builder<AdminNoAnswerWaitDto, AdminNoAnswerWaitDtoBuilder> {
  _$AdminNoAnswerWaitDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  AdminNoAnswerWaitDtoBuilder() {
    AdminNoAnswerWaitDto._defaults(this);
  }

  AdminNoAnswerWaitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNoAnswerWaitDto other) {
    _$v = other as _$AdminNoAnswerWaitDto;
  }

  @override
  void update(void Function(AdminNoAnswerWaitDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNoAnswerWaitDto build() => _build();

  _$AdminNoAnswerWaitDto _build() {
    final _$result =
        _$v ??
        _$AdminNoAnswerWaitDto._(
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'AdminNoAnswerWaitDto',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
