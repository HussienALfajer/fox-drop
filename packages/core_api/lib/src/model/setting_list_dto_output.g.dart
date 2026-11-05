// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingListDtoOutput extends SettingListDtoOutput {
  @override
  final BuiltList<SettingListDtoOutputSettingsInner> settings;

  factory _$SettingListDtoOutput([
    void Function(SettingListDtoOutputBuilder)? updates,
  ]) => (SettingListDtoOutputBuilder()..update(updates))._build();

  _$SettingListDtoOutput._({required this.settings}) : super._();
  @override
  SettingListDtoOutput rebuild(
    void Function(SettingListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SettingListDtoOutputBuilder toBuilder() =>
      SettingListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingListDtoOutput && settings == other.settings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, settings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SettingListDtoOutput',
    )..add('settings', settings)).toString();
  }
}

class SettingListDtoOutputBuilder
    implements Builder<SettingListDtoOutput, SettingListDtoOutputBuilder> {
  _$SettingListDtoOutput? _$v;

  ListBuilder<SettingListDtoOutputSettingsInner>? _settings;
  ListBuilder<SettingListDtoOutputSettingsInner> get settings =>
      _$this._settings ??= ListBuilder<SettingListDtoOutputSettingsInner>();
  set settings(ListBuilder<SettingListDtoOutputSettingsInner>? settings) =>
      _$this._settings = settings;

  SettingListDtoOutputBuilder() {
    SettingListDtoOutput._defaults(this);
  }

  SettingListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _settings = $v.settings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingListDtoOutput other) {
    _$v = other as _$SettingListDtoOutput;
  }

  @override
  void update(void Function(SettingListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingListDtoOutput build() => _build();

  _$SettingListDtoOutput _build() {
    _$SettingListDtoOutput _$result;
    try {
      _$result = _$v ?? _$SettingListDtoOutput._(settings: settings.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'settings';
        settings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SettingListDtoOutput',
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
