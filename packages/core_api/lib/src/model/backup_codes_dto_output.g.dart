// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_codes_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupCodesDtoOutput extends BackupCodesDtoOutput {
  @override
  final BuiltList<String> backupCodes;

  factory _$BackupCodesDtoOutput([
    void Function(BackupCodesDtoOutputBuilder)? updates,
  ]) => (BackupCodesDtoOutputBuilder()..update(updates))._build();

  _$BackupCodesDtoOutput._({required this.backupCodes}) : super._();
  @override
  BackupCodesDtoOutput rebuild(
    void Function(BackupCodesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BackupCodesDtoOutputBuilder toBuilder() =>
      BackupCodesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupCodesDtoOutput && backupCodes == other.backupCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, backupCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'BackupCodesDtoOutput',
    )..add('backupCodes', backupCodes)).toString();
  }
}

class BackupCodesDtoOutputBuilder
    implements Builder<BackupCodesDtoOutput, BackupCodesDtoOutputBuilder> {
  _$BackupCodesDtoOutput? _$v;

  ListBuilder<String>? _backupCodes;
  ListBuilder<String> get backupCodes =>
      _$this._backupCodes ??= ListBuilder<String>();
  set backupCodes(ListBuilder<String>? backupCodes) =>
      _$this._backupCodes = backupCodes;

  BackupCodesDtoOutputBuilder() {
    BackupCodesDtoOutput._defaults(this);
  }

  BackupCodesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _backupCodes = $v.backupCodes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupCodesDtoOutput other) {
    _$v = other as _$BackupCodesDtoOutput;
  }

  @override
  void update(void Function(BackupCodesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupCodesDtoOutput build() => _build();

  _$BackupCodesDtoOutput _build() {
    _$BackupCodesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$BackupCodesDtoOutput._(backupCodes: backupCodes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'backupCodes';
        backupCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'BackupCodesDtoOutput',
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
