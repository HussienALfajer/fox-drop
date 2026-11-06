// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_picker_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPickerDtoOutput extends AdminPickerDtoOutput {
  @override
  final BuiltList<AdminPickerDtoOutputCaptainsInner> captains;

  factory _$AdminPickerDtoOutput([
    void Function(AdminPickerDtoOutputBuilder)? updates,
  ]) => (AdminPickerDtoOutputBuilder()..update(updates))._build();

  _$AdminPickerDtoOutput._({required this.captains}) : super._();
  @override
  AdminPickerDtoOutput rebuild(
    void Function(AdminPickerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPickerDtoOutputBuilder toBuilder() =>
      AdminPickerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPickerDtoOutput && captains == other.captains;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminPickerDtoOutput',
    )..add('captains', captains)).toString();
  }
}

class AdminPickerDtoOutputBuilder
    implements Builder<AdminPickerDtoOutput, AdminPickerDtoOutputBuilder> {
  _$AdminPickerDtoOutput? _$v;

  ListBuilder<AdminPickerDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminPickerDtoOutputCaptainsInner> get captains =>
      _$this._captains ??= ListBuilder<AdminPickerDtoOutputCaptainsInner>();
  set captains(ListBuilder<AdminPickerDtoOutputCaptainsInner>? captains) =>
      _$this._captains = captains;

  AdminPickerDtoOutputBuilder() {
    AdminPickerDtoOutput._defaults(this);
  }

  AdminPickerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captains = $v.captains.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPickerDtoOutput other) {
    _$v = other as _$AdminPickerDtoOutput;
  }

  @override
  void update(void Function(AdminPickerDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPickerDtoOutput build() => _build();

  _$AdminPickerDtoOutput _build() {
    _$AdminPickerDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminPickerDtoOutput._(captains: captains.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPickerDtoOutput',
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
