// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_note_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationNoteDto extends AdminCaptainApplicationNoteDto {
  @override
  final String note;

  factory _$AdminCaptainApplicationNoteDto([
    void Function(AdminCaptainApplicationNoteDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationNoteDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationNoteDto._({required this.note}) : super._();
  @override
  AdminCaptainApplicationNoteDto rebuild(
    void Function(AdminCaptainApplicationNoteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationNoteDtoBuilder toBuilder() =>
      AdminCaptainApplicationNoteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationNoteDto && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainApplicationNoteDto',
    )..add('note', note)).toString();
  }
}

class AdminCaptainApplicationNoteDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationNoteDto,
          AdminCaptainApplicationNoteDtoBuilder
        > {
  _$AdminCaptainApplicationNoteDto? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCaptainApplicationNoteDtoBuilder() {
    AdminCaptainApplicationNoteDto._defaults(this);
  }

  AdminCaptainApplicationNoteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationNoteDto other) {
    _$v = other as _$AdminCaptainApplicationNoteDto;
  }

  @override
  void update(void Function(AdminCaptainApplicationNoteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationNoteDto build() => _build();

  _$AdminCaptainApplicationNoteDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationNoteDto._(
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCaptainApplicationNoteDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
