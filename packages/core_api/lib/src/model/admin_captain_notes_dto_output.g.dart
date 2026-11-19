// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_notes_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainNotesDtoOutput extends AdminCaptainNotesDtoOutput {
  @override
  final BuiltList<AdminCustomerDtoOutputNotesInner> notes;

  factory _$AdminCaptainNotesDtoOutput([
    void Function(AdminCaptainNotesDtoOutputBuilder)? updates,
  ]) => (AdminCaptainNotesDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainNotesDtoOutput._({required this.notes}) : super._();
  @override
  AdminCaptainNotesDtoOutput rebuild(
    void Function(AdminCaptainNotesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainNotesDtoOutputBuilder toBuilder() =>
      AdminCaptainNotesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainNotesDtoOutput && notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainNotesDtoOutput',
    )..add('notes', notes)).toString();
  }
}

class AdminCaptainNotesDtoOutputBuilder
    implements
        Builder<AdminCaptainNotesDtoOutput, AdminCaptainNotesDtoOutputBuilder> {
  _$AdminCaptainNotesDtoOutput? _$v;

  ListBuilder<AdminCustomerDtoOutputNotesInner>? _notes;
  ListBuilder<AdminCustomerDtoOutputNotesInner> get notes =>
      _$this._notes ??= ListBuilder<AdminCustomerDtoOutputNotesInner>();
  set notes(ListBuilder<AdminCustomerDtoOutputNotesInner>? notes) =>
      _$this._notes = notes;

  AdminCaptainNotesDtoOutputBuilder() {
    AdminCaptainNotesDtoOutput._defaults(this);
  }

  AdminCaptainNotesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notes = $v.notes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainNotesDtoOutput other) {
    _$v = other as _$AdminCaptainNotesDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainNotesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainNotesDtoOutput build() => _build();

  _$AdminCaptainNotesDtoOutput _build() {
    _$AdminCaptainNotesDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminCaptainNotesDtoOutput._(notes: notes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notes';
        notes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainNotesDtoOutput',
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
