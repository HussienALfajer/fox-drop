// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_change_log_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainChangeLogDtoOutput extends AdminCaptainChangeLogDtoOutput {
  @override
  final BuiltList<AdminCaptainChangeLogDtoOutputEntriesInner> entries;

  factory _$AdminCaptainChangeLogDtoOutput([
    void Function(AdminCaptainChangeLogDtoOutputBuilder)? updates,
  ]) => (AdminCaptainChangeLogDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainChangeLogDtoOutput._({required this.entries}) : super._();
  @override
  AdminCaptainChangeLogDtoOutput rebuild(
    void Function(AdminCaptainChangeLogDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainChangeLogDtoOutputBuilder toBuilder() =>
      AdminCaptainChangeLogDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainChangeLogDtoOutput && entries == other.entries;
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
      r'AdminCaptainChangeLogDtoOutput',
    )..add('entries', entries)).toString();
  }
}

class AdminCaptainChangeLogDtoOutputBuilder
    implements
        Builder<
          AdminCaptainChangeLogDtoOutput,
          AdminCaptainChangeLogDtoOutputBuilder
        > {
  _$AdminCaptainChangeLogDtoOutput? _$v;

  ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminCaptainChangeLogDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminCaptainChangeLogDtoOutputBuilder() {
    AdminCaptainChangeLogDtoOutput._defaults(this);
  }

  AdminCaptainChangeLogDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainChangeLogDtoOutput other) {
    _$v = other as _$AdminCaptainChangeLogDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainChangeLogDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainChangeLogDtoOutput build() => _build();

  _$AdminCaptainChangeLogDtoOutput _build() {
    _$AdminCaptainChangeLogDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCaptainChangeLogDtoOutput._(entries: entries.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainChangeLogDtoOutput',
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
