// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_entries_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualEntriesDtoOutput extends AdminManualEntriesDtoOutput {
  @override
  final BuiltList<AdminManualEntriesDtoOutputEntriesInner> entries;

  factory _$AdminManualEntriesDtoOutput([
    void Function(AdminManualEntriesDtoOutputBuilder)? updates,
  ]) => (AdminManualEntriesDtoOutputBuilder()..update(updates))._build();

  _$AdminManualEntriesDtoOutput._({required this.entries}) : super._();
  @override
  AdminManualEntriesDtoOutput rebuild(
    void Function(AdminManualEntriesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualEntriesDtoOutputBuilder toBuilder() =>
      AdminManualEntriesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualEntriesDtoOutput && entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminManualEntriesDtoOutput',
    )..add('entries', entries)).toString();
  }
}

class AdminManualEntriesDtoOutputBuilder
    implements
        Builder<
          AdminManualEntriesDtoOutput,
          AdminManualEntriesDtoOutputBuilder
        > {
  _$AdminManualEntriesDtoOutput? _$v;

  ListBuilder<AdminManualEntriesDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminManualEntriesDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminManualEntriesDtoOutputEntriesInner>();
  set entries(ListBuilder<AdminManualEntriesDtoOutputEntriesInner>? entries) =>
      _$this._entries = entries;

  AdminManualEntriesDtoOutputBuilder() {
    AdminManualEntriesDtoOutput._defaults(this);
  }

  AdminManualEntriesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualEntriesDtoOutput other) {
    _$v = other as _$AdminManualEntriesDtoOutput;
  }

  @override
  void update(void Function(AdminManualEntriesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualEntriesDtoOutput build() => _build();

  _$AdminManualEntriesDtoOutput _build() {
    _$AdminManualEntriesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminManualEntriesDtoOutput._(entries: entries.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminManualEntriesDtoOutput',
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
