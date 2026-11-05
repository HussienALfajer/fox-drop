// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_history_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingHistoryDtoOutput extends SettingHistoryDtoOutput {
  @override
  final BuiltList<SettingHistoryDtoOutputChangesInner> changes;

  factory _$SettingHistoryDtoOutput([
    void Function(SettingHistoryDtoOutputBuilder)? updates,
  ]) => (SettingHistoryDtoOutputBuilder()..update(updates))._build();

  _$SettingHistoryDtoOutput._({required this.changes}) : super._();
  @override
  SettingHistoryDtoOutput rebuild(
    void Function(SettingHistoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SettingHistoryDtoOutputBuilder toBuilder() =>
      SettingHistoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingHistoryDtoOutput && changes == other.changes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SettingHistoryDtoOutput',
    )..add('changes', changes)).toString();
  }
}

class SettingHistoryDtoOutputBuilder
    implements
        Builder<SettingHistoryDtoOutput, SettingHistoryDtoOutputBuilder> {
  _$SettingHistoryDtoOutput? _$v;

  ListBuilder<SettingHistoryDtoOutputChangesInner>? _changes;
  ListBuilder<SettingHistoryDtoOutputChangesInner> get changes =>
      _$this._changes ??= ListBuilder<SettingHistoryDtoOutputChangesInner>();
  set changes(ListBuilder<SettingHistoryDtoOutputChangesInner>? changes) =>
      _$this._changes = changes;

  SettingHistoryDtoOutputBuilder() {
    SettingHistoryDtoOutput._defaults(this);
  }

  SettingHistoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changes = $v.changes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingHistoryDtoOutput other) {
    _$v = other as _$SettingHistoryDtoOutput;
  }

  @override
  void update(void Function(SettingHistoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingHistoryDtoOutput build() => _build();

  _$SettingHistoryDtoOutput _build() {
    _$SettingHistoryDtoOutput _$result;
    try {
      _$result = _$v ?? _$SettingHistoryDtoOutput._(changes: changes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SettingHistoryDtoOutput',
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
