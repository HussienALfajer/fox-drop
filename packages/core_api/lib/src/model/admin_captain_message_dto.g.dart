// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_message_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainMessageDto extends AdminCaptainMessageDto {
  @override
  final String text;

  factory _$AdminCaptainMessageDto([
    void Function(AdminCaptainMessageDtoBuilder)? updates,
  ]) => (AdminCaptainMessageDtoBuilder()..update(updates))._build();

  _$AdminCaptainMessageDto._({required this.text}) : super._();
  @override
  AdminCaptainMessageDto rebuild(
    void Function(AdminCaptainMessageDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainMessageDtoBuilder toBuilder() =>
      AdminCaptainMessageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainMessageDto && text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainMessageDto',
    )..add('text', text)).toString();
  }
}

class AdminCaptainMessageDtoBuilder
    implements Builder<AdminCaptainMessageDto, AdminCaptainMessageDtoBuilder> {
  _$AdminCaptainMessageDto? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  AdminCaptainMessageDtoBuilder() {
    AdminCaptainMessageDto._defaults(this);
  }

  AdminCaptainMessageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainMessageDto other) {
    _$v = other as _$AdminCaptainMessageDto;
  }

  @override
  void update(void Function(AdminCaptainMessageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainMessageDto build() => _build();

  _$AdminCaptainMessageDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainMessageDto._(
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'AdminCaptainMessageDto',
            'text',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
