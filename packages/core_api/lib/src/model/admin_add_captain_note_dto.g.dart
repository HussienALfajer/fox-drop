// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_add_captain_note_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAddCaptainNoteDto extends AdminAddCaptainNoteDto {
  @override
  final String body;

  factory _$AdminAddCaptainNoteDto([
    void Function(AdminAddCaptainNoteDtoBuilder)? updates,
  ]) => (AdminAddCaptainNoteDtoBuilder()..update(updates))._build();

  _$AdminAddCaptainNoteDto._({required this.body}) : super._();
  @override
  AdminAddCaptainNoteDto rebuild(
    void Function(AdminAddCaptainNoteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAddCaptainNoteDtoBuilder toBuilder() =>
      AdminAddCaptainNoteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAddCaptainNoteDto && body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminAddCaptainNoteDto',
    )..add('body', body)).toString();
  }
}

class AdminAddCaptainNoteDtoBuilder
    implements Builder<AdminAddCaptainNoteDto, AdminAddCaptainNoteDtoBuilder> {
  _$AdminAddCaptainNoteDto? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminAddCaptainNoteDtoBuilder() {
    AdminAddCaptainNoteDto._defaults(this);
  }

  AdminAddCaptainNoteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAddCaptainNoteDto other) {
    _$v = other as _$AdminAddCaptainNoteDto;
  }

  @override
  void update(void Function(AdminAddCaptainNoteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAddCaptainNoteDto build() => _build();

  _$AdminAddCaptainNoteDto _build() {
    final _$result =
        _$v ??
        _$AdminAddCaptainNoteDto._(
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminAddCaptainNoteDto',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
