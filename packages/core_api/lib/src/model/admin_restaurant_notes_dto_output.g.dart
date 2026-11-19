// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_notes_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantNotesDtoOutput extends AdminRestaurantNotesDtoOutput {
  @override
  final BuiltList<AdminCustomerDtoOutputNotesInner> notes;

  factory _$AdminRestaurantNotesDtoOutput([
    void Function(AdminRestaurantNotesDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantNotesDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantNotesDtoOutput._({required this.notes}) : super._();
  @override
  AdminRestaurantNotesDtoOutput rebuild(
    void Function(AdminRestaurantNotesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantNotesDtoOutputBuilder toBuilder() =>
      AdminRestaurantNotesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantNotesDtoOutput && notes == other.notes;
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
      r'AdminRestaurantNotesDtoOutput',
    )..add('notes', notes)).toString();
  }
}

class AdminRestaurantNotesDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantNotesDtoOutput,
          AdminRestaurantNotesDtoOutputBuilder
        > {
  _$AdminRestaurantNotesDtoOutput? _$v;

  ListBuilder<AdminCustomerDtoOutputNotesInner>? _notes;
  ListBuilder<AdminCustomerDtoOutputNotesInner> get notes =>
      _$this._notes ??= ListBuilder<AdminCustomerDtoOutputNotesInner>();
  set notes(ListBuilder<AdminCustomerDtoOutputNotesInner>? notes) =>
      _$this._notes = notes;

  AdminRestaurantNotesDtoOutputBuilder() {
    AdminRestaurantNotesDtoOutput._defaults(this);
  }

  AdminRestaurantNotesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notes = $v.notes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantNotesDtoOutput other) {
    _$v = other as _$AdminRestaurantNotesDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantNotesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantNotesDtoOutput build() => _build();

  _$AdminRestaurantNotesDtoOutput _build() {
    _$AdminRestaurantNotesDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminRestaurantNotesDtoOutput._(notes: notes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notes';
        notes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantNotesDtoOutput',
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
